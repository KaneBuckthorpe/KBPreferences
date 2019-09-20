#include "KBPListController.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <objc/runtime.h>

@interface PSTableCell ()
@property(nonatomic, retain) UILabel *valueLabel;
@end

@implementation KBPListController
CAGradientLayer *gradient;


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableCell *cell = (PSTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
		NSString*dependsID=(NSString*)[cell.specifier propertyForKey:@"dependsOnID"];
		cell.cellEnabled=dependsID ? [[self valueForSpeciferID:dependsID]boolValue]: YES;	
    }

return cell;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];

	for (PSSpecifier* otherSpecifier in self.specifiers){
		if ([[otherSpecifier propertyForKey:@"dependsOnID"] isEqualToString:specifier.identifier]){
			PSTableCell *cell = (PSTableCell *)[self tableView:self.table cellForRowAtIndexPath:[self indexPathForSpecifier:otherSpecifier]];
			cell.cellEnabled=[value boolValue];
		}
	}
}

-(id)valueForSpeciferID:(NSString*)identifier{
	
	return [self readPreferenceValue:[self specifierForID:identifier]];
}

- (void)viewWillTransitionToSize:(CGSize)size 
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{       
	       [super viewWillTransitionToSize:size 
       withTransitionCoordinator:coordinator];
       
           [self setTableColors];
       }

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self setTableColors];
	if (kCFCoreFoundationVersionNumber>=1240.10){///iOS9+
		NSMutableArray *cgGradientColors = [NSMutableArray new];
		[self.backgroundGradientColors
		enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx,BOOL *stop) {
			if ([color isKindOfClass:[UIColor class]]) {
				CGColorRef colorRef = color.CGColor;
				[cgGradientColors addObject:(__bridge id)colorRef];
			}
		}];
		
		gradient = [CAGradientLayer layer];
		gradient.frame = self.view.bounds;
		gradient.startPoint = CGPointZero;
		gradient.endPoint = CGPointMake(1.5, 1.5);
		gradient.colors = cgGradientColors;
		[self.view.layer insertSublayer:gradient atIndex:0];
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	if (kCFCoreFoundationVersionNumber>=1240.10){///iOS9+
		gradient.frame = self.view.bounds;
	}
	[self setTableColors];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.tintColor=nil;
	self.navigationController.navigationController.navigationBar.barTintColor=nil;        
}

-(void)tableView:(UITableView*)tableView willDisplayCell:(PSTableCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
	
	cell.backgroundColor = [self cellsBackgroundColorForRowAtIndexPath:indexPath];
	cell.textLabel.textColor = [self cellsTextColorForRowAtIndexPath:indexPath];
	cell.valueLabel.textColor = [self cellsValueColorForRowAtIndexPath:indexPath];
	UIView *shapeView = [[UIView alloc] initWithFrame:cell.bounds];
	shapeView.backgroundColor = UIColor.whiteColor;
	
	UIBezierPath *maskPath;
	if ([self rowsForGroup:indexPath.section] == 1) {
		maskPath=[UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:[self cornerRadiiForSection:indexPath.section]];
	} else if (indexPath.row == 0) {
		maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerTopRight cornerRadii:[self cornerRadiiForSection:indexPath.section]];
	} else if (indexPath.row == [self rowsForGroup:indexPath.section] - 1) {
		maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:[self cornerRadiiForSection:indexPath.section]];
	} else {
		maskPath = [UIBezierPath bezierPathWithRect:cell.bounds];
	}
	
	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.frame = cell.bounds;
	maskLayer.path = maskPath.CGPath;
	cell.layer.mask = maskLayer;
	cell.layer.shadowPath = maskPath.CGPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (kCFCoreFoundationVersionNumber>=1240.10){
		PSTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		return [(PSSpecifier *)cell.specifier propertyForKey:@"height"] ? [[(PSSpecifier *)cell.specifier propertyForKey:@"height"] floatValue]: [super tableView:tableView heightForRowAtIndexPath:indexPath];
	} else{
		return [super tableView:tableView heightForRowAtIndexPath:indexPath];
	}
}

- (CGSize)cornerRadiiForSection:(NSInteger)section{
	return CGSizeMake(10, 10);
}

- (UIColor *)cellsBackgroundColorForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UIColor.whiteColor;
}

- (UIColor *)controlsColor{
	return UIColor.blackColor;
}

- (UIColor *)cellsTextColorForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UIColor.blackColor;
}

- (UIColor *)cellsValueColorForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [UIColor colorWithRed:0.557 green:0.557 blue:0.58 alpha:1.0];
}

- (UIColor *)navigationBarTint {
	return nil;
}

- (UIColor *)navigationBarBackgroundTint {
	return nil;
}

- (NSArray<UIColor *> *)backgroundGradientColors {
	return nil;
}

- (void)setTableColors {
	BOOL iOS12AndPlus = kCFCoreFoundationVersionNumber > 1550;
	if (iOS12AndPlus){
		self.table.backgroundColor=UIColor.clearColor;
	}
	self.navigationController.navigationController.navigationBar.tintColor = self.navigationBarTint;
	self.navigationController.navigationController.navigationBar.barTintColor = self.navigationBarBackgroundTint;
	
	self.table.layer.shadowOpacity = 0.2;
	self.table.layer.shadowOffset = CGSizeMake(0, -2);
	self.table.layer.shadowRadius = 2.0f;
	if (kCFCoreFoundationVersionNumber>=1240.10){///iOS9+
		[UITableView appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]].backgroundColor =UIColor.clearColor;
	[UITableView appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]].separatorColor = UIColor.clearColor;
	[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]].tintColor = self.controlsColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]].onTintColor = self.controlsColor;
	[UISlider appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]].thumbTintColor = self.controlsColor;
	[UIStepper appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]].tintColor = self.controlsColor;
	}else{
	[UITableView appearanceWhenContainedIn:[self.class class], nil].separatorColor = UIColor.clearColor;
	[UISegmentedControl appearanceWhenContainedIn:[self.class class], nil].tintColor = self.controlsColor;
	[UISwitch appearanceWhenContainedIn:[self.class class], nil].onTintColor = self.controlsColor;
	[UISlider appearanceWhenContainedIn:[self.class class], nil].thumbTintColor = self.controlsColor;
	[UIStepper appearanceWhenContainedIn:[self.class class], nil].tintColor = self.controlsColor;
	}
}

@end