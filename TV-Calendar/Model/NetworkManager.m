//
//  NetworkManager.m
//  TV-Calendar
//
//  Created by GaoMing on 16/4/7.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager()

@property (readwrite, strong) NSDictionary *configuration;
@property (strong, nonatomic, readwrite) AFHTTPSessionManager *manager;

@end

@implementation NetworkManager

- (instancetype)initWithConfiguration:(NSDictionary *)configuration {
    self = [super init];
    if (self) {
        if (!configuration[@"Website"] ||
            !configuration[@"Paths"] ||
            !configuration[@"Success Code"] ||
            !configuration[@"Error Code"]) {
            return nil;
        }
        self.configuration = configuration;
    }
    return self;
}

+ (instancetype)defaultManager {
    static dispatch_once_t ID = 0;
    static NetworkManager *manager = nil;
    dispatch_once(&ID, ^{
        manager = [[self alloc] initWithConfiguration:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]]];
    });
    return manager;
}

- (NSString *)webSite {
    return self.configuration[@"Website"];
}

- (NSDictionary *)paths {
    return self.configuration[@"Paths"];
}

- (NSNumber *)successCode {
    return self.configuration[@"Success Code"];
}

- (NSNumber *)errorCode {
    return self.configuration[@"Error Code"];
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

- (NSURLSessionDataTask *)GET:(NSString *)key
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure {
    return [self  request:key
            GETparameters:parameters
           POSTparameters:nil
constructingBodyWithBlock:nil
                  success:success
                  failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)key
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure {
    return [self  request:key
            GETparameters:nil
           POSTparameters:parameters
constructingBodyWithBlock:nil
                  success:success
                  failure:failure];
}

- (NSURLSessionDataTask *)request:(NSString *)key
                    GETparameters:(NSDictionary *)GETparameters
                   POSTparameters:(NSDictionary *)POSTparameters
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *))failure {
    NSError *error = nil;
    NSMutableDictionary *gp = [GETparameters mutableCopy];
    NSString *URLString = [self.manager.requestSerializer requestWithMethod:@"GET"
                                                                  URLString:[NSString stringWithFormat:@"%@%@", self.webSite, self.paths[key]]
                                                                 parameters:gp
                                                                      error:&error].URL.absoluteString;
    if (error != nil || URLString == nil) {
        if (failure) {
            if (error == nil) {
                error = [[NSError alloc] init];
            }
            failure(error);
        }
        return nil;
    }
    NSLog(@"[NetworkManager]%@", URLString);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NetworkManager __weak *weakSelf = self;
//    if (POSTparameters.count > 0) {
        return [self.manager POST:URLString
                       parameters:POSTparameters
        constructingBodyWithBlock:block
                         progress:nil
                          success:^(NSURLSessionDataTask *task, NSData *data) {
                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                              [weakSelf handleSuccess:task
                                                 data:data
                                              success:success
                                              failure:failure];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                              NSLog(@"[NetworkManager]%@\n%@\n", task.response.URL, error);
                              if (failure) {
                                  failure(error);
                              }
                          }];
//    } else {
//        return [self.manager GET:URLString
//                      parameters:nil
//                        progress:nil
//                         success:^(NSURLSessionDataTask *task, NSData *data) {
//                             [weakSelf handleSuccess:task data:data success:success failure:failure];
//                         }
//                         failure:^(NSURLSessionDataTask *task, NSError *error) {
//                             if (failure) {
//                                 failure(error);
//                             }
//                         }];
//    }
}

- (void)handleSuccess:(NSURLSessionDataTask *)task
                 data:(NSData *)data
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:&error];
    if (error != nil || object == nil || !([object isKindOfClass:[NSDictionary class]])) {
        NSMutableDictionary *userInfo = [@{NSLocalizedDescriptionKey: @"Failed to parse JSON.",
                                           NSLocalizedFailureReasonErrorKey: @"The data returned from the server does not meet the JSON syntax.",
                                           NSUnderlyingErrorKey: task.error} mutableCopy];
        if (task.error != nil) {
            userInfo[NSUnderlyingErrorKey] = task.error;
        }
        error = [[NSError alloc] initWithDomain:self.webSite
                                           code:[self.errorCode integerValue]
                                       userInfo:userInfo];
        NSLog(@"[NetworkManager]%@\n%@\n%@\n", task.response.URL, error, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if (failure) {
            failure(error);
        }
        return;
    }
    
    NSDictionary *objectData = object;
    if (objectData[@"errno"] == self.successCode) {
        id data = objectData[@"rsm"];
        if (success) {
            success(data);
        }
    } else {
        NSMutableDictionary *userInfo = [@{NSLocalizedDescriptionKey: objectData[@"err"],
                                           NSURLErrorKey: task.response.URL} mutableCopy];
        NSError *error = [[NSError alloc] initWithDomain:self.webSite
                                                    code:[objectData[@"errno"] integerValue]
                                                userInfo:userInfo];
        if (failure) {
            failure(error);
        }
    }
}

@end
