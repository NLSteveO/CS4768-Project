//
//  ChatViewController.h
//  Project
//
//  Created by Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <AVFoundation/AVAudioSession.h>
#import <GameKit/GKPublicProtocols.h>

#define SERVICE_TYPE @"Tic-Tac-Toe"

extern MCSession *session;  // session declared globally here. import header file to use in other classes

@interface ChatViewController : UIViewController <UITextFieldDelegate,MCSessionDelegate, MCBrowserViewControllerDelegate>

@end
