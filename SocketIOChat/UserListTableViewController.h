//
//  UserListTableViewController.h
//  SocketIOChat
//
//  Created by Nguyen Huu Nam on 11/22/16.
//  Copyright © 2016 Nguyen Huu Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableViewListUser;

@end
