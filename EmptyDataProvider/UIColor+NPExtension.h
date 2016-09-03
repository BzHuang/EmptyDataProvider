//
//  UIColor+NPExtension.h
//  ShareBey
//
//  Created by HzB on 16/7/22.
//  Copyright © 2016年 HzB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NPExtension)

/**
*  根据rgb生成颜色
*
*  @param R <#R description#>
*  @param G <#G description#>
*  @param B <#B description#>
*
*  @return color
*/
+ (UIColor *)colorWithRGB:(CGFloat)R
                           G:(CGFloat)G
                           B:(CGFloat) B;

+ (UIColor *)colorWithRGB:(CGFloat)R
                        G:(CGFloat)G
                        B:(CGFloat) B
                        alpha:(CGFloat)alpha;

/**
 *  将16进制颜色编码 字符串转为颜色
 *
 *  @param color 颜色字符串
 *  @param alpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color
                             alpha:(CGFloat)alpha;

@end
