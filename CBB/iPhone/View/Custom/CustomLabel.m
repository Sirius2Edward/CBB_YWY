//
//  CustomLabel.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-12.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "CustomLabel.h"
#import <CoreText/CoreText.h>
@implementation CustomLabel
@synthesize insets;
- (id)init
{
    if (self = [super init]) {
        self.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        self.numberOfLines = 0;
    }
    return self;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

//文本与边界的距离
-(void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end

@implementation TouchLabel
{
    UIControl *touch;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor blueColor];
        self.font = [UIFont fontWithName:@"Thonburi" size:14];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    touch.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    float bottomY = CGRectGetMaxY(self.bounds)-1;
    CGContextMoveToPoint(ctx, 0, bottomY);
    CGContextAddLineToPoint(ctx, textSize.width, bottomY);
    CGContextStrokePath(ctx);
}

//touch to link
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.userInteractionEnabled = YES;
    if (!touch) {
        touch = [[UIControl alloc] init];
        touch.backgroundColor = [UIColor clearColor];
        touch.frame = self.bounds;
        [self addSubview:touch];
    }
    [touch addTarget:target action:action forControlEvents:controlEvents];
}
@end

@implementation KeyWordLabel
{
    NSMutableAttributedString *resultAttributedString;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        resultAttributedString = [[NSMutableAttributedString alloc]init];
    }
    return self;
}

-(void)setText:(NSString *)text WithFont:(UIFont *)font AndColor:(UIColor *)color{
    self.text = text;
    int len = [text length];
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc]initWithString:text];
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)color.CGColor range:NSMakeRange(0, len)];
    CTFontRef ctFont2 = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize,NULL);
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)ctFont2 range:NSMakeRange(0, len)];
    CFRelease(ctFont2);
    resultAttributedString = mutaString;
}


-(void)setKeywordLight:(NSString *)keyword WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor
{
    if (!keyword) {
        return;
    }
    NSRange range = [self.text rangeOfString:keyword];    
    [resultAttributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)keyWordColor.CGColor range:range];
    CTFontRef ctFont1 = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize,NULL);
    [resultAttributedString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)ctFont1 range:range];
    CFRelease(ctFont1);
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.text !=nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0.0, 0.0);//move
        CGContextScaleCTM(context, 1.0, -1.0);
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge  CFAttributedStringRef)resultAttributedString);
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathAddRect(pathRef,NULL , CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));//const CGAffineTransform *m
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef,NULL );//CFDictionaryRef frameAttributes
        CGContextTranslateCTM(context, 0, -self.bounds.size.height);
        CGContextSetTextPosition(context, 0, 0);
        CTFrameDraw(frame, context);
        CGContextRestoreGState(context);
        CGPathRelease(pathRef);
        CFRelease(framesetter);
        UIGraphicsPushContext(context);
        
    }
}
@end



@implementation DetailLabel
{
    UIImageView *background;
    UILabel *title;
    UILabel *content;
}
-(id)init
{
    if (self = [super init]) {
        background = [UIImageView new];
        [self addSubview:background];
        
        title = [[UILabel alloc] init];
        title.textAlignment = NSTextAlignmentRight;
        title.textColor = [UIColor darkGrayColor];
        title.font = [UIFont systemFontOfSize:14];
        title.backgroundColor = [UIColor clearColor];
        title.numberOfLines = 0;

        [self addSubview:title];
        
        content = [[UILabel alloc] init];
        content.font = [UIFont systemFontOfSize:14];
        content.backgroundColor = [UIColor clearColor];
        content.numberOfLines = 0;
        [self addSubview:content];
    }
    return self;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    background.image = backgroundImage;
}

-(void)setTitleStr:(NSString *)titleStr
{
    title.text = titleStr;
}

-(void)setContentStr:(NSString *)contentStr
{
    if ([title.text isEqualToString:@"级别:"]) {
        for (int k = 0; k < 5; k++) {
            NSString *image = nil;
            if (k < contentStr.integerValue) {
                image = @"xing01.png";
            }
            else {
                image = @"xing02.png";
            }
            UIImageView *xing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
            xing.frame = CGRectMake(105+k*11, 12, 10, 10);
            [self addSubview:xing];
        }
        return;
    }
    content.text = contentStr;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    background.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    title.frame = CGRectMake(5, 0, 90, frame.size.height);
    content.frame = CGRectMake(103, 3, 200, frame.size.height-3);
}
@end