//
//  SelfViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/29.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "SelfViewController.h"
#import "BluetoothViewController.h"

@interface SelfViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UIImageView *headerBgView;
@end

#define HEADER_HEIGHT 220

@implementation SelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"KyleLiang"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    
    self.headerBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.headerBgView setImage:[UIImage imageNamed:@"bgSelf"]];

    [headerView addSubview:self.headerBgView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultHeadImage"]];
    iconView.layer.cornerRadius = 50;
    iconView.layer.masksToBounds = YES;
    [headerView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"KyleLiang";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:17];
    [headerView addSubview:nameLabel];
    
    UILabel *dataLabel = [[UILabel alloc]init];
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.textColor = [UIColor whiteColor];
    dataLabel.text = @"关注 121  |  粉丝 17";
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:dataLabel];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.text = @"简介:这个家伙很懒哦...";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:detailLabel];
    
    //设置顶部视图
    [self.tableView setTableHeaderView:headerView];
    
    WeakSelf(weakSelf);
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.headerBgView);
        make.centerY.equalTo(weakSelf.headerBgView).with.offset(-25);
        make.width.height.mas_equalTo(100);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.headerBgView).with.offset(50);
        make.right.equalTo(weakSelf.headerBgView).with.offset(-50);
    }];
    [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(8);
        make.left.equalTo(nameLabel);
        make.right.equalTo(nameLabel);
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dataLabel.mas_bottom).with.offset(8);
        make.left.equalTo(nameLabel);
        make.right.equalTo(nameLabel);
    }];
    
    //设置底部视图，去掉多余的分割线
    [self.tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    self.headerBgView.frame = CGRectMake(0, 0, size.width, HEADER_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    //resetting delegate
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    //scrollViewDidScroll will be triggered if comment this line
    self.tableView.delegate = nil;
}

#pragma mark - Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"reuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row == 0){
        cell.textLabel.text = @"Bluetooth";
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"UITableCellView %zd",indexPath.row];
    }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0 && indexPath.row == 0){
        BluetoothViewController *vc = [[BluetoothViewController alloc]init];
        vc.title = @"Bluetooth";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIViewController *vc = [[UIViewController alloc]init];
        vc.title = [NSString stringWithFormat:@"UITableCellView %zd",indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f",SCREEN_WIDTH);
    if (y < 0) {
        self.headerBgView.frame = CGRectMake(0, y, SCREEN_WIDTH, HEADER_HEIGHT - y);
    }
    
    if(y > HEADER_HEIGHT - 64){
        [self.navigationController setNavigationBarHidden:NO];
    }else{
        [self.navigationController setNavigationBarHidden:YES];
    }
}

#pragma mark - LifeCycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
