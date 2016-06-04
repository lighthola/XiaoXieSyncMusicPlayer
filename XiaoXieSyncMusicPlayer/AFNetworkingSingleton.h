//
//  AFNetworkingSingleton.h
//  ZhongLIBike
//
//  Created by user on 2016/3/8.
//  Copyright © 2016年 Bevis, Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^doneBlock)(NSError *error, id result);

@interface AFNetworkingSingleton : NSObject

@property (nonatomic,strong) AFURLSessionManager *aFURLSessionManager;

+(AFNetworkingSingleton*)sharedAFNetworkingSingleton;

-(void) getAllInformation:(doneBlock)completion;

@end
