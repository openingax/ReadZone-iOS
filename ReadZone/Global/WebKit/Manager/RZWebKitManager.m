//
//  RZWebKitManager.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/24.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZWebKitManager.h"

@implementation RZWebKitManager

+ (NSDictionary *)dictionaryWithJSONFile:(NSString *)path {
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *jsonData = [fileHandler readDataToEndOfFile];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    [fileHandler closeFile];
    return result;
}

+ (void)dictionaryWithJSONFile:(NSString *)path complete:(void (^)(NSError *error, NSDictionary *result))complete {
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *jsonData = [fileHandler readDataToEndOfFile];
    
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    [fileHandler closeFile];
    
    complete(error, result);
}

@end
