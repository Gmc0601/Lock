//
//  Utils.m
//  BaseProject
//
//  Created by LeoGeng on 19/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(void)writeStringToFile:(NSDictionary*)myArray {
    
    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"bookmark.plist";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [myArray writeToFile:fileAtPath atomically:YES];
}

+(NSMutableArray*)readStringFromFile {
    
    // Build the path...
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"bookmark.plist";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    // The main act...
    NSMutableArray *dict =  [NSMutableArray arrayWithContentsOfFile:fileAtPath];
    return dict;
}

+(BOOL) fileIsExist{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"bookmark.plist";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:fileAtPath];
}
@end
