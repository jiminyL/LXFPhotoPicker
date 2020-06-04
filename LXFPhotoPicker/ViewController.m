//
//  ViewController.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/6/4.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "ViewController.h"
#import "LXFPhoto.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [[LXFPhoto alloc] showInViewController:self withPhotos:nil selectedPhotos:^(NSArray<PHAsset *> * _Nonnull photos) {
        
    }];
    
}


@end
