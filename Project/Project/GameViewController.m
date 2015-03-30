//
//  GameViewController.m
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import "GameViewController.h"
#import "ChatViewController.h"

@interface GameViewController() {
    
}

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) MCAdvertiserAssistant *assistant;
@property (strong, nonatomic) MCBrowserViewController *browserVC;

- (IBAction)connectButtonTapped:(UIButton *)sender;
- (IBAction)disconnectButtonTapped:(UIButton *)sender;

@end

@implementation GameViewController

MCSession *session;

-(void) viewDidLoad {
    
    //do we need session stuff here?
    // Prepare session
    MCPeerID *myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    session = [[MCSession alloc] initWithPeer:myPeerID];
    session.delegate = self;
    // Start advertising
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:session];
    [self.assistant start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Event handlers
- (IBAction)connectButtonTapped:(UIButton *)sender {
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:session];
    self.browserVC.delegate = self;
    [self presentViewController:self.browserVC animated:YES completion:nil];
}


- (IBAction)disconnectButtonTapped:(UIButton *)sender {
    [session disconnect];
    [self setUIToNotConnectedState];
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
        self.statusLabel.text = [str stringByAppendingString:@" connected"];
        [self setUIToConnectedState];
    }
    else if (state == MCSessionStateNotConnected)
        self.statusLabel.text = [str stringByAppendingString:@" not connected"];
}

- (void)setUIToNotConnectedState
{
    //self.sendButton.enabled = NO;
    self.disconnectButton.enabled = NO;
    self.connectButton.enabled = YES;
}

- (void)setUIToConnectedState
{
    //self.sendButton.enabled = YES;
    self.disconnectButton.enabled = YES;
    self.connectButton.enabled = NO;
}

@end
