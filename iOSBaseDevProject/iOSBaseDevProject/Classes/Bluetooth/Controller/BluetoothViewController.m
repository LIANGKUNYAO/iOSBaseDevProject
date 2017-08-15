//
//  BluetoothViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/8/14.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "BluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "SVProgressHUD.h"

@interface BluetoothViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *peripheralDataArray;

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showInfoWithStatus:@"准备打开设备"];
    self.peripheralDataArray = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)viewWillDisappear:(BOOL)animated{

}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSArray *peripherals = [self.peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [self.peripheralDataArray addObject:item];
        
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -table委托 table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheralDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:@"reuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSDictionary *item = [self.peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    CBPeripheralState peripheralState = peripheral.state;
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    
    cell.textLabel.text = peripheralName;
    if(peripheralState == CBPeripheralStateConnected){
      cell.textLabel.textColor = [UIColor greenColor];
    }else{
      cell.textLabel.textColor = [UIColor redColor];
    }

    //信号和服务
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
