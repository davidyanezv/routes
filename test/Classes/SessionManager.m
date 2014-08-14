//
//  SessionManager.m
//  test
//
//  Created by David Yanez on 8/13/14.
//  Copyright (c) 2014 arctouch. All rights reserved.
//

#import "SessionManager.h"
#import "RequestSerializer.h"

@implementation SessionManager

+ (instancetype)manager
{
    static dispatch_once_t pred = 0;
    static id __strong _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (!url) {
        url = [NSURL URLWithString:@"https://dashboard.appglu.com"];
    }
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.requestSerializer = [RequestSerializer serializer];
        
    }
    
    return self;
}


- (void)search:(NSString *)keyWords completionHandler:(void (^)(id responseObject, NSError *error))completionHandler
{
    NSDictionary *params = @{
                                 @"params": @{
                                     @"stopName": [NSString stringWithFormat:@"%%%@%%", keyWords]
                                 }
                             };
    
    [self POST:@"v1/queries/findRoutesByStopName/run" parameters:params options:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
       
        if (responseObject && responseObject[@"rows"] && [responseObject[@"rows"] isKindOfClass:[NSArray class]]) {
            completionHandler(responseObject[@"rows"], nil);
        }else{
            completionHandler(nil, error);
        }
        
    }];
}

- (void)stopDetails:(NSString *)stopID completionHandler:(void (^)(id responseObject, NSError *error))completionHandler
{
    NSDictionary *params = @{
                             @"params": @{ 
                                     @"routeId": stopID
                                     }
                             };
    
    [self POST:@"v1/queries/findStopsByRouteId/run" parameters:params options:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (responseObject && responseObject[@"rows"] && [responseObject[@"rows"] isKindOfClass:[NSArray class]]) {
            completionHandler(responseObject[@"rows"], nil);
        }else{
            completionHandler(nil, error);
        }
    }];
}


- (void)departureDetails:(NSString *)stopID completionHandler:(void (^)(id responseObject, NSError *error))completionHandler
{
    NSDictionary *params = @{
                             @"params": @{
                                     @"routeId": stopID
                                     }
                             };
    
    [self POST:@"v1/queries/findDeparturesByRouteId/run" parameters:params options:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (responseObject && responseObject[@"rows"] && [responseObject[@"rows"] isKindOfClass:[NSArray class]]) {
            completionHandler(responseObject[@"rows"], nil);
        }else{
            completionHandler(nil, error);
        }
    }];
}

#pragma mark - Network Methods

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters options:(NSDictionary *)options  completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSString *url = [[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:url parameters:parameters];
    return [self request:request options:nil completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters options:(NSDictionary *)options  completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSString *url = [[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:url parameters:parameters];
    return [self request:request options:nil completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)request:(NSURLRequest *)request options:(NSDictionary *)options completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        completionHandler(response, responseObject, error);
    }];
    [task resume];
    return task;
}

@end
