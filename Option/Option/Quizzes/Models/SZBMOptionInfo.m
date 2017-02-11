//
//  SZBMOptionInfo.m
//  trainingsystem
//
//  Created by Kerwin on 16/12/20.
//  Copyright © 2016年 xiaoquan jiang. All rights reserved.
//

#import "SZBMOptionInfo.h"

@implementation SZBMOptionInfo


+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.isSelect = NO;
        self.isRight = NO;
    }
    return self;
}

@end
