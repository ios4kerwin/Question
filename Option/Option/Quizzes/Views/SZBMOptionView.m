//
//  SZBMOptionView.m
//  alertExten
//
//  Created by Kerwin on 16/11/24.
//  Copyright © 2016年 xiaoquan jiang. All rights reserved.
//  深圳项目选择view

#import "SZBMOptionView.h"
#import "SZBMQuizzesModel.h"


#define SZBMLinkBackgroundTag 10000

@implementation SZBMLink

@end

@implementation SZBMOptionAttachment

- (void)setImgStr:(NSString *)imgStr
{
    _imgStr = imgStr;
    self.image = [UIImage imageNamed:imgStr];
}

@end


@interface SZBMOptionView ()
<
   UITextViewDelegate
>

@property(nonatomic,strong) UITextView          *textView;
@property (nonatomic,strong) NSMutableArray     *links;
@property(nonatomic,strong) SZBMLink            *touchLink;

@end

@implementation SZBMOptionView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clickBgColor = [UIColor grayColor];
        self.textViewWidth = 0;
        self.textView.frame = self.bounds;
        [self addSubview:self.textView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = self.bounds;
}

#pragma mark - 事件处理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    // 得出被点击的那个链接
    SZBMLink *touchingLink = [self touchingLinkWithPoint:point];
    self.touchLink = touchingLink;
    // 设置链接选中的背景
    if (!self.touchLink) return;
    [self showLinkBackground:touchingLink];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    // 得出被点击的那个链接
    SZBMLink *touchingLink = [self touchingLinkWithPoint:point];
    if (touchingLink != self.touchLink)
    {
        [self touchesCancelled:touches withEvent:event];
        return;
    }
    if (touchingLink)
    {
        // 说明手指在某个链接上面抬起来, 发出通知
        touchingLink.info.isSelect = !touchingLink.info.isSelect;
        if (![self.model.type boolValue])
        {
            for (SZBMOptionInfo *info in self.model.selects)
            {
                if (![info isEqual:touchingLink.info])
                {
                    info.isSelect = NO;
                }
            }
        }
        self.model.attributedText = [SZBMOptionView attributedWithModel:self.model];
        self.textView.attributedText = self.model.attributedText;
        NSLog(@"----%@",touchingLink.info.option);
        [[NSNotificationCenter defaultCenter] postNotificationName:kQuizzesNotificationKey
                                                            object:self.model];
        
    }
    // 相当于触摸被取消
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [self removeAllLinkBackground];
    });
}


- (void)removeAllLinkBackground
{
    for (UIView *child in self.subviews)
    {
        if (child.tag == SZBMLinkBackgroundTag)
        {
            [child removeFromSuperview];
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

#pragma mark - 链接背景处理
/**
 *  根据触摸点找出被触摸的链接
 *
 *  @param point 触摸点
 */
- (SZBMLink *)touchingLinkWithPoint:(CGPoint)point
{
    __block SZBMLink *touchingLink = nil;
    [self.links enumerateObjectsUsingBlock:^(SZBMLink *link, NSUInteger idx, BOOL *stop)
    {
        CGRect aRect = [self rectWithRects:link.rects];
        if (CGRectContainsPoint(aRect, point))
        {
            touchingLink = link;
        }
    }];
    return touchingLink;
}

/**
 *  显示链接的背景
 *
 *  @param link 需要显示背景的link
 */
- (void)showLinkBackground:(SZBMLink *)link
{
    UIView *bg = [[UIView alloc] init];
    bg.tag = SZBMLinkBackgroundTag;
    bg.layer.cornerRadius = 0;
    bg.frame = [self rectWithRects:link.rects];
    bg.backgroundColor = self.clickBgColor;
    bg.layer.cornerRadius = 1;
    bg.alpha = 0.5;
    bg.layer.masksToBounds = YES;
    [self addSubview:bg];
}

- (CGRect)rectWithRects:(NSArray *)rects
{
    CGRect aRect;
    UITextSelectionRect *fistRect = [rects firstObject];
    UITextSelectionRect *lastRect = [rects lastObject];
    aRect = CGRectMake(fistRect.rect.origin.x - 20,
                       fistRect.rect.origin.y - 5,
                       self.textView.frame.size.width - fistRect.rect.origin.x + 20,
                       lastRect.rect.origin.y + lastRect.rect.size.height - fistRect.rect.origin.y + 6);
    return aRect;
}

- (NSMutableArray *)links
{
    if (!_links) {
        NSMutableArray *links = [NSMutableArray array];
        
        // 搜索所有的链接
        [self.model.attributedText enumerateAttributesInRange:NSMakeRange(0, self.model.attributedText.length)
                                                options:0
                                             usingBlock:^(NSDictionary *attrs,
                                                          NSRange range,
                                                          BOOL *stop)
        {
            SZBMOptionInfo *info = attrs[SZBMOptionsKey];
            if (info == nil) return;
            // 创建一个链接
            SZBMLink *link = [[SZBMLink alloc] init];
            link.info = info;
            link.range = range;
            // 处理矩形框
            NSMutableArray *rects = [NSMutableArray array];
            // 设置选中的字符范围
            self.textView.selectedRange = range;
            // 算出选中的字符范围的边框
            NSArray *selectionRects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
            for (UITextSelectionRect *selectionRect in selectionRects)
            {
                if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) continue;
                [rects addObject:selectionRect];
            }
            link.rects = rects;
            [links addObject:link];
        }];
        self.links = links;
    }
    return _links;
}

#pragma mark - getter and setter

- (void)setModel:(SZBMQuizzesModel *)model
{
    _model = model;
    self.links = nil;
    self.textView.attributedText = model.attributedText;
    
    CGSize maxSize = CGSizeMake(self.textViewWidth, MAXFLOAT);
    
    CGSize size = [model.attributedText boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                     context:nil].size;

    model.conHeight = ceil(size.height);
    
    if (model.optionType == SZBMOptionTypeCheck)
    {
        self.textView.userInteractionEnabled = YES;
    }else
    {
        self.textView.userInteractionEnabled = NO;
    }
}

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView  = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = YES;
        _textView.scrollEnabled = NO;
        _textView.userInteractionEnabled = NO;
        _textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        _textView.delegate = self;
        
    }
    return _textView;
}

+ (NSAttributedString *)attributedWithModel:(SZBMQuizzesModel*)model
{
    NSMutableAttributedString *mutableAttriStr = [[NSMutableAttributedString alloc] init];
    //添加换行
    NSMutableAttributedString *lineAttr = [[NSMutableAttributedString alloc]
                                           initWithString:@"\n"
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:4]}];
    
    [mutableAttriStr appendAttributedString:lineAttr];
    CGSize tipSpacesize = CGSizeZero;
    //设置试题题目富文本
    {
        //标题
        NSString *queStr = [model.examQuestion stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        queStr  = [queStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *titleStr = [NSString stringWithFormat:@"%@、%@\n",model.examNum,queStr];
        //标题富文本
        NSMutableAttributedString *titleAttriStr = [[NSMutableAttributedString alloc] init];
        //标题类型图片富文本
        NSMutableAttributedString *typeImgAttri = [[NSMutableAttributedString alloc] init];
        
        SZBMOptionAttachment *typeAttachment = [[SZBMOptionAttachment alloc] init];
        typeAttachment.imgStr = [model.type integerValue] == 0 ? SZBMOptionsRadioTypeImg : SZBMOptionsMultTypeImg;
        typeAttachment.bounds = CGRectMake(0,
                                           -5,
                                           26,
                                           18);
        
        [typeImgAttri appendAttributedString:[NSAttributedString attributedStringWithAttachment:typeAttachment]];
        
        //添加空格
        NSString *spaceStr = @" ";
        [typeImgAttri appendAttributedString:[[NSAttributedString alloc] initWithString:spaceStr]];
        CGSize typeSpacesize = [spaceStr sizeWithAttributes:@{NSFontAttributeName:kQuizzesTitleFont}];
        
        //标题文字富文本
        NSMutableAttributedString *titleConAttriStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
        
        tipSpacesize = CGSizeMake(26 + typeSpacesize.width,18 + typeSpacesize.height);
        //设置段落、行间距
        NSMutableParagraphStyle *titleParagaphy = [[self class] getCommonParagraphStyleWithHeadIndent:tipSpacesize.width];
        titleParagaphy.firstLineHeadIndent = 0;
        
        //标题图标富文本加入到标题富文本
        [titleAttriStr appendAttributedString:typeImgAttri];
        //标题内容富文本加入到标题富文本
        [titleAttriStr appendAttributedString:titleConAttriStr];
        //标题富文本加入到选择富文本
        [mutableAttriStr appendAttributedString:titleAttriStr];
        //设置富文本文字大小
        [mutableAttriStr addAttributes:@{
                                         NSParagraphStyleAttributeName:titleParagaphy,
                                         NSFontAttributeName:kQuizzesTitleFont,
                                         NSForegroundColorAttributeName:kQuizzesTitleColor
                                       }
                               range:NSMakeRange(mutableAttriStr.length - titleAttriStr.length,titleAttriStr.length)];
        //添加换行
    }
    NSInteger nindex = 0;
    //设置试题选项富文本
    for (SZBMOptionInfo *option in model.selects)
    {
        NSRange range = {mutableAttriStr.length,0};
        NSString *optionConStr = [NSString stringWithFormat:@"%@ %@",option.opId,option.option];
        //每一个选项的富文本
        NSMutableAttributedString *optionAttriStr = [[NSMutableAttributedString alloc] init];
        
        //设置选项选择按钮
        NSMutableAttributedString *addImgAttri = [[NSMutableAttributedString alloc] init];
        SZBMOptionAttachment *textAttachment = [[SZBMOptionAttachment alloc] init];
        if (model.optionType == SZBMOptionTypeCheck)
        {
            if (option.isSelect)
            {
                textAttachment.imgStr = option.isRight? SZBMOptionsSelImg : SZBMOptionsFalseImg;
            }else
            {
                textAttachment.imgStr = SZBMOptionsNorImg;
            }
            
        }else
        {
            textAttachment.imgStr = option.isSelect ? SZBMOptionsSelImg : SZBMOptionsNorImg;
        }
        textAttachment.bounds = CGRectMake(0,
                                           -5,
                                           textAttachment.image.size.width,
                                           textAttachment.image.size.height);
        
        [addImgAttri appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
        
        //添加空格
        NSString *spaceStr = @" ";
        [addImgAttri appendAttributedString:[[NSAttributedString alloc] initWithString:spaceStr]];
        CGSize spacesize = [spaceStr sizeWithAttributes:@{NSFontAttributeName:kQuizzesOptionFont}];
        
        //选项内容富文本
        NSMutableAttributedString *addOptionConAttri = [[NSMutableAttributedString alloc] initWithString:optionConStr];

        NSMutableParagraphStyle *paragaphy = [[self class] getCommonParagraphStyleWithHeadIndent:textAttachment.image.size.width + spacesize.width + tipSpacesize.width];
        paragaphy.firstLineHeadIndent = tipSpacesize.width;
        
        //选项图标富文本加入到选项富文本
        [optionAttriStr appendAttributedString:addImgAttri];
        
        [optionAttriStr appendAttributedString:addOptionConAttri];
        
        //选项内容富文本加入选择富文本
        [mutableAttriStr appendAttributedString:optionAttriStr];
        
        [mutableAttriStr addAttributes:@{NSFontAttributeName:kQuizzesOptionFont,
                                         NSParagraphStyleAttributeName:paragaphy,
                                         NSForegroundColorAttributeName:kQuizzesTitleColor,
                                         SZBMOptionsKey:option
                                         }
                                 range:NSMakeRange(mutableAttriStr.length - optionAttriStr.length, [optionAttriStr length])];
        
        
        
        range.length = mutableAttriStr.length;
        
        if ( nindex < [model.selects count] - 1 )
        {
            NSMutableAttributedString *addindAttributedString = [[NSMutableAttributedString alloc]
                                                                 initWithString:@"\n"
                                                                 attributes:@{NSFontAttributeName:kQuizzesOptionFont}];
            
            [mutableAttriStr appendAttributedString:addindAttributedString];
        }
        
        nindex++;
    }
    
    //答案展示
    if (model.answer.length > 0 && model.optionType == SZBMOptionTypeCheck)
    {
        NSMutableAttributedString *addindAttributedString = [[NSMutableAttributedString alloc]
                                                             initWithString:@"\n"
                                                             attributes:@{NSFontAttributeName:kQuizzesAnswerFont}];
        
        [mutableAttriStr appendAttributedString:addindAttributedString];
        //答案文字富文本
        NSString *anserStr = [NSString stringWithFormat:@"答案: %@",model.answer];
        NSMutableAttributedString *answerAttriStr = [[NSMutableAttributedString alloc] initWithString:anserStr];
        
        [mutableAttriStr appendAttributedString:answerAttriStr];
        //设置富文本文字样式
        [mutableAttriStr addAttributes:@{
                                         NSFontAttributeName:kQuizzesAnswerFont,
                                         NSForegroundColorAttributeName:kQuizzesAnswerColor
                                         }
                                 range:NSMakeRange(mutableAttriStr.length - answerAttriStr.length,answerAttriStr.length)];
    }
    return mutableAttriStr;
}


/**
 配置 NSAttributedString 的段落区间
 
 @param fheadIndent 距左边的边距
 
 @return NSMutableParagraphStyle
 */
+ (NSMutableParagraphStyle*)getCommonParagraphStyleWithHeadIndent:(float)fheadIndent
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    float flineLineHeight = kQuizzesOptionFont.lineHeight + 1.0f;
    //set the line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.minimumLineHeight = flineLineHeight;
    paragraphStyle.maximumLineHeight = flineLineHeight;
    paragraphStyle.firstLineHeadIndent = 0;
    paragraphStyle.headIndent = fheadIndent;
    paragraphStyle.tailIndent = 0;
    // 段落间间距
    paragraphStyle.paragraphSpacing = 10.0f;
    //行间距
    paragraphStyle.lineSpacing = 2.0f;
    
    return paragraphStyle;
}

/**
 get size from given string
 @return return value description
 */
+ (CGSize)getSizeFromAttribute:(NSDictionary*)attributes
                          body:(NSString*)body
                  recomondSize:(CGSize)reSize
{
    if (CGSizeEqualToSize(CGSizeZero,reSize))
    {
        
        return [body sizeWithAttributes:attributes];
    }
    else
    {
        CGRect rect = [body boundingRectWithSize:reSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        return rect.size;
    }
    
}


@end
