#include "KBInfoListController.h"
#import <Preferences/PSTableCell.h>

@implementation KBInfoListController
- (UIColor *)cellsBackgroundColorForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return UIColor.whiteColor;
    }
    return UIColor.clearColor;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableCell *cell = (PSTableCell *)[super tableView:tableView
                                  cellForRowAtIndexPath:indexPath];
    cell.titleLabel.numberOfLines = 0;
    return cell;
}
@end