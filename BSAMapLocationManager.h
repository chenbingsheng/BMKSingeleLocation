//
//  BSCLLocationManager.h
//  cil
//
//  Created by cbs on 16/3/29.
//  Copyright © 2016年 CBS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface BSAMapLocationManager : NSObject

@property(nonatomic ,strong) CLLocation *currentLocation;

+ (void)aMapUserLocation:(AMapLocatingCompletionBlock)locationBlock;

@end


