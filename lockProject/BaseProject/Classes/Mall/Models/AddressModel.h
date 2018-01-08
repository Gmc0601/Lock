//
//  AddressModel.h
//  BaseProject
//
//  Created by LeoGeng on 12/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property(retain,atomic) NSString *consignee;
@property(retain,atomic) NSString *phone;
@property(retain,atomic) NSString *province;
@property(retain,atomic) NSString *city;
@property(retain,atomic) NSString *county;
@property(retain,atomic) NSString *address;
@end
