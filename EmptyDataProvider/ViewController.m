//
//  ViewController.m
//  EmptyDataProvider
//
//  Created by HzB on 16/9/3.
//  Copyright © 2016年 HzB. All rights reserved.
//

#import "ViewController.h"
#import "DZNEmptyDataProvider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    __weak typeof(self) weakSelf = self;
    DZNEmptyDataProvider *provider = [DZNEmptyDataProvider providerWithEmptyType:DZNEmptyDataType_NoLogin];
    [provider didTapButtonBlock:^(UIScrollView *scrollView, UIButton *button, DZNEmptyDataProvider *provider) {
        if (provider.emptyType + 1 <= DZNEmptyDataType_NoData) {
            provider.emptyType += 1;
        }
        else{
            if (!provider.isLoading) {
                provider.loading = YES;
            }
            else{
                [weakSelf dismissEmptyView];
            }
        }
    }];
    [self showEmptyViewWithProvider:provider];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
