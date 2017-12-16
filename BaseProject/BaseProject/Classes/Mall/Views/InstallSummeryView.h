//
//  InstallSummeryView.h
//  BaseProject
//
//  Created by LeoGeng on 16/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstallSummeryView : UIView
@property(retain,nonatomic) NSArray *require;
@property(retain,nonatomic) NSArray *unRequire;
-(void) loadData;
@end
