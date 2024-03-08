#import "TableViewController.h"
#import "StoryDataSource.h"
#import "ModalViewController.h"
#import "Animator.h"

@interface TableViewController ()

@property (nonatomic, strong) Animator *transition;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<NSMutableArray <NSString *> *> *filteredStories;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transition = [Animator animatorWithDuration:0.5];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    self.view.backgroundColor = UIColor.blackColor;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];

    self.searchController = [[UISearchController alloc] init];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.barTintColor = UIColor.blackColor;
    self.searchController.searchBar.searchTextField.textColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.filteredStories = [NSMutableArray arrayWithCapacity:STORIES.count];
    [self.filteredStories addObject:[NSMutableArray array]];
    for (NSUInteger i = 0; i < STORIES.count; i++) {
        [self.filteredStories addObject:[NSMutableArray array]];
    }
    self.definesPresentationContext = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.searchController.active) {
        self.searchController.active = NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return STORIES.count;
}

- (BOOL) displayFiltered {
    return self.searchController.active && self.searchController.searchBar.text.length > 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self displayFiltered] ? [self.filteredStories objectAtIndex:section].count : [STORIES objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self displayFiltered] ? self.filteredStories[indexPath.section][indexPath.row] : STORIES[indexPath.section][indexPath.row];
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.backgroundColor = UIColor.blackColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    while (cell.gestureRecognizers.count) {
        [cell removeGestureRecognizer:[cell.gestureRecognizers objectAtIndex:0]];
    }
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(presentModalViewWithText:)];
    longpress.minimumPressDuration = 0.2;
    [cell addGestureRecognizer: longpress];
    return cell;
}

- (void)presentModalViewWithText:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UINotificationFeedbackGenerator *feedbackGenerator = [UINotificationFeedbackGenerator new];
        [feedbackGenerator notificationOccurred:UINotificationFeedbackTypeSuccess];

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
    headerLabel.text = [NSString stringWithFormat:@"Category %ld", section + 1];
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

#pragma mark - Search

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject localizedCaseInsensitiveContainsString:searchText];
        }];

        for (NSUInteger i = 0; i < STORIES.count; i++) {
            [self.filteredStories[i] removeAllObjects];
            [self.filteredStories[i] addObjectsFromArray:[STORIES[i] filteredArrayUsingPredicate:predicate]];
        }
    }
    [self.tableView reloadData];
}

@end
