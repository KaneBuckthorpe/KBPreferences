#import <Preferences/PSListController.h>

@interface KBPListController : PSListController <UITableViewDataSource, UITableViewDelegate>
- (NSArray <UIColor *>*)backgroundGradientColors;
- (UIColor *)navigationBarBackgroundTint;
- (UIColor *)navigationBarTint;
- (UIColor *)cellsBackgroundColorForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)cellsValueColorForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)cellsTextColorForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)controlsColor;
- (CGSize)cornerRadiiForSection:(NSInteger)section;
@end