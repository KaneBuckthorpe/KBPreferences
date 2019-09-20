#import "KBStepperCell.h"
#import <Preferences/PSSpecifier.h>

@interface KBStepperCell () {
    NSString *title;

}
@property (nonatomic, retain) UIStepper *control;
@property (nonatomic, retain) UILabel *valueLabel;
@end

@implementation KBStepperCell
@dynamic control;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
        self.accessoryView = self.control;

UIStepper *stepper =(UIStepper*)self.control;

self.showPercentage=[[specifier propertyForKey:@"self.showPercentage"]boolValue];

stepper.maximumValue = [specifier propertyForKey:@"maximum"]?[[specifier propertyForKey:@"maximum"]doubleValue]:100;
stepper.value =[specifier propertyForKey:@"default"]?[[specifier propertyForKey:@"default"]doubleValue]:50;
stepper.minimumValue = [specifier propertyForKey:@"minimum"]?[[specifier propertyForKey:@"minimum"]doubleValue]:0;
stepper.stepValue=[specifier propertyForKey:@"stepValue"]?[[specifier propertyForKey:@"stepValue"]doubleValue]: (stepper.maximumValue-stepper.minimumValue)/10;

self.valueLabel=[UILabel new];
     [self addSubview:self.valueLabel];
}
    return self;
}
-(void)layoutSubviews{
[super layoutSubviews];

float spacing=15;

CGRect accessoryViewFrame = self.accessoryView.frame;
accessoryViewFrame.origin.x = self.frame.size.width-self.accessoryView.frame.size.width-spacing;
accessoryViewFrame.size.height = self.frame.size.height;
self.accessoryView.frame = accessoryViewFrame;


self.valueLabel.frame=CGRectMake(accessoryViewFrame.origin.x-spacing-50, 0, 55, self.frame.size.height);
self.valueLabel.textAlignment = NSTextAlignmentRight; 

self.textLabel.textColor = [UIColor blackColor]; 
self.textLabel.frame=CGRectMake(spacing, 0, self.valueLabel.frame.origin.x-spacing, self.frame.size.height);

}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
self.showPercentage=[[specifier propertyForKey:@"showPercentage"]boolValue];
    [self _updateLabel];
}

- (UIStepper *)newControl {
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];

    stepper.continuous = YES;
    return stepper;
}

- (NSNumber *)controlValue {
    return @(self.control.value);
}

- (void)setValue:(NSNumber *)value {
    [super setValue:value];
    self.control.value = value.doubleValue;
}

- (void)controlChanged:(UIStepper *)stepper {
    [super controlChanged:stepper];
    [self _updateLabel];
}

- (void)_updateLabel {
    if (!self.control) {
        return;
    }

    float value =self.control.value;
    self.valueLabel.text = self.showPercentage ? [NSString stringWithFormat:@"%.0f%%", value] : [NSString stringWithFormat:@"%.2f",value];
    [self setNeedsLayout];
}

@end
