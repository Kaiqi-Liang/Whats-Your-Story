//
//  TableViewController.m
//  What's Your Story
//
//  Created by ByteDance on 2/23/24.
//

#import "TableViewController.h"
#import "StoryDataSource.h"

@interface TableViewController ()

@property NSArray<NSArray<NSString *> *> *stories;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stories = STORIES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.view.backgroundColor = UIColor.blackColor;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.stories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stories objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.stories[indexPath.section][indexPath.row];
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.backgroundColor = UIColor.blackColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [UILabel new];
    headerLabel.text = [self titleForSection:section];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor blackColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    return headerLabel;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForSection:section];
}

- (NSString *)titleForSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Category %ld", section];
}

@end
