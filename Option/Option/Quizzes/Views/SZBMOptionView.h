//
//  SZBMOptionView.h
//  alertExten
//
//  Created by Kerwin on 16/11/24.
//  Copyright © 2016年 xiaoquan jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZBMQuizzesModel.h"

#define kQuizzesNotificationKey  @"kQuizzesNotificationKey"

#define SZBMOptionsKey       @"SZBMOptionsKey"
#define SZBMOptionsTypeKey   @"SZBMOptionsTypeKey"


/*--------------------颜色配置-----------------*/
#define SZBMOptionHexColor(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/*--------------------图片名称----------------*/
//多选
#define SZBMOptionsMultTypeImg       @"option_double"
//单选
#define SZBMOptionsRadioTypeImg      @"option_siggle"
//选项错选
#define SZBMOptionsFalseImg      @"option_choice_false"
//选项正常显示
#define SZBMOptionsNorImg        @"option_choice_nor"
//选项正常选上
#define SZBMOptionsSelImg        @"option_choice_sel"



//类型字体
#define kQuizzesTypeFont        [UIFont systemFontOfSize:16]
//题目字体
#define kQuizzesTitleFont       [UIFont systemFontOfSize:16]
//选项字体
#define kQuizzesOptionFont      [UIFont systemFontOfSize:14]
//答案文字字体
#define kQuizzesAnswerFont      [UIFont systemFontOfSize:15]

//题目文字颜色
#define kQuizzesTitleColor      SZBMOptionHexColor(0x222222,1)
//选项文字颜色
#define kQuizzesOptionColor     SZBMOptionHexColor(0x222222,1)
//答案文字颜色
#define kQuizzesAnswerColor     SZBMOptionHexColor(0x0076ff,1)

/**
 
 */
@interface SZBMLink : NSObject

/*对应选项的模型 */
@property (nonatomic, strong)SZBMOptionInfo  *info;
/*范围 */
@property (nonatomic, assign) NSRange    range;
/*边框 */
@property (nonatomic, strong) NSArray    *rects;

@end

/**
 选择图片Attachment
 */
@interface SZBMOptionAttachment : NSTextAttachment

@property(nonatomic,strong) NSString          *imgStr;

@end

@interface SZBMOptionView : UIView

@property(nonatomic,strong) SZBMQuizzesModel       *model;
//选项点击背景色
@property(nonatomic,strong) UIColor                *clickBgColor;

//UITextView的宽度
@property(nonatomic,assign) CGFloat                textViewWidth;

/**
 根据试题模型，创建富文本

 @param model 试题模型
 @return NSAttributedString
 */
+ (NSAttributedString *)attributedWithModel:(SZBMQuizzesModel*)model;

@end
