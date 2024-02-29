#import <UIKit/UIKit.h>

@protocol MainViewControllerDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger) index;
- (void)didDeselectItemAtIndex:(NSInteger) index;

@end

@interface CollectionViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id <MainViewControllerDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

