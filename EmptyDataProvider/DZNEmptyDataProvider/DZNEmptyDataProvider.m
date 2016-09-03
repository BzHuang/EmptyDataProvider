//
//  DZNEmptyDataProvider.m
//  Applications
//
//  Created by HzB on 16/9/3.
//  Copyright © 2016年 DZN Labs. All rights reserved.
//

#import "DZNEmptyDataProvider.h"
#import <objc/runtime.h>
#import "UIScrollView+EmptyDataSet.h"
#import "UIColor+NPExtension.h"

@interface DZNEmptyDataProvider()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, copy) DZNEmptyDidTapButtonBlock tapButtonBlock;
@property (nonatomic, copy) DZNEmptyDidTapViewBlock  tapViewBlock;

@end

@implementation DZNEmptyDataProvider


- (instancetype)init{
    if (self = [super init]) {
        _shouldAllowScroll = YES;
    }
    return self;
}

- (void)setLoading:(BOOL)loading
{
    if (!_showScrollView) {
        return;
    }
    if (self.isLoading == loading) {
        return;
    }
    _loading = loading;
    [_showScrollView reloadEmptyDataSet];
}

- (void)didTapButtonBlock:(DZNEmptyDidTapButtonBlock)tapButtonBlock{
    self.tapButtonBlock = tapButtonBlock;
}

- (void)didDidTapViewBlock:(DZNEmptyDidTapViewBlock)tapViewBlcok{
    self.tapViewBlock = tapViewBlcok;
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return _title;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollVie{
    return _descriptionStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    }
    return _image;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isLoading) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.25;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        return animation;
    }
    return _imageAnimation;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    if (_revertButtonTitleBlock) {
      return _revertButtonTitleBlock(state);
    }
    return nil;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    if (_revertButtonImageBlock) {
        return _revertButtonImageBlock(state);
    }
    return nil;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    if (_revertButtonBackgroundImageBlock) {
        return _revertButtonBackgroundImageBlock(state);
    }
    return nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return _backgroundColor;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    return _customView;
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return _verticalOffset;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return _spaceHeight;
}

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return _tapViewBlock || _tapButtonBlock;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return YES;
    }
    return _imageAnimation;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (_tapViewBlock) {
        _tapViewBlock(scrollView,view,self);
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (_tapButtonBlock) {
        _tapButtonBlock(scrollView,button,self);
    }
}

@end

#pragma mark - DZNEmptyDataProvider + DZNEmptyDefault
@implementation DZNEmptyDataProvider (DZNEmptyDefault)

+ (NSMutableAttributedString *)defaultAttTitle:(NSString *)title{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont boldSystemFontOfSize:17.0];
    UIColor *color = [UIColor grayColor];
    
    NSDictionary *attributes =  @{NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : color,
                                  NSParagraphStyleAttributeName : paragraph};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
    return attributedString;
}

+ (NSMutableAttributedString *)defaultAttDescription:(NSString *)description{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont boldSystemFontOfSize:16.0];
    UIColor *color = [UIColor lightGrayColor];
    
    NSDictionary *attributes =  @{NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : color,
                                  NSParagraphStyleAttributeName : paragraph};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:description attributes:attributes];
    return attributedString;
}

+ (NSMutableAttributedString *)defaultAttButtonTitle:(NSString *)buttonTitle{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont boldSystemFontOfSize:16.0];
    UIColor *color = [UIColor colorWithRed:5.0/255.0 green:173.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    NSDictionary *attributes =  @{NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : color,
                                  NSParagraphStyleAttributeName : paragraph};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:buttonTitle attributes:attributes];
    return attributedString;
    
}

@end

#pragma mark - DZNEmptyType + DZNEmptyType

static char const * const kEmptyDataType =       "EmptyDataType";

@implementation DZNEmptyDataProvider (DZNEmptyType)

+ (instancetype)providerWithEmptyType:(DZNEmptyDataType)emptyType{
    DZNEmptyDataProvider *provider = [[DZNEmptyDataProvider alloc]init];
    provider.emptyType = emptyType;
    return provider;
}


- (DZNEmptyDataType)emptyType{
   id type = objc_getAssociatedObject(self, kEmptyDataType);
    return [type integerValue];
}

- (void)setEmptyType:(DZNEmptyDataType)emptyType{
    if (emptyType == self.emptyType) {
        return;
    }
    objc_setAssociatedObject(self, kEmptyDataType, @(emptyType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self type_refreshData];
    [self.showScrollView reloadEmptyDataSet];
}

- (void)type_refreshData{
    self.title = [self type_title];
    self.descriptionStr = [self type_descriptionStr];
    self.image = [self type_image];
    self.imageTintColor = [self type_imageTintColor];
    self.imageAnimation = [self type_imageAnimation];
    self.backgroundColor = [self type_backgroundColor];
    self.customView = [self type_customView];
    self.verticalOffset = [self type_verticalOffset];
    self.spaceHeight = [self type_verticalSpace];
    __weak typeof(self) weakSelf = self;
    [self setRevertButtonTitleBlock:^NSAttributedString *(UIControlState state) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        return [strongSelf type_buttonTitleForState:state];
    }];
    
    [self setRevertButtonImageBlock:^UIImage *(UIControlState state) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        return [strongSelf type_buttonImageForState:state];
    }];
    
    [self setRevertButtonBackgroundImageBlock:^UIImage *(UIControlState state) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        return [strongSelf type_buttonBackgroundImageForState:state];
    }];
}

- (NSAttributedString *)type_title;
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    DZNEmptyDataType type = self.emptyType;
    switch (type) {
        case DZNEmptyDataType_NoLogin: {
            text = @"您还没有登录!";
            font = [UIFont boldSystemFontOfSize:17.0];
            textColor = [UIColor lightGrayColor];
            break;
        }
        case DZNEmptyDataType_LoadFail: {
            text = @"加载失败!";
            font = [UIFont boldSystemFontOfSize:17.0];
            textColor = [UIColor lightGrayColor];
            break;
        }
        case DZNEmptyDataType_Loading:{
            break;
        }
        case DZNEmptyDataType_NoData: {
            text = @"没有数据!";
            font = [UIFont boldSystemFontOfSize:17.0];
            textColor = [UIColor lightGrayColor];
            break;
        }
    }
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

- (NSAttributedString *)type_descriptionStr{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    DZNEmptyDataType type = self.emptyType;
    switch (type) {
        case DZNEmptyDataType_NoLogin: {
            break;
        }
        case DZNEmptyDataType_LoadFail: {
            break;
        }
        case DZNEmptyDataType_Loading:{
            break;
        }
        case DZNEmptyDataType_NoData: {
            text = @"空空如也!可以刷新试试！";
            font = [UIFont boldSystemFontOfSize:17.0];
            textColor = [UIColor lightGrayColor];
            break;
        }
    }
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

- (UIImage *)type_image{

    UIImage *image = nil;
    DZNEmptyDataType type = self.emptyType;
    switch (type) {
        case DZNEmptyDataType_NoLogin: {
            image = [UIImage imageNamed:@"error_logo_user"];
            break;
        }
        case DZNEmptyDataType_LoadFail: {
            image = [UIImage imageNamed:@"error_logo_wifi"];
            break;
        }
        case DZNEmptyDataType_Loading:{
            image =[UIImage imageNamed:@"loading_imgBlue_78x78"];
            break;
        }
        case DZNEmptyDataType_NoData: {
            break;
        }
    }
    return image;
}


- (CAAnimation *)type_imageAnimation
{
    CAAnimation *backAnimation = nil;
    switch (self.emptyType) {
        case DZNEmptyDataType_NoLogin:
        case DZNEmptyDataType_LoadFail: {
            CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
            //            animation.delegate = self;
            animation.duration = 0.6;
            animation.values = @[ @(0), @(10), @(-8), @(8), @(-5), @(5), @(0) ];
            animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            backAnimation = animation;
            break;
        }
        case DZNEmptyDataType_Loading: {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
            animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
            animation.duration = 0.25;
            animation.cumulative = YES;
            animation.repeatCount = MAXFLOAT;
            backAnimation = animation;
            break;
        }
        case DZNEmptyDataType_NoData: {
            break;
        }
    }
    return backAnimation;
}

- (UIColor *)type_imageTintColor{
    return nil;
}

- (NSAttributedString *)type_buttonTitleForState:(UIControlState)state{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    DZNEmptyDataType type = self.emptyType;
    switch (type) {
        case DZNEmptyDataType_NoLogin: {
            text = @"点击登录";
            font = [UIFont boldSystemFontOfSize:16.0];
            NSString *colorHex = @(state == UIControlStateNormal) ? @"05adff"  : @"6bceff";
            textColor = [UIColor colorWithHexString:colorHex alpha:1.0];
            break;
        }
        case DZNEmptyDataType_LoadFail: {
            text = @"重新加载";
            font = [UIFont boldSystemFontOfSize:16.0];
            NSString *colorHex = @(state == UIControlStateNormal) ? @"05adff"  : @"6bceff";
            textColor = [UIColor colorWithHexString:colorHex alpha:1.0];            break;
        }
        case DZNEmptyDataType_Loading:{
            text = @"加载中...";
            font = [UIFont boldSystemFontOfSize:16.0];
            NSString *colorHex = @(state == UIControlStateNormal) ? @"05adff"  : @"6bceff";
            textColor = [UIColor colorWithHexString:colorHex alpha:1.0];
            break;
        }
        case DZNEmptyDataType_NoData: {
            text = @"点击刷新";
            font = [UIFont boldSystemFontOfSize:16.0];
            NSString *colorHex = @(state == UIControlStateNormal) ? @"05adff"  : @"6bceff";
            textColor = [UIColor colorWithHexString:colorHex alpha:1.0];
            break;
        }
    }
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

- (UIImage *)type_buttonImageForState:(UIControlState)state{
    return nil;
}

- (UIImage *)type_buttonBackgroundImageForState:(UIControlState)state{
    return nil;
}

- (UIColor *)type_backgroundColor{
    return nil;
}

- (UIView *)type_customView{
    return nil;
}

- (CGFloat)type_verticalOffset{
    return -36.0;
}

- (CGFloat)type_verticalSpace{
    return 0.0;
}

@end

#pragma mark - UIScrollView+DZNEmptyDataProvider
static char const * const kDZNEmptyDataProviderKey =     "DZNEmptyDataProviderKey";

@implementation UIScrollView (DZNEmptyDataProvider)

- (void)setEmptyDataProvider:(DZNEmptyDataProvider *)emptyDataProvider{
    objc_setAssociatedObject(self,kDZNEmptyDataProviderKey, emptyDataProvider, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    emptyDataProvider.showScrollView = self;
    self.emptyDataSetSource = emptyDataProvider;
    self.emptyDataSetDelegate = emptyDataProvider;
}

- (DZNEmptyDataProvider *)emptyDataProvider{
    id emptyDataProvider = objc_getAssociatedObject(self, kDZNEmptyDataProviderKey);
    if ([emptyDataProvider isKindOfClass:[DZNEmptyDataProvider class]]) {
        return emptyDataProvider;
    }
    return nil;
}

@end


#pragma mark - UIViewController+DZNEmptyDataProvider
static char const * const kDZNScrollViewKey =     "DZNScrollViewKey";

@interface UIViewController()

@property (nonatomic, weak) UIScrollView *dznScrollView;
@property (nonatomic, assign,getter=isShowEmpty,readonly) BOOL showEmpty;

@end

@implementation UIViewController (DZNEmptyDataProvider)

- (DZNEmptyDataProvider *)emptyDataProvider{
    return self.dznScrollView.emptyDataProvider;
}

- (void)setDznScrollView:(UIScrollView *)dznScrollView{
//       objc_setAssociatedObject(self,kDZNScrollViewKey, dznScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
     objc_setAssociatedObject(self,kDZNScrollViewKey, dznScrollView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIScrollView *)dznScrollView{
    return objc_getAssociatedObject(self, kDZNScrollViewKey);
}

- (BOOL)isShowEmpty{
    return self.dznScrollView;
}

- (void)showEmptyViewWithProvider:(DZNEmptyDataProvider *)emptyDataProvider{
    UIScrollView *scrollView = self.dznScrollView;
    if (!scrollView) {
        scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
        [self.view addSubview:scrollView];
        self.dznScrollView = scrollView;
    }
    [self.view bringSubviewToFront:scrollView];
    scrollView.emptyDataProvider = emptyDataProvider;
    [scrollView reloadEmptyDataSet];
}

- (void)dismissEmptyView{
    if (!self.showEmpty) {
        return;
    }
    [self.dznScrollView removeFromSuperview];
    self.dznScrollView = nil;
}

@end




