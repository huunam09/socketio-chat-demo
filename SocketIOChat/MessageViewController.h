//
//  MessageViewController.h
//  SocketIOChat
//
//  Created by Nguyen Huu Nam on 11/23/16.
//  Copyright © 2016 Nguyen Huu Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"
@import SocketIO;

//JSQMessagesViewController
@interface MessageViewController : JSQMessagesViewController

@property (nonatomic,strong) NSString* nickName;
@property (nonatomic,strong) NSString* receivedName;
@property (nonatomic,strong) SocketIOClient* socketIO;
@property (strong, nonatomic) NSMutableArray *messages;
@property (copy, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

@end
