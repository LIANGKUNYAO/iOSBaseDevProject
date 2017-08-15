//
//  BluetoothViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/8/14.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "BluetoothViewController.h"
#import "BluetoothTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothViewController ()<UITableViewDataSource,UITableViewDelegate,CBCentralManagerDelegate>

@property (nonatomic,strong) NSMutableArray *peripheralDataArray;
@property (nonatomic,strong) CBCentralManager *manager;

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.peripheralDataArray = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.manager stopScan];
}

#pragma mark - bluetooth delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state){
        case CBManagerStateUnknown:
            NSLog(@"State unknown, update imminent.");
            break;
        case CBManagerStateResetting:
            NSLog(@"The connection with the system service was momentarily lost, update imminent.");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"The platform doesn't support the Bluetooth Low Energy Central/Client role.");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"The application is not authorized to use the Bluetooth Low Energy role.");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"Bluetooth is currently powered off.");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"Bluetooth is currently powered on and available to use.");
            [_manager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
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

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@已连接",peripheral.name]];
    [self.tableView reloadData];
    //[peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@已断开",peripheral.name]];
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(nonnull CBPeripheral *)peripheral error:(nullable NSError *)error{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@连接失败",peripheral.name]];
    [self.tableView reloadData];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheralDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BluetoothTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        cell = [[BluetoothTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                            reuseIdentifier:@"reuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSDictionary *item = [self.peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    CBPeripheralState peripheralState = peripheral.state;
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    
    //Peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
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
        cell.stateTextLabel.textColor = UIColorFromHex(0x3cb361);
        cell.stateTextLabel.text = @"已连接";
    }else{
        cell.stateTextLabel.textColor = UIColorFromHex(0xc70000);
        cell.stateTextLabel.text = @"未连接";
    }

    //RSSI
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = [self.peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];

    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@连接中",peripheral.name]];
    [self.manager connectPeripheral:peripheral options:nil];
}

@end
