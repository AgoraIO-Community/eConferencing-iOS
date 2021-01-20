//
//  MemberVC.m
//  VideoConference
//
//  Created by ZYP on 2021/1/18.
//  Copyright © 2021 agora. All rights reserved.
//

#import "MemberVC.h"
#import "UserCell.h"

typedef NS_ENUM(NSUInteger, MemberVCNavStyle) {
    MemberVCNavStyleNormal,
    MemberVCNavStyleSearch,
};

@interface MemberVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray<NSString *> *dataList;
@property (nonatomic, assign)MemberVCNavStyle style;
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)UIBarButtonItem *rightButtonSearch;
@property (nonatomic, strong)UIBarButtonItem *rightButtonCancle;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation MemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

- (void)setup {
    
    _dataList = @[];
    
    _searchBar = [UISearchBar new];
    _searchBar.placeholder = @"搜索名字";
    _searchBar.delegate = self;
    
    _titleLabel = [UILabel new];
    [_titleLabel setFont:[UIFont systemFontOfSize:17]];
    _rightButtonSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(test:)];
    _rightButtonCancle = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(test:)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:UserCell.idf bundle:nil] forCellReuseIdentifier:UserCell.idf];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [self setStyle:MemberVCNavStyleNormal];
}

- (void)setStyle:(MemberVCNavStyle)style {
    _style = style;
    if (style == MemberVCNavStyleNormal) {
        _titleLabel.text = [NSString stringWithFormat:@"成员（%ld）", _dataList.count];
        self.navigationItem.titleView = _titleLabel;
        [self.navigationItem setHidesBackButton:false];
        self.navigationItem.rightBarButtonItem = _rightButtonSearch;
    }
    else {
        _searchBar.alpha = 0;
        self.navigationItem.titleView = _searchBar;
        [self.navigationItem.titleView layoutIfNeeded];
        [UIView animateWithDuration:0.35 animations:^{
            self.searchBar.alpha = 1;
            [self.navigationItem.titleView layoutIfNeeded];
        }];
        [self.navigationItem setHidesBackButton:true];
        self.navigationItem.rightBarButtonItem = _rightButtonCancle;
    }
}

- (void)test:(UIBarButtonItem *)buttonItem {
    if(buttonItem == _rightButtonSearch) {
        [self setStyle:MemberVCNavStyleSearch];
    }
    else {
        [self setStyle:MemberVCNavStyleNormal];
    }
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:UserCell.idf];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}


@end
