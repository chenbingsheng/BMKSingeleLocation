//
//  BSCLLocationManager.m
//  cil
//
//  Created by cbs on 16/3/29.
//  Copyright © 2016年 CBS. All rights reserved.
//

#import "BSAMapLocationManager.h"


@interface BSAMapLocationManager ()


@property(nonatomic ,copy) AMapLocatingCompletionBlock locationBlock;
@property(nonatomic ,strong) AMapLocationManager *aMapLocService;

@end

@implementation BSAMapLocationManager

+(instancetype)shareLocationManager{
    
    static BSAMapLocationManager *cllocation = nil;
    
    @synchronized(self) {
        if (nil == cllocation) {
            cllocation = [[BSAMapLocationManager alloc] init];
        }
    }
    return cllocation;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
}

+ (void)aMapUserLocation:(AMapLocatingCompletionBlock)locationBlock{
    
    BSAMapLocationManager *bsLocationManager = [BSAMapLocationManager shareLocationManager];
    bsLocationManager.locationBlock = locationBlock;
    
    [bsLocationManager.aMapLocService requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (bsLocationManager.locationBlock) {
            bsLocationManager.locationBlock(location, regeocode, error);
        }
    }];
}

- (AMapLocationManager *)aMapLocService{
    if (_aMapLocService == nil) {
        _aMapLocService = [[AMapLocationManager alloc] init];
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        _aMapLocService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //   定位超时时间，最低2s，此处设置为10s
        _aMapLocService.locationTimeout = 10;
        //   逆地理请求超时时间，最低2s，此处设置为3s
        _aMapLocService.reGeocodeTimeout = 3;
    }
    return _aMapLocService;
}

@end
