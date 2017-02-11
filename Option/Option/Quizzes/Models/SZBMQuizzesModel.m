//
//  SZBMQuizzesModel.m
//  alertExten
//
//  Created by Kerwin on 16/11/29.
//  Copyright © 2016年 xiaoquan jiang. All rights reserved.
//

#import "SZBMQuizzesModel.h"
#import "SZBMOptionInfo.h"
#import "SZBMOptionView.h"

#define kWord @[@"A",@"B",@"C",@"D"]

@implementation SZBMQuizzesModel

+ (SZBMQuizzesModel *)testModel
{
    SZBMQuizzesModel *model = [[SZBMQuizzesModel alloc] init];
    model.examId = @"1";
    model.answer = @"A、B、C";
    model.examQuestion = @"国家主席习近平抵达利马，出席亚太经合组织第二十四次领导人非正式会议并对秘鲁共和国进行国事访问?????";
    
    NSMutableArray *options = [NSMutableArray new];
    NSString* qtring = @"新华社利马11月18日电 当地时间18日，国家主席习近平抵达利马，出席亚太经合组织第二十四次领导人非正式会议并对秘鲁共和国进行国事访问";
    for ( int i = 0; i < [kWord count]; i++ )
    {
        SZBMOptionInfo *info = [[SZBMOptionInfo alloc] init];
        info.isSelect = NO;
        info.opId = kWord[i];
        info.option = [qtring substringToIndex:random()%qtring.length];
        [options addObject:info];
    }
    model.selects = options;
    model.selfOptinos = @"";
    model.type = [NSString stringWithFormat:@"%zd",random() % 2];
    model.examNum = @"9";
    model.attributedText = [SZBMOptionView attributedWithModel:model];
    return model;
}


@end

