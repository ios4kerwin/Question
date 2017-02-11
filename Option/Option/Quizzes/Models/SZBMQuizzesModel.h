//
//  SZBMQuizzesModel.h
//  alertExten
//
//  Created by Kerwin on 16/11/29.
//  Copyright © 2016年 xiaoquan jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SZBMOptionInfo.h"


typedef NS_ENUM(NSInteger,SZBMOptionType)
{
    SZBMOptionTypeNormal = 0, //正常状态（做试题）
    SZBMOptionTypeCheck,      //查看试题
};

/**
 考题模型
 */
@class SZBMOptionInfo;
@interface SZBMQuizzesModel : NSObject
//题号
@property (nonatomic, copy) NSString    *examNum;
//试题id
@property (nonatomic, copy) NSString    *examId;
//题目答案
@property (nonatomic, copy) NSString    *answer;
//问题题目
@property (nonatomic, copy) NSString    *examQuestion;
//选项数组
@property (nonatomic, strong) NSArray   *selects;
//选择的答案
@property (nonatomic, copy) NSString    *selfOptinos;
//多选 单选
@property (nonatomic, copy) NSString    *type;
//试题与查看试题
@property(nonatomic,assign) SZBMOptionType         optionType;
/** 富文本 */
@property (nonatomic, strong) NSAttributedString   *attributedText;
//con内容的高度
@property(nonatomic,assign) CGFloat          conHeight;
//cell的高度
@property(nonatomic,assign) CGFloat          cellHeight;

+ (SZBMQuizzesModel *)testModel;

@end






