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
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(presentModalViewWithText:)];
    longpress.minimumPressDuration = 0.2;
    [cell addGestureRecognizer: longpress];
    return cell;
}

- (void)presentModalViewWithText:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [feedbackGenerator prepare];
        [feedbackGenerator impactOccurred];

        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[gestureRecognizer locationInView:self.tableView]];
        if (indexPath) {
            ModalViewController *modalViewController = [[ModalViewController alloc] initWithText:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            modalViewController.transitioningDelegate = self;
            [self presentViewController:modalViewController animated:YES completion:nil];
        }
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
