//
//  GameViewController.m
//  Project
//
//  Created by Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatViewController.h"
#import "GLKit/GLKit.h"

@interface GameViewController : GLKViewController

@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
//@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextView *statusView;

@property (weak, nonatomic) IBOutlet UIButton *browseButton;
@property (strong, nonatomic) MCAdvertiserAssistant *assistant;
@property (strong, nonatomic) MCBrowserViewController *browserVC;

- (IBAction)browseButtonTapped:(UIButton *)sender;
- (IBAction)disconnectButtonTapped:(UIButton *)sender;

@end

@implementation GameViewController

MCSession *session;

-(void) viewDidLoad {
    
    //do we need session stuff here?
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
- (IBAction)browseButtonTapped:(UIButton *)sender {
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:session];
    self.browserVC.delegate = self;
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (IBAction)disconnectButtonTapped:(UIButton *)sender {
    [session disconnect];
    [self setUIToNotConnectedState];
}

#pragma mark
#pragma mark <MCSessionDelegate> methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSString *str = [NSString stringWithFormat:@"Status: %@", peerID.displayName];
    if (state == MCSessionStateConnected)
    {
        self.statusView.text = [str stringByAppendingString:@" connected"];
        [self setUIToConnectedState];
    }
    else if (state == MCSessionStateNotConnected)
        self.statusView.text = [str stringByAppendingString:@" not connected"];
}

- (void)setUIToNotConnectedState
{
    //self.sendButton.enabled = NO;
    self.disconnectButton.enabled = NO;
    self.browseButton.enabled = YES;
}

- (void)setUIToConnectedState
{
    //self.sendButton.enabled = YES;
    self.disconnectButton.enabled = YES;
    self.browseButton.enabled = NO;
}

@end
