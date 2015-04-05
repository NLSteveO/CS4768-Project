//
//  ChatViewController.h
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//
//  Comments are the source file
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define SERVICE_TYPE @"Tic-Tac-Toe"

extern MCSession *session;  // session declared globally here. import header file to use in other classes

@interface ChatViewController : UIViewController <UITextFieldDelegate,MCSessionDelegate, MCBrowserViewControllerDelegate>

@end
