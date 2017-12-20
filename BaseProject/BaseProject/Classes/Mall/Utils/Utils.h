//
//  Utils.h
//  BaseProject
//
//  Created by LeoGeng on 19/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+(void)writeStringToFile:(NSDictionary *)aString;
+(NSMutableArray *)readStringFromFile;
+(BOOL) fileIsExist;
@end
