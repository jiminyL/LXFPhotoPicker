//
//  LXFBrowserViewController.h
//  KDSLife
//
//  Created by PChome on 2017/3/22.
//
//

#import <UIKit/UIKit.h>

@interface LXFBrowserViewController : UIViewController

///photosArr为UIImage或者NSString, thumbArr为NSString,当photosArr时NSString时使用
- (instancetype)initWithPhotosArr:(NSArray *)photosArr andThumbArr:(NSArray *)thumbArr andIndex:(NSInteger)index;

@end
