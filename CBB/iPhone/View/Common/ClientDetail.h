//
//  ClientDetail.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-16.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientDetail : UIViewController
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)NSDictionary *detailInfo;
@end

//信用卡新客户详情表
@class NewCardClientCell;
@interface NewCardClientDetail : ClientDetail
@property(nonatomic,retain)NewCardClientCell *cell;
@property(nonatomic,retain)NSString *uid;
@end

//信用卡已购买客户详情表
@interface DoneCardClientDetail : ClientDetail
@end

//贷款新客户详情表
@class NewLoanClientCell;
@interface NewLoanClientDetail : ClientDetail
@property(nonatomic,retain)NewLoanClientCell *cell;
@property(nonatomic,retain)NSString *uid;
@end

//贷款已购买客户详情表
@interface DoneLoanClientDetail : ClientDetail
@end