//
//  TableViewCell.h
//  SocketIOChat
//
//  Created by Nguyen Huu Nam on 11/22/16.
//  Copyright © 2016 Nguyen Huu Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userStatus;

@end
