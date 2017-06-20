//
//  KyleURLProtocol.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/20.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "KyleURLProtocol.h"
@interface KyleURLProtocol ()

@end

@implementation KyleURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSLog(@"URL-->%@",request.URL.absoluteString);
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
                       toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading{

}

- (void)stopLoading{

}

@end
