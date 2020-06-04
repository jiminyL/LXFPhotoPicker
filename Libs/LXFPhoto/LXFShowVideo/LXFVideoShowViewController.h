//
//  LXFVideoShowViewController.h
//  iBuilding
//
//  Created by 梁啸峰 on 2020/4/22.
//

#import <UIKit/UIKit.h>
#import "LXFMediaImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFVideoShowViewController : UIViewController

- (instancetype)initWithMediaImage:(LXFMediaImage *)mediaImage;
@property (nonatomic, strong) NSURL *localVideoUrl;

@end

NS_ASSUME_NONNULL_END
