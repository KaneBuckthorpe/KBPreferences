#include "KBStyledListController.h"
#import <Preferences/PSTableCell.h>
#import <objc/runtime.h>

@implementation KBStyledListController
- (void)viewWillAppear:(BOOL)arg1 {
    [super viewWillAppear:arg1];
}
- (UIColor *)navigationBarTint {
    return [UIColor colorWithRed:0.285 green:0.723 blue:1.00 alpha:1.0];
}

- (UIColor *)cellsValueColorForRowAtIndexPath:indexPath{
    return self.navigationBarTint;
}
- (UIColor *)navigationBarBackgroundTint {
    return UIColor.whiteColor;
}
- (NSArray <UIColor *>*)backgroundGradientColors {
    return [NSArray arrayWithObjects:[UIColor colorWithRed:34.0 / 255.0
                                                       green:211 / 255.0
                                                        blue:198 / 255.0
                                                       alpha:1.0],
                                  [UIColor colorWithRed:145 / 255.0
                                                       green:72.0 / 255.0
                                                        blue:203 / 255.0
                                                       alpha:1.0],
                                  nil];
}

- (UIColor *)headerTextColor {
    return UIColor.whiteColor;
}
@end