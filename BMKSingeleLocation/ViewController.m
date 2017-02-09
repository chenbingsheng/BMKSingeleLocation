//
//  ViewController.m
//  BMKSingeleLocation
//
//  Created by cbs on 16/8/30.
//  Copyright © 2016年 CBS. All rights reserved.
//

#import "ViewController.h"
#import "BSAMapLocationManager.h"
#import "BSBMKLocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    
    button.frame = CGRectMake(0, 0, 44, 44);
    button.center = self.view.center;
    [button setTitle:@"开始定位" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.numberOfLines = 0;
    
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick:(UIButton *)sender {
    
    [self getUserLocation];
}
- (void)getUserLocation{
    
//    [BSAMapLocationManager aMapUserLocation:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        NSLog(@"AMap %f  %f",location.coordinate.latitude,location.coordinate.longitude);
//        NSLog(@"%@",regeocode.formattedAddress);
//    }];
    
    Wrapper cancle = [BSBMKLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, BMKReverseGeoCodeResult *regeocode, NSError *error) {
        NSLog(@"BMK %f  %f",location.coordinate.latitude,location.coordinate.longitude);
        NSLog(@"%@",regeocode.address);
    }];
    //cancle(YES);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
