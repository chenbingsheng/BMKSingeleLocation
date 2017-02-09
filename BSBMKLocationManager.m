//
//  BSBMKLocationManager.m
//  CoffeeMe
//
//  Created by cbs on 16/8/30.
//  Copyright © 2016年 CBS. All rights reserved.
//

#import "BSBMKLocationManager.h"

@interface BSBMKLocationManager ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (class, readonly, strong) NSMutableArray *objArray;

@property(nonatomic ,strong) BMKLocationService *bmkLocService;
@property(nonatomic ,strong) BMKGeoCodeSearch   *geoCodeSearch;

@end

@implementation BSBMKLocationManager

@synthesize currentLocation = _currentLocation;

static NSMutableArray *_objArray = nil;
+ (NSArray *)objArray{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _objArray = [[NSMutableArray alloc] init];
    });
    return _objArray;
}

+ (Wrapper)requestLocationWithReGeocode:(BOOL)isReGeocode completionBlock:(BMKLocatingCompletionBlock)completionBlock{
    
    BSBMKLocationManager *locationService = [[BSBMKLocationManager alloc] init];
    
    locationService.locationBlock = completionBlock;
    
    locationService.isReGeocode = isReGeocode;
    
    [locationService startUserLocationService];
    
    [[self objArray] addObject:locationService];
    
    Wrapper cancle = ^(BOOL cancle) {
        if (cancle) {
            [locationService reDealloc];
        }
    };
    return [cancle copy];
}

- (void)requestLocationWithReGeocode:(BOOL)isReGeocode completionBlock:(BMKLocatingCompletionBlock)completionBlock{
    
    self.locationBlock = completionBlock;
    self.isReGeocode = isReGeocode;
    
    [self startUserLocationService];
}

- (void)startUserLocationService{
    [self.bmkLocService startUserLocationService];
}

- (void)stopUserLocationService{
    [self.bmkLocService stopUserLocationService];
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
    
    _bmkLocService = [[BMKLocationService alloc] init];
    //设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电量
    _bmkLocService.distanceFilter = 30;
    //设定定位精度
    _bmkLocService.desiredAccuracy = kCLLocationAccuracyBest;
    //设置代理
    _bmkLocService.delegate = self;
    
    //获取位置信息
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
}

- (void)setDistanceFilter:(CLLocationDistance)distanceFilter{
    _distanceFilter = distanceFilter;
    self.bmkLocService.distanceFilter = distanceFilter;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy{
    _desiredAccuracy = desiredAccuracy;
    self.bmkLocService.desiredAccuracy = desiredAccuracy;
}

//位置更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    _currentLocation = userLocation.location;
    
    [self.bmkLocService stopUserLocationService];

    if (_isReGeocode) {
        
        BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
        reverseGeoCodeOption.reverseGeoPoint = self.currentLocation.coordinate;
        [self.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    }else{
        
        if (self.locationBlock) {
            self.locationBlock(self.currentLocation, nil, nil);
        }
        [self reDealloc];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (self.locationBlock) {
        if (error) {
            self.locationBlock(self.currentLocation, nil, nil);
        }else{
            self.locationBlock(self.currentLocation, result, nil);
        }
    }
    [self reDealloc];
}

//方向更新
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
}
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    
    //停止定位
    [self.bmkLocService stopUserLocationService];
    
    if (self.locationBlock) {
        self.locationBlock(nil, nil, error);
    }
    
    [self reDealloc];
    
}

- (void)reDealloc{
    self.locationBlock = nil;
    
    [self.bmkLocService stopUserLocationService];
    self.bmkLocService.delegate = nil;
    self.bmkLocService = nil;
    
    self.geoCodeSearch.delegate = nil;
    self.geoCodeSearch = nil;
    
    [[[self class] objArray] removeObject:self];
}

@end
