//
//  MKFilterByRawDataController.m
//  MKFilterPagesModule
//
//  Created by aa on 2026/11/13.
//

#import "MKFilterByRawDataController.h"
#import "MKFilterByRawDataProtocol.h"

#import "Masonry.h"
#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKNormalTextCell.h"

@interface MKFilterByRawDataController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *section0List;   // NormalTextCell, iBeacon/UID/URL/TLM/BXP-iBeacon

@property (nonatomic, strong) NSMutableArray *section1List;   // TextSwitchCell, BXP-DeviceInfo/ACC/T&H

@property (nonatomic, strong) NSMutableArray *section2List;   // NormalTextCell, 原始数据类型（由 Protocol 决定）

@property (nonatomic, weak) id<MKFilterByRawDataProtocol> protocol;

@end

@implementation MKFilterByRawDataController

- (instancetype)initWithProtocol:(id<MKFilterByRawDataProtocol>)protocol {
    self = [super init];
    if (self) {
        _protocol = protocol;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"MKFilterByRawDataController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // section0: iBeacon / UID / URL / TLM / BXP-iBeacon
        mk_filterByRawDataType rawType;
        switch (indexPath.row) {
            case 0: rawType = mk_filterByRawDataType_iBeacon; break;
            case 1: rawType = mk_filterByRawDataType_EddystoneUID; break;
            case 2: rawType = mk_filterByRawDataType_EddystoneURL; break;
            case 3: rawType = mk_filterByRawDataType_EddystoneTLM; break;
            case 4: rawType = mk_filterByRawDataType_BXPBeacon; break;
            default: return;
        }
        [self.protocol pushFilterControllerForRawType:rawType navController:self.navigationController];
        return;
    }
    if (indexPath.section == 2) {
        // section2: 原始数据类型列表，由 Protocol 提供
        NSArray *supportedTypes = [self.protocol supportedRawDataTypesForSection2];
        if (indexPath.row < supportedTypes.count) {
            mk_filterByRawDataType rawType = [supportedTypes[indexPath.row] integerValue];
            [self.protocol pushFilterControllerForRawType:rawType navController:self.navigationController];
        }
        return;
    }
    // section1 是开关，不响应 didSelect（由 delegate 处理）
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.section0List.count;
    if (section == 1) return self.section1List.count;
    if (section == 2) return self.section2List.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        [self.protocol configBXPDeviceInfoStatus:isOn
                                         sucBlock:^{
            MKTextSwitchCellModel *cellModel = self.section1List[0];
            cellModel.isOn = isOn;
        }
                                      failedBlock:^(NSError * _Nonnull error) {
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
            [self.tableView mk_reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }];
        return;
    }
    if (index == 1) {
        [self.protocol configBXPAccStatus:isOn
                                 sucBlock:^{
            MKTextSwitchCellModel *cellModel = self.section1List[1];
            cellModel.isOn = isOn;
        }
                              failedBlock:^(NSError * _Nonnull error) {
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
            [self.tableView mk_reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }];
        return;
    }
    if (index == 2) {
        [self.protocol configBXPTHStatus:isOn
                                sucBlock:^{
            MKTextSwitchCellModel *cellModel = self.section1List[2];
            cellModel.isOn = isOn;
        }
                             failedBlock:^(NSError * _Nonnull error) {
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
            [self.tableView mk_reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }];
        return;
    }
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellStatus];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - cell status update (ON/OFF)
- (void)updateCellStatus {
    // section0: 5 个（iBeacon / UID / URL / TLM / BXP-iBeacon）
    MKNormalTextCellModel *c0 = self.section0List[0];
    c0.rightMsg = (self.protocol.iBeacon ? @"ON" : @"OFF");
    MKNormalTextCellModel *c1 = self.section0List[1];
    c1.rightMsg = (self.protocol.uid ? @"ON" : @"OFF");
    MKNormalTextCellModel *c2 = self.section0List[2];
    c2.rightMsg = (self.protocol.url ? @"ON" : @"OFF");
    MKNormalTextCellModel *c3 = self.section0List[3];
    c3.rightMsg = (self.protocol.tlm ? @"ON" : @"OFF");
    MKNormalTextCellModel *c4 = self.section0List[4];
    c4.rightMsg = (self.protocol.bxpBeacon ? @"ON" : @"OFF");

    // section1: 3 个开关
    MKTextSwitchCellModel *s1_0 = self.section1List[0];
    s1_0.isOn = self.protocol.bxpDeviceInfo;
    MKTextSwitchCellModel *s1_1 = self.section1List[1];
    s1_1.isOn = self.protocol.bxpAcc;
    MKTextSwitchCellModel *s1_2 = self.section1List[2];
    s1_2.isOn = self.protocol.bxpTH;

    // section2: 由 Protocol 返回的 supportedTypes 决定
    NSArray *supportedTypes = [self.protocol supportedRawDataTypesForSection2];
    for (NSUInteger i = 0; i < self.section2List.count && i < supportedTypes.count; i++) {
        mk_filterByRawDataType rawType = [supportedTypes[i] integerValue];
        BOOL isOn = [self isOnForRawType:rawType];
        MKNormalTextCellModel *cellModel = self.section2List[i];
        cellModel.rightMsg = (isOn ? @"ON" : @"OFF");
    }

    [self.tableView reloadData];
}

- (BOOL)isOnForRawType:(mk_filterByRawDataType)rawType {
    switch (rawType) {
        case mk_filterByRawDataType_BXPButton: return self.protocol.bxpButton;
        case mk_filterByRawDataType_BXPTag: return self.protocol.bxpTag;
        case mk_filterByRawDataType_PIR: return self.protocol.pir;
        case mk_filterByRawDataType_TOF: return self.protocol.tof;
        case mk_filterByRawDataType_NanoBeacon: return self.protocol.nanoBeacon;
        case mk_filterByRawDataType_Other: return self.protocol.other;
        default: return NO;
    }
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    NSArray *titles = @[@"iBeacon", @"Eddystone-UID", @"Eddystone-URL", @"Eddystone-TLM", @"BXP-iBeacon"];
    for (NSString *title in titles) {
        MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
        cellModel.showRightIcon = YES;
        cellModel.leftMsg = title;
        [self.section0List addObject:cellModel];
    }
}

- (void)loadSection1Datas {
    NSArray *titles = @[@"BXP - Device Info", @"BXP - ACC", @"BXP - T&H"];
    for (NSUInteger i = 0; i < titles.count; i++) {
        MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
        cellModel.index = i;
        cellModel.msg = titles[i];
        [self.section1List addObject:cellModel];
    }
}

- (void)loadSection2Datas {
    NSDictionary *typeTitleMap = @{
        @(mk_filterByRawDataType_BXPButton): @"BXP - Button",
        @(mk_filterByRawDataType_BXPTag): @"BXP - T&S",
        @(mk_filterByRawDataType_PIR): @"MK - PIR",
        @(mk_filterByRawDataType_TOF): @"BXP-TOF",
        @(mk_filterByRawDataType_NanoBeacon): @"NanoBeacon Info",
        @(mk_filterByRawDataType_Other): @"Other",
    };
    NSArray *supportedTypes = [self.protocol supportedRawDataTypesForSection2];
    for (NSNumber *typeNum in supportedTypes) {
        NSString *title = typeTitleMap[typeNum] ?: @"Unknown";
        MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
        cellModel.showRightIcon = YES;
        cellModel.leftMsg = title;
        [self.section2List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [self.protocol pageTitle] ?: @"Filter by Raw Data";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(self.view).offset(kTopBarHeight);
        make.bottom.equalTo(self.view).offset(-kSafeAreaHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) _section0List = [NSMutableArray array];
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) _section1List = [NSMutableArray array];
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) _section2List = [NSMutableArray array];
    return _section2List;
}

@end
