//
//  ChatViewController.m
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatViewController.h"
#import "GameViewController.h"

@interface ChatViewController ()
{
    CGRect originalViewFrame;
}

@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) MCAdvertiserAssistant *assistant;
@property (strong, nonatomic) MCBrowserViewController *browserVC;

@property int number;
@property GameViewController *gvc;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)sendButtonTapped:(UIButton *)sender;
- (IBAction)connectButtonTapped:(UIButton *)sender;
- (IBAction)disconnectButtonTapped:(UIButton *)sender;

- (void)setUIToNotConnectedState;
- (void)setUIToConnectedState;
- (void)resetView;
- (void)clearText;

@end

@implementation ChatViewController

MCSession *session;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textInput.delegate = self;
    originalViewFrame = self.view.frame;
    
    // Prepare session
    MCPeerID *myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    session = [[MCSession alloc] initWithPeer:myPeerID];
    session.delegate = self;
    // Start advertising
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:session];
    [self.assistant start];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.gvc = [[GameViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark <UITextFieldDelegate> methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textInput resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark selectors

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self resetView];
    // Get the size of the keyboard.
    CGRect keyboardFrameInWindow = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.view.frame;
    [UIView beginAnimations: @"moveUp" context: nil];
    [UIView setAnimationDuration:0.29];
    float height = [self.view convertRect:keyboardFrameInWindow fromView:nil].size.height;
    self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations: @"moveDown" context: nil];
    [UIView setAnimationDuration:0.29];
    [self resetView];
    [UIView commitAnimations];
    return;
}

- (IBAction)sendButtonTapped:(UIButton *)sender {
    if ([session.connectedPeers count] > 0) {
        NSArray *peerIDs = session.connectedPeers;
        NSString *str = [NSString stringWithFormat:@"c:%@",self.textInput.text];
        [session sendData:[str dataUsingEncoding:NSASCIIStringEncoding]
                   toPeers:peerIDs
                  withMode:MCSessionSendDataReliable error:nil];
        self.textInput.text = @"";
        [self.textInput resignFirstResponder];
        // echo in the local text view
        str = [str substringFromIndex:2];
        self.textView.text = [NSString stringWithFormat:@"%@\n> %@", self.textView.text, str];
    }
}

- (IBAction)connectButtonTapped:(UIButton *)sender {
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:session];
    self.browserVC.delegate = self;
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (IBAction)disconnectButtonTapped:(UIButton *)sender {
    [session disconnect];
    [self setUIToNotConnectedState];
    [self clearText];
}

- (void)clearText {
    self.textView.text = @"";
}

#pragma mark
#pragma mark <MCBrowserViewControllerDelegate> methods

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark <MCSessionDelegate> methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSString *str = [NSString stringWithFormat:@"Status: %@", peerID.displayName];
    if (state == MCSessionStateConnected)
    {
      //  dispatch_async(dispatch_get_main_queue(), ^{
            _number = arc4random()%100;
            NSString *str2 = [NSString stringWithFormat:@"s:%d", _number];
            [session sendData:[str2 dataUsingEncoding:NSASCIIStringEncoding]
                      toPeers:session.connectedPeers
                     withMode:MCSessionSendDataReliable error:nil];
            self.statusLabel.text = [str stringByAppendingString:@" connected"];
            [self setUIToConnectedState];
       // });
    }
    else if (state == MCSessionStateNotConnected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = [str stringByAppendingString:@" not connected"];
            [self setUIToNotConnectedState];
            [self clearText];
        });
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSString *str = [[NSString alloc] initWithData:data
                                          encoding:NSASCIIStringEncoding];
    NSLog(@"Received data: %@", str);
    if ([str hasPrefix:@"c:"]) {
        str = [str substringFromIndex:2];
        NSString *tempStr = [NSString stringWithFormat:@"%@\nMsg from %@: %@",
                         self.textView.text,
                         peerID.displayName,
                         str];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = tempStr;
        });
    }
    else if ([str hasPrefix:@"s:"]) {
        str = [str substringFromIndex:2];
        //dispatch_async(dispatch_get_main_queue(), ^{
            int opponentNumber = [str intValue];
            if (_number > opponentNumber) {
                NSLog(@"Our turn");
                [self.gvc setTurn: YES];
            }
            else if (_number < opponentNumber) {
                NSLog(@"Their turn");
                [self.gvc setTurn: NO];
            }
            else {
                _number = arc4random();
                NSString *str = [NSString stringWithFormat:@"s:%d", _number];
                [session sendData:[str dataUsingEncoding:NSASCIIStringEncoding]
                      toPeers:session.connectedPeers
                     withMode:MCSessionSendDataReliable error:nil];

            }
        //});
    }
    else if ([str hasPrefix:@"g:"]) {
        str = [str substringFromIndex:2];
        [self.gvc recieveMove:[str intValue]];
        [self.gvc setTurn:YES];
    }
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

- (NSString *)participantID
{
    return session.myPeerID.displayName;
}

#pragma mark
#pragma mark helpers
- (void)setUIToNotConnectedState
{
    self.sendButton.enabled = NO;
    self.disconnectButton.enabled = NO;
    self.connectButton.enabled = YES;
}

- (void)setUIToConnectedState
{
    self.sendButton.enabled = YES;
    self.disconnectButton.enabled = YES;
    self.connectButton.enabled = NO;
}

- (void)resetView
{
    self.view.frame = originalViewFrame;
}

@end
