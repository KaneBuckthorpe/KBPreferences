#include "KBHeaderListController.h"
#import <Preferences/PSTableCell.h>
#import <objc/runtime.h>

@implementation KBHeaderListController
- (void)viewWillAppear:(BOOL)arg1 {
	if (kCFCoreFoundationVersionNumber>=1240.10){///iOS9+
    self.navigationItem.titleView = [UIView new];
    self.tableHeaderLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                 UIScreen.mainScreen.bounds.size.height *
                                     0.17)];
    self.tableHeaderLabel.backgroundColor = UIColor.clearColor;
    self.tableHeaderLabel.text = self.title;
    self.tableHeaderLabel.adjustsFontSizeToFitWidth = YES;
    self.tableHeaderLabel.numberOfLines = 1;
    self.tableHeaderLabel.minimumScaleFactor = 0;
    self.tableHeaderLabel.textAlignment = NSTextAlignmentCenter;
    self.tableHeaderLabel.font = [UIFont systemFontOfSize:50];
    self.tableHeaderLabel.textColor = self.headerTextColor;
    self.tableHeaderLabel.clipsToBounds = YES;
    self.tableHeaderLabel.layer.masksToBounds = YES;
}
    [super viewWillAppear:arg1];
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.tableHeaderLabel) {
        return self.tableHeaderLabel.frame.size.height;
    } else {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}


- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.tableHeaderLabel;
    } else {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
}

- (UIColor *)headerTextColor {
    return UIColor.blackColor;
}
@end