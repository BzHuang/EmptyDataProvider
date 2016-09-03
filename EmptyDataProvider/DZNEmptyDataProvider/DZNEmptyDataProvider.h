//
//  DZNEmptyDataProvider.h
//  Applications
//
//  Created by HzB on 16/9/3.
//  Copyright © 2016年 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DZNEmptyDataType){
    /** 没登录*/
    DZNEmptyDataType_NoLogin = 21,
    /** 加载失败*/
    DZNEmptyDataType_LoadFail,
    /** 加载中*/
    DZNEmptyDataType_Loading,
    /** 没数据*/
    DZNEmptyDataType_NoData
};


@class DZNEmptyDataProvider;
//点击按钮回调
typedef void(^DZNEmptyDidTapButtonBlock)(UIScrollView *scrollView,UIButton *button,DZNEmptyDataProvider *provider);
@class DZNEmptyDataProvider;
//点击view回调
typedef void(^DZNEmptyDidTapViewBlock)(UIScrollView *scrollView,UIView *view,DZNEmptyDataProvider *provider);

/**
 *  一些空UI,如未登陆，重新加载等，基于UIScrollView+EmptyDataSet
 */
@interface DZNEmptyDataProvider : NSObject

/** */
@property (nonatomic, getter=isLoading) BOOL loading;

@property (nonatomic, weak) UIScrollView *showScrollView;

#pragma mark - DZNEmptyDataSetSource
/** 标题*/
@property (nonatomic, copy) NSAttributedString *title;
/** 内容*/
@property (nonatomic, copy) NSAttributedString *descriptionStr;
/** 图片*/
@property (nonatomic, strong) UIImage *image;
/** 图片颜色*/
@property (nonatomic, strong) UIColor *imageTintColor;
/** 图片动画*/
@property (nonatomic, strong) CAAnimation *imageAnimation;
/** 按钮标题*/
@property (nonatomic, copy) NSAttributedString *(^revertButtonTitleBlock)(UIControlState state);
/** 按钮图片*/
@property (nonatomic, copy) UIImage *(^revertButtonImageBlock)(UIControlState state);
/** 按钮背景图片*/
@property (nonatomic, copy) UIImage *(^revertButtonBackgroundImageBlock)(UIControlState state);
/** 整个背景颜色*/
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIView *customView;
/** 空间的上下间隔*/
@property (nonatomic, assign) CGFloat spaceHeight;
/** y轴的中心偏移*/
@property (nonatomic, assign) CGFloat verticalOffset;

#pragma mark - DZNEmptyDataSetDelegate
//默认yes bounds
@property (nonatomic, assign,getter=isShouldAllowScroll) BOOL shouldAllowScroll;
/** 按钮响应*/
- (void)didTapButtonBlock:(DZNEmptyDidTapButtonBlock)tapButtonBlock;
/** 点击view响应*/
- (void)didDidTapViewBlock:(DZNEmptyDidTapViewBlock)tapViewBlcok;

@end

#pragma mark - DZNEmptyDataProvider + DZNEmptyDefault
@interface DZNEmptyDataProvider(DZNEmptyDefault)

+ (NSMutableAttributedString *)defaultAttTitle:(NSString *)title;
+ (NSMutableAttributedString *)defaultAttDescription:(NSString *)description;
+ (NSMutableAttributedString *)defaultAttButtonTitle:(NSString *)buttonTitle;

@end
#pragma mark - DZNEmptyDataProvider + DZNEmptyType

@interface DZNEmptyDataProvider (DZNEmptyDataType)

@property (nonatomic, assign) DZNEmptyDataType emptyType;

+ (instancetype)providerWithEmptyType:(DZNEmptyDataType)emptyType;

@end

#pragma mark - UIScrollView+DZNEmptyDataProvider
@interface UIScrollView (DZNEmptyDataProvider)

@property (nonatomic, strong) DZNEmptyDataProvider *emptyDataProvider;

@end

#pragma mark - UIViewController+DZNEmptyDataProvider
@interface UIViewController (DZNEmptyDataProvider)

@property (nonatomic, strong,readonly) DZNEmptyDataProvider *emptyDataProvider;

- (void)showEmptyViewWithProvider:(DZNEmptyDataProvider *)emptyDataProvider;

- (void)dismissEmptyView;

@end

