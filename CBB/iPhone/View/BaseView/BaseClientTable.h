//
//  BaseClientTable.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-19.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface BaseClientTable : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign)UITableViewStyle tableStyle;
- (void)reloadTableViewDataSource;      //更新数据
- (void)loadNextTableViewDataSource;    //请求更多数据
- (void)doneLoadingTableViewData;       //加载完成
-(void)setFooterView;                   //自动设置Footer位置
@end
