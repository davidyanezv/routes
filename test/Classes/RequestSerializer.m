//
//  RequestSerializer.m
//  test
//
//  Created by David Yanez on 8/13/14.
//  Copyright (c) 2014 arctouch. All rights reserved.
//

#import "RequestSerializer.h"

@implementation RequestSerializer


- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(NSDictionary *)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *mutableRequest = [[super requestBySerializingRequest:request withParameters:parameters error:error] mutableCopy];
    
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setValue:@"Basic V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==" forHTTPHeaderField:@"Authorization"];
    [mutableRequest setValue:@"staging" forHTTPHeaderField:@"X-AppGlu-Environment"];
    
    return mutableRequest;
}

@end
