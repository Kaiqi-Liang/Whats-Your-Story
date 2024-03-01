#import "TableViewController.h"
#import "StoryDataSource.h"
#import "ModalViewController.h"
#import "Animator.h"

@interface TableViewController ()

@property (nonatomic, copy) NSArray<NSArray<NSString *> *> *stories;
@property (nonatomic, strong) Animator *transition;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stories = STORIES;
    self.transition = [Animator animator:0.5];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
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
    [cell addGestureRecognizer: [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(presentModalViewWithText:)]];
    return cell;
}

- (void)presentModalViewWithText:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        ModalViewController *modalViewController = [[ModalViewController alloc] initWithText:cell.textLabel.text];
        modalViewController.transitioningDelegate = self;
        [self presentViewController:modalViewController animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [UILabel new];
    headerLabel.text = [self titleForSection:section];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = UIColor.blackColor;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    return headerLabel;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.transition;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForSection:section];
}

- (NSString *)titleForSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Category %ld", section + 1];
}

@end
