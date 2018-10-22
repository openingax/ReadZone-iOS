//
//  RZWebServerManager.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/22.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZWebServerManager.h"
#import <GCDWebServer/GCDWebServer.h>

@interface RZWebServerManager ()

@property(nonatomic,strong) GCDWebServer *webServer;

@end

@implementation RZWebServerManager

+ (RZWebServerManager *)shareInstance {
    static RZWebServerManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _webServer = [[GCDWebServer alloc] init];
        [_webServer addGETHandlerForBasePath:@"/" directoryPath:NSHomeDirectory() indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
    }
    return self;
}

- (BOOL)start {
    return [_webServer startWithPort:8007 bonjourName:nil];
}

- (void)stop {
    [_webServer stop];
}

- (NSUInteger)port {
    return _webServer.port;
}

- (BOOL)isRunning {
    return _webServer.running;
}

@end
