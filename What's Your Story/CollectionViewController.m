#import "CollectionViewController.h"
#import "StoryDataSource.h"
#import "Colour.h"

@interface CollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL hasAnimated;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(200, 70);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.blackColor;
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
    NSArray *categories = [[NSUserDefaults standardUserDefaults] arrayForKey:@"categories"];
    for (int i = 0; i < categories.count; ++i) {
        if ([categories[i] isEqual: @YES]) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.hasAnimated) {
        self.hasAnimated = YES;
        for (uint8_t i = 0; i < self.collectionView.visibleCells.count; ++i) {
            UICollectionViewCell *cell = self.collectionView.visibleCells[i];
            cell.alpha = 0;
            [UIView animateWithDuration:0.2 delay:0.5 + 0.2 * i options:0 animations:^{
                cell.alpha = 1;
            } completion:nil];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return STORIES.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.blackColor;
    NSArray<UIView *> *subviews = cell.contentView.subviews;
    [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat: @"Category %ld", (long)(indexPath.row + 1)];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = UIColor.whiteColor;
    [cell.contentView addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:cell.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor],
    ]];

    UIView* backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    backgroundView.backgroundColor = UIColor.blackColor;
    cell.backgroundView = backgroundView;
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = Color.blueColor;
    cell.selectedBackgroundView = selectedBGView;
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didDeselectItemAtIndex:)]) {
        [self.delegate didDeselectItemAtIndex:indexPath.row];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

@end
