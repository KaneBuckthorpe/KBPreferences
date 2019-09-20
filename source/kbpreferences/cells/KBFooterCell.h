#import <Preferences/PSTableCell.h>

@interface KBFooterCell :PSTableCell <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView*socialButtonsTable;
@property (nonatomic, strong) NSArray*socialLinks;
@end