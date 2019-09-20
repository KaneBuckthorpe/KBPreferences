#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

@interface KBCustomController: PSViewController
@end


@implementation KBCustomController
@end
@interface KBCustomCell : PSTableCell
@end


@implementation KBCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
[specifier setProperty:@"KBCustomController" forKey:@"detail"];
	    UIView*colorView=[[UIView alloc] initWithFrame:CGRectMake(0,0,51,31)];
	    colorView.backgroundColor=UIColor.blackColor;
	    colorView.layer.cornerRadius=5;
	    ///set your uicontol (usually UISlider, UISwitch ect)
        self.accessoryView = colorView;

}
    return self;
}
/*
- (KBCustomControl *)newControl {
    KBCustomControl *control = [[KBCustomControl alloc] initWithFrame:CGRectZero]; //or frame
    return control;
}
*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
	  	    
    }
}
@end
