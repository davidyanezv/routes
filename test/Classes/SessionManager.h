//
//  SessionManager.h
//  test
//
//  Created by David Yanez on 8/13/14.
//  Copyright (c) 2014 arctouch. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface SessionManager : AFHTTPSessionManager

+ (instancetype)manager;

- (void)search:(NSString *)keyWords completionHandler:(void (^)(id responseObject, NSError *error))completionHandler;
- (void)stopDetails:(NSString *)stopID completionHandler:(void (^)(id responseObject, NSError *error))completionHandler;
- (void)departureDetails:(NSString *)stopID completionHandler:(void (^)(id responseObject, NSError *error))completionHandler;

@end
