#import "KBFooterCell.h"
#import <Preferences/PSSpecifier.h>

@interface KBCSocialCell : UICollectionViewCell <UIScrollViewDelegate>
@property(nonatomic, strong) UIImageView *socialImageView;
@property(nonatomic, retain) NSString *socialPlatform;
- (void)openSocialLink:(NSString *)platform;
@end

@implementation KBCSocialCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = UIColor.clearColor;
        self.socialImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.socialImageView.backgroundColor = UIColor.clearColor;
        self.socialImageView.clipsToBounds = YES;
        self.socialImageView.userInteractionEnabled = YES;
        self.socialImageView.layer.masksToBounds = YES;

        [self addSubview:self.socialImageView];
    }
    return self;
}
- (void)openSocialLink:(NSString *)path {

    NSURL *url = [NSURL URLWithString:path];
    [[UIApplication sharedApplication] openURL:url];
}
@end

@interface KBImageProvider : NSObject
+ (instancetype)sharedProvider;
- (BOOL)hasImageForPath:(NSString *)path;
- (UIImage *)imageForPath:(NSString *)path;
- (void)cacheImage:(UIImage *)image forPath:(NSString *)path;
@end

@implementation KBImageProvider {
    NSCache *_imageCache;
}

#pragma mark - Class Methods

+ (instancetype)sharedProvider {
    static dispatch_once_t once;
    static id sharedProvider;
    dispatch_once(&once, ^{
      sharedProvider = [self new];
    });
    return sharedProvider;
}

#pragma mark - Instance Methods

- (UIImage *)imageForPath:(NSString *)path {
    return [_imageCache objectForKey:path];
}

- (BOOL)hasImageForPath:(NSString *)path {
    if (!_imageCache || ![_imageCache objectForKey:path]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)cacheImage:(UIImage *)image forPath:(NSString *)path {
    if (!_imageCache) {
        _imageCache = [NSCache new];
    }
    [_imageCache setObject:image forKey:path];
}

@end

@implementation KBFooterCell {
    KBImageProvider *_sharedImageProvider;
}
float height;
float inset;
float leftInset;
float imageInset;
float contentWidth;
float contentHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier
                      specifier:specifier];
    if (self) {
        _sharedImageProvider = [KBImageProvider sharedProvider];
        NSLog(@"made it to 1");
        self.socialLinks = [specifier propertyForKey:@"socialLinks"]
                               ? [specifier propertyForKey:@"socialLinks"]
                               : [NSArray new];

        NSMutableArray *tempArray = [NSMutableArray new];

        NSInteger count = self.socialLinks.count;

        for (NSInteger index = (count - 1); index >= 0; index--) {
            id object = self.socialLinks[index];

            if ([object isKindOfClass:[NSDictionary class]] &&
                [object objectForKey:@"link"] &&
                [object objectForKey:@"icon"]) {

                NSString *iconPath = [object objectForKey:@"icon"];
                NSString *urlPath = [object objectForKey:@"link"];

                UIImage *image = [self imageForPath:iconPath];
                NSURL *url = [NSURL URLWithString:urlPath];
                if ([self isValidURL:url] && image) {
                    [tempArray insertObject:object atIndex:0];
                }
            }
        }
        self.socialLinks = [NSArray arrayWithArray:tempArray];

        /// borderInsets
        height = [specifier propertyForKey:@"height"]
                     ? [[specifier propertyForKey:@"height"] floatValue]
                     : self.frame.size.height;

        inset = 5;
        imageInset = 10;
        ////Left Dev Image

        self.imageView.frame =
            CGRectMake(imageInset, imageInset, height - (imageInset * 2),
                       height - (imageInset * 2));
        [self addSubview:self.imageView];

        /////New content inset and sizes X

        leftInset = self.imageView.frame.size.width + (imageInset * 2);

        contentWidth = self.frame.size.width - (leftInset + inset);
        contentHeight = (height - (inset * 2)) / 2;

        ////Dev Name Header
        self.textLabel.frame =
            CGRectMake(leftInset, inset, contentWidth, contentHeight);
        [self.textLabel
            setFont:[UIFont systemFontOfSize:contentHeight * 2 / 3]];
        self.textLabel.minimumScaleFactor = 0.5;
        self.textLabel.adjustsFontSizeToFitWidth = YES;

        UICollectionViewFlowLayout *layout =
            [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(contentHeight, contentHeight);

        self.socialButtonsTable = [[UICollectionView alloc]
                   initWithFrame:CGRectMake(leftInset,
                                            self.textLabel.frame.size.height +
                                                inset,
                                            contentWidth, contentHeight)
            collectionViewLayout:layout];

        self.socialButtonsTable.backgroundColor = UIColor.clearColor;

        self.socialButtonsTable.dataSource = self;
        self.socialButtonsTable.delegate = self;

        self.socialButtonsTable.scrollEnabled = NO;

        [self.socialButtonsTable registerClass:[KBCSocialCell class]
                    forCellWithReuseIdentifier:@"CELL"];
        [self.contentView addSubview:self.socialButtonsTable];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
     ////Dev Name Header
    self.textLabel.frame =
        CGRectMake(leftInset, inset, contentWidth, contentHeight);

    self.imageView.frame =
        CGRectMake(imageInset, imageInset, height - (imageInset * 2),
                   height - (imageInset * 2));
    self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.imageView.clipsToBounds =
        [[self.specifier propertyForKey:@"roundIcon"] boolValue];
    self.imageView.layer.cornerRadius =
        [[self.specifier propertyForKey:@"roundIcon"] boolValue]
            ? self.imageView.frame.size.width / 2
            : 0;
    BOOL needsIconImage = (self.imageView.image == nil);
    if (needsIconImage) {
        [self addSubview:self.imageView];
        dispatch_async(
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
            ^(void) {
              NSString *iconPath = [self.specifier propertyForKey:@"icon"];
              UIImage *iconImage = [self imageForPath:iconPath];
              dispatch_sync(dispatch_get_main_queue(), ^(void) {
                if (iconImage) {
                    self.imageView.image = iconImage;
                }
              });
            });
    }
}

- (BOOL)isValidURL:(NSURL *)url {
    return (url && url.scheme && url.host);
}

- (UIImage *)imageForPath:(NSString *)path {

    if ([_sharedImageProvider hasImageForPath:path]) {
        return [_sharedImageProvider imageForPath:path];
    }

    UIImage *iconImage;
    if ([path hasPrefix:@"/"]) {
        iconImage = [[UIImage alloc] initWithContentsOfFile:path];
    } else {
        NSURL *url = [NSURL URLWithString:path];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        iconImage = [UIImage imageWithData:imageData];
    }

    if (iconImage) {
        [_sharedImageProvider cacheImage:iconImage forPath:path];
        return iconImage;
    }
    return nil;
}

/// UICollectionView Setup

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

    return self.socialLinks.count ? self.socialLinks.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    KBCSocialCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL"
                                                  forIndexPath:indexPath];
    NSString *iconPath =
        [[self.socialLinks objectAtIndex:indexPath.row] objectForKey:@"icon"];

    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
        ^(void) {
          UIImage *cellImage = [self imageForPath:iconPath];
          dispatch_sync(dispatch_get_main_queue(), ^(void) {
            cell.socialImageView.image = cellImage;
            cell.socialImageView.layer.cornerRadius =
                cell.socialImageView.bounds.size.height / 3;
            cell.socialImageView.contentMode = UIViewContentModeScaleAspectFit;
          });
        });
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {

    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewFlowLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionViewLayout.itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // If you need to use the touched cell, you can retrieve it like so
    KBCSocialCell *cell =
        (KBCSocialCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *link =
        [[self.socialLinks objectAtIndex:indexPath.row] objectForKey:@"link"];

    [cell openSocialLink:link];
}
@end