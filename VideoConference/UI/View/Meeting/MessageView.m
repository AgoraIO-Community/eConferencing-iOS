//
//  MessageView.m
//  VideoConference
//
//  Created by ZYP on 2021/1/5.
//  Copyright © 2021 agora. All rights reserved.
//

#import "MessageView.h"
#import "MeetingMessageCell.h"
#import "MeetingMessageModel.h"

@interface MessageView ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_tempList;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray<MeetingMessageModel *> *list;

@end

@implementation MessageView


- (instancetype)init {
    self = [super init];
    if (self) {
        _tempList = @[].mutableCopy;
        _list = @[];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self setup];
        [self layout];
    }
    return self;
}

- (void)layout {
    [self addSubview:_tableView];
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [_tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
}

- (void)setup {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.scrollEnabled = false;
    _tableView.allowsSelection = false;
    _tableView.transform = CGAffineTransformMakeScale(1, -1);
}

#pragma public

- (void)addModel:(MeetingMessageModel *)model {
    if (_list.count >= 100) {
        [_tempList removeAllObjects];
        [_tempList addObjectsFromArray:@[_list[_list.count-1], _list[_list.count-2]]];
        _list = _tempList.copy;
        [_tableView reloadData];
    }
    
    [_tempList insertObject:model atIndex:0];
    self.list = _tempList.copy;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (self.list.count > 2) {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    }
    if (self.list.count > 0) {
        [_tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionTop];
    }
    
    
}

#pragma UITableViewDelegate & UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MeetingMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingMessageCell"];
    if (cell == nil) {
        cell = [MeetingMessageCell new];
    }
    MeetingMessageModel *model = _list[indexPath.row];
    [cell setModel:model];
    [cell setIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetingMessageModel *model = _list[indexPath.row];
    return model.showButton ? 44+5 : 24+5;
}

@end
