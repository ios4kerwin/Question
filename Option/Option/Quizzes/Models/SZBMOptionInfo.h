//
//  SZBMOptionInfo.h
//  trainingsystem
//
//  Created by Kerwin on 16/12/20.
//  Copyright © 2016年 xiaoquan jiang. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface SZBMOptionInfo : NSObject

//选项序号（A B C D E ----）
@property (nonatomic, copy) NSString      *opId;
//选项内容
@property (nonatomic, copy) NSString      *option;
//是否选择了
@property(nonatomic,assign) BOOL          isSelect;
//是否选对
@property(nonatomic,assign) BOOL          isRight;


@end
