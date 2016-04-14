//
//  NetworkManager.h
//  TV-Calendar
//
//  Created by GaoMing on 16/4/7.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkManager : NSObject

//@property (readonly) NSDictionary *configuration;
@property (readonly, copy) NSString *webSite;
@property (readonly, copy) NSDictionary *paths;
@property (readonly) NSNumber* successCode;
@property (readonly) NSNumber* errorCode;
@property (readonly, strong, nonatomic) AFHTTPSessionManager *manager;

+ (instancetype)defaultManager;
- (NSURLSessionDataTask *)GET:(NSString *)key
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
- (NSURLSessionDataTask *)POST:(NSString *)key
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

@end
