//
//  ChatViewController.m
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatViewController.h"

@interface ChatViewController ()
{
    CGRect originalViewFrame;
}

@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)sendButtonTapped:(UIButton *)sender;

- (void)setUIToNotConnectedState;
- (void)setUIToConnectedState;
- (void)resetView;

@end

@implementation ChatViewController

MCSession *session;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textInput.delegate = self;
    originalViewFrame = self.view.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
        NSString *str = self.textInput.text;
        [session sendData:[str dataUsingEncoding:NSASCIIStringEncoding]
                   toPeers:peerIDs
                  withMode:MCSessionSendDataReliable error:nil];
        self.textInput.text = @"";
        [self.textInput resignFirstResponder];
        // echo in the local text view
        self.textView.text = [NSString stringWithFormat:@"%@\n> %@", self.textView.text, str];
    }
}

#pragma mark
#pragma mark <MCSessionDelegate> methods

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString *str = [[NSString alloc] initWithData:data
                                          encoding:NSASCIIStringEncoding];
    NSLog(@"Received data: %@", str);
    if ([str hasPrefix:@"\x04\vstreamtype"])
        str = @"call established";
    NSString *tempStr = [NSString stringWithFormat:@"%@\nMsg from %@: %@",
                         self.textView.text,
                         peerID.displayName,
                         str];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = tempStr;
    });
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

- (void)resetView
{
    self.view.frame = originalViewFrame;
}

@end
