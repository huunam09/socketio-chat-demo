//
//  UserListTableViewController.m
//  SocketIOChat
//
//  Created by Nguyen Huu Nam on 11/22/16.
//  Copyright © 2016 Nguyen Huu Nam. All rights reserved.
//

#import "UserListTableViewController.h"
#import "Helper.h"
#import "TableViewCell.h"
#import "MessageViewController.h"
#import <ISMessages/ISMessages.h>
@import SocketIO;

@interface UserListTableViewController ()

@end

@implementation UserListTableViewController{
    NSMutableArray *listUser;
    NSString *nickName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize table data
    self.tableViewListUser.delegate = self;
    self.tableViewListUser.dataSource = self;
    self.tableViewListUser.tableHeaderView = [UIView new];
    listUser = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(nickName == nil){
        [self askForNickname];
    }
}

- (void)createSocketCheck {
    NSURL* url = [[NSURL alloc] initWithString:SERVER_LINK];
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];

    NSArray* dataNickName = [NSArray arrayWithObjects:nickName, nil];
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        [socket emit:@"connectUser" with:dataNickName];
    }];
    
    [socket on:@"userList" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSMutableArray *dataUserList = [data objectAtIndex:0];
        listUser = dataUserList;
        [self.tableViewListUser reloadData];
    }];
//    
//    [socket on:@"newChatMessage" callback:^(NSArray* data, SocketAckEmitter* ack) {
//        ISMessages* alert = [ISMessages cardAlertWithTitle:data[0]
//                                                   message:data[1]
//                                                 iconImage:nil
//                                                  duration:3.f
//                                               hideOnSwipe:YES
//                                                 hideOnTap:YES
//                                                 alertType:ISAlertTypeSuccess
//                                             alertPosition:ISAlertPositionTop];        
//        [alert show:^{
//            NSLog(@"Callback is working!");
//        }];
//    }];
    
    [socket connect];
}

#pragma mark - More Function

- (void)askForNickname {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"SocketChat"
                                                                              message: @"Please enter a nickname:"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"NickName";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        self.navigationItem.title = [NSString stringWithFormat:@"Hello : %@",namefield.text];
        nickName = namefield.text;
        [self createSocketCheck];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listUser count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    }
    NSDictionary *userData = [listUser objectAtIndex:indexPath.row];
    cell.userNameLabel.text = [userData objectForKey:@"nickname"];
    cell.userStatus.text = [[userData objectForKey:@"isConnected"] boolValue] ? @"Online" : @"Offline";
    cell.userStatus.textColor = [[userData objectForKey:@"isConnected"] boolValue] ? [UIColor greenColor] : [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userData = [listUser objectAtIndex:indexPath.row];
    if([[userData objectForKey:@"isConnected"] boolValue]){
        MessageViewController * mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"messageViewController"];
        [mVC setNickName:nickName];
        [mVC setReceivedName:[userData objectForKey:@"nickname"]];
        [self.navigationController pushViewController:mVC animated:YES];
    }else{
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"User offline" message:@"Please select other user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        // Display Alert Message
        [messageAlert show];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"messageViewController"]) {
//        NSIndexPath *indexPath = [self.tableViewListUser indexPathForSelectedRow];
//        NSDictionary *userData = [listUser objectAtIndex:indexPath.row];
//        MessageViewController *messageViewController = segue.destinationViewController;
////        messageViewController.nickName = [userData objectForKey:@"nickname"];
//    }
//}


@end
