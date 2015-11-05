//
//  AzStackTestController.m
//
//

#import "AzStackTestController.h"
#import "ThirdPartyImplement.h"

@implementation AzStackTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"AzStack Test";
    self.tableCells = @[@"Chat with user2", @"Group chat", @"Create Group", @"Chat History",@"Call user2"];
 
    [ThirdPartyImplement instance].navForChatController = self.navigationController;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* text = self.tableCells[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableViewTableCell"];
    if (!cell) {
        cell = [UITableViewCell new];
    }
    cell.textLabel.text = text;
    
    cell.backgroundView=[[UIView alloc] initWithFrame:cell.bounds];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//chat with user2
        [self.navigationController pushViewController:[[AzStackManager instance] chatWithUser:@"user2" withUserInfo:@{@"name": @"User 2"} ] animated:YES];
    } else if(indexPath.row == 1){//Group chat
        [self.navigationController pushViewController:[[AzStackManager instance] chatWithGroup:@[@"user2", @"user3", @"user4"] withGroupInfo:@{@"name": @"Group 1"} ] animated:YES];
    } else if(indexPath.row == 2){//Create group
        [self.navigationController pushViewController:[[AzStackManager instance] createChatGroup] animated:YES];
    } else if (indexPath.row == 3) {//chat history
        [self.navigationController pushViewController:[[AzStackManager instance] getChattingHistory] animated:YES];
    } else if (indexPath.row == 4){//call user2
        [[AzStackManager instance] callWithUser:@"user2" withUserInfo:@{@"name": @"User 2"} ];
    }
}

@end
