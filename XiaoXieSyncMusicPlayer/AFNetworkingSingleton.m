//
//  AFNetworkingSingleton.m
//  ZhongLIBike
//
//  Created by user on 2016/3/8.
//  Copyright © 2016年 Bevis, Chen. All rights reserved.
//

#import "AFNetworkingSingleton.h"

#define OPEN_DATA_BIKE_JSON_BASE_URL @"http://220.136.167.220:8080/api/post"

// HTTP Method
#define GET @"GET"
#define POST @"POST"

// HTTP Key Value
#define FORMAT_KEY @"name"
#define FORMAT_VALUE @"json"

// Other parameter
#define TIMEOUTINTERVAL 180.0


static AFNetworkingSingleton *_sharedAFNetworkingSingleton;

@implementation AFNetworkingSingleton

+(instancetype)sharedAFNetworkingSingleton {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAFNetworkingSingleton = [AFNetworkingSingleton new];
    });
    
    return _sharedAFNetworkingSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self preparedAFURLSessionManager];
    }
    return self;
}

-(void)preparedAFURLSessionManager {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _aFURLSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
}

#pragma mark - Public Methods
-(void) getAllInformation:(doneBlock)completion {
    
    NSDictionary *parameters = @{FORMAT_KEY: FORMAT_VALUE};
    [self doHttpMethod:POST uRL:OPEN_DATA_BIKE_JSON_BASE_URL parameters:parameters completion:completion];
}

#pragma mark - Private Methods
-(void) doHttpMethod:(NSString*)method uRL:(NSString*)url parameters:(NSDictionary*)parameters completion:(doneBlock)completion {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:url parameters:parameters error:nil];
    // 設定client端等待時間
    request.timeoutInterval = TIMEOUTINTERVAL;
    
    NSURLSessionDataTask *dataTask = [_aFURLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            completion(error,nil);
        } else {
            completion(nil,responseObject);
        }
    }];
    [dataTask resume];

}

@end
