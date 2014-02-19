//
//  BaseClientTable.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-19.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "BaseClientTable.h"

@interface BaseClientTable ()

@end

@implementation BaseClientTable
{
    EGORefreshTableHeaderView *_refreshHeaderView;//下拉刷新
    EGORefreshTableFooterView *_refreshFooterView;//上拉加载
    BOOL _reloading;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)loadView
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 66) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backBarButton.frame = CGRectMake(0, 0, 51, 33);
    [backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[self.tableView addSubview:_refreshHeaderView];
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}
#pragma  mark - refresh

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setFooterView];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - EGORefreshTable
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
	return _reloading; // should return if data source model is reloading
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{	
	return [NSDate date]; // should return date data source was last changed
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.tableView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    //    NSLog(@"%f",height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }
    else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        //搜索结果添加footer
        [self.tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}
#pragma mark - Load Data
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        [self reloadTableViewDataSource];
    }
    else if(aRefreshPos == EGORefreshFooter)
    {
        // 上拉加载数据 loadNext
        [self loadNextTableViewDataSource];
//        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0f];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

//更新数据
- (void)reloadTableViewDataSource
{
	_reloading = YES;
}

//请求更多数据
- (void)loadNextTableViewDataSource
{
	_reloading = YES;    
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [self.tableView reloadData];//更新数据之后，加载表格
    [self setFooterView];
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
}

-(void)popAction
{

}
@end
