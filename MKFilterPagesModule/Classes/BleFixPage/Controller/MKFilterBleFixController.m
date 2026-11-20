//
//  MKFilterBleFixController.m
//  MKFilterPagesModule
//
//  Created by aa on 2026/11/13.
//

#import "MKFilterBleFixController.h"
#import "MKFilterBleFixProtocol.h"
#import "MKFilterRelationshipCell.h"

#import "Masonry.h"
#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKSettingTextCell.h"
#import "MKNormalSliderCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKCustomUIAdopter.h"

@interface MKFilterBleFixController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKNormalSliderCellDelegate,
MKFilterRelationshipCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *section0List;  // TextFieldCell × 2
@property (nonatomic, strong) NSMutableArray *section1List;  // FilterRelationshipCell × 2
@property (nonatomic, strong) NSMutableArray *section2List;  // NormalSliderCell × 1
@property (nonatomic, strong) NSMutableArray *section3List;  // FilterRelationshipCell × 1
@property (nonatomic, strong) NSMutableArray *section4List;  // SettingTextCell × 3
@property (nonatomic, strong) NSMutableArray *section5List;  // SettingTextCell × 0 or 1

@property (nonatomic, strong) NSMutableArray *headerList;

@property (nonatomic, strong) id<MKFilterBleFixProtocol> protocol;

@end

@implementation MKFilterBleFixController

- (instancetype)initWithProtocol:(id<MKFilterBleFixProtocol>)protocol {
    self = [super init];
    if (self) {
        _protocol = protocol;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"MKFilterBleFixController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) return 90.f;
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 5) return 10.f;
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        // Filter by MAC / ADV Name / Raw Data
        if (indexPath.row == 0) {
            [self.protocol pushFilterByMACControllerWithNav:self.navigationController];
        } else if (indexPath.row == 1) {
            if ([self.protocol respondsToSelector:@selector(pushFilterByAdvNameControllerWithNav:)]) {
                [self.protocol pushFilterByAdvNameControllerWithNav:self.navigationController];
            }
        } else if (indexPath.row == 2) {
            [self.protocol pushFilterByRawDataControllerWithNav:self.navigationController];
        }
        return;
    }
    if (indexPath.section == 5) {
        if ([self.protocol respondsToSelector:@selector(pushPayloadContentsControllerWithNav:)]) {
            [self.protocol pushPayloadContentsControllerWithNav:self.navigationController];
        }
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return self.section0List.count;
        case 1: return self.section1List.count;
        case 2: return self.section2List.count;
        case 3: return self.section3List.count;
        case 4: return self.section4List.count;
        case 5: return self.section5List.count;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (section == 1) {
        MKFilterRelationshipCell *cell = [MKFilterRelationshipCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (section == 2) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (section == 3) {
        MKFilterRelationshipCell *cell = [MKFilterRelationshipCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    // section4 / section5: SettingTextCell
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = (section == 4)
        ? self.section4List[indexPath.row]
        : self.section5List[indexPath.row];
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        [self.protocol timeoutTextFieldValueChanged:value];
    } else if (index == 1) {
        [self.protocol numberOfMACTextFieldValueChanged:value];
    }
}

#pragma mark - MKNormalSliderCellDelegate
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index {
    if (index == 0) {
        [self.protocol rssiSliderValueChanged:value];
    }
}

#pragma mark - MKFilterRelationshipCellDelegate
- (void)mk_filterRelationshipCell:(MKFilterRelationshipCell *)cell
            relationshipChanged:(NSInteger)index
                   dataListIndex:(NSInteger)dataListIndex {
    if (index == 0) {
        [self.protocol priorityChanged:dataListIndex];
    } else if (index == 1) {
        if ([self.protocol respondsToSelector:@selector(phyChanged:)]) {
            [self.protocol phyChanged:dataListIndex];
        }
    } else if (index == 2) {
        [self.protocol relationshipChanged:dataListIndex];
    }
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];

    BOOL hasSection5 = ([self.protocol respondsToSelector:@selector(hasPayloadContentsSection)]
                        && [self.protocol hasPayloadContentsSection]);
    if (hasSection5) {
        [self loadSection5Datas];
    }

    // 构建 header：section0~4 始终存在（5 个），section5 可选
    NSUInteger sectionCount = hasSection5 ? 6 : 5;
    [self.headerList removeAllObjects];
    for (NSUInteger i = 0; i < sectionCount; i++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }

    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Positioning Timeout";
    cellModel1.textPlaceholder = @"1~10";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.protocol.timeout;
    cellModel1.maxLength = 2;
    cellModel1.unit = @"S";
    [self.section0List addObject:cellModel1];

    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Number Of MAC";
    cellModel2.textPlaceholder = @"1~15";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.protocol.number;
    cellModel2.maxLength = 2;
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    // Mechanism cell（必填，始终创建）
    MKFilterRelationshipCellModel *mechanismCell = [[MKFilterRelationshipCellModel alloc] init];
    mechanismCell.index = 0;
    mechanismCell.msg = @"Bluetooth Fix Mechanism";
    mechanismCell.dataList = [self.protocol priorityDataList];
    mechanismCell.dataListIndex = self.protocol.priority;
    [self.section1List addObject:mechanismCell];

    // PHY cell（可选，硬件不支持 PHY 时跳过）
    if ([self.protocol respondsToSelector:@selector(phyDataList)]) {
        NSArray *phyList = [self.protocol phyDataList];
        if (phyList && phyList.count > 0) {
            MKFilterRelationshipCellModel *phyCell = [[MKFilterRelationshipCellModel alloc] init];
            phyCell.index = 1;
            phyCell.msg = @"Scanning Type/PHY";
            phyCell.dataList = phyList;
            phyCell.dataListIndex = self.protocol.phy;
            [self.section1List addObject:phyCell];
        }
    }
}

- (void)loadSection2Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = [MKCustomUIAdopter attributedString:
                       @[@"RSSI Filter", @"   (-127dBm ~ 0dBm)"]
                                                 fonts:
                       @[MKFont(15.f), MKFont(13.f)]
                                                 colors:
                       @[DEFAULT_TEXT_COLOR, RGBCOLOR(223, 223, 223)]];
    cellModel.changed = YES;
    cellModel.noteMsgColor = RGBCOLOR(223, 223, 223);
    cellModel.leftNoteMsg = @"*The device will uplink valid ADV data with RSSI no less than";
    cellModel.rightNoteMsg = @".";
    cellModel.sliderValue = self.protocol.rssi;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKFilterRelationshipCellModel *cellModel = [[MKFilterRelationshipCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Filter Relationship";
    cellModel.dataList = [self.protocol relationshipDataList];
    cellModel.dataListIndex = self.protocol.relationship;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    NSArray *titles = @[@"Filter by MAC", @"Filter by ADV Name", @"Filter by Raw Data"];
    for (NSString *title in titles) {
        MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
        cellModel.leftMsg = title;
        [self.section4List addObject:cellModel];
    }
}

- (void)loadSection5Datas {
    MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
    cellModel.leftMsg = [self.protocol payloadContentsTitle] ?: @"Report Contents Selection";
    [self.section5List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [self.protocol pageTitle] ?: @"Bluetooth Fix";
    [self.rightButton setImage:LOADICON(@"MKFilterPagesModule", @"MKFilterBleFixController", @"mk_filterPages_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)section0List { if (!_section0List) _section0List = [NSMutableArray array]; return _section0List; }
- (NSMutableArray *)section1List { if (!_section1List) _section1List = [NSMutableArray array]; return _section1List; }
- (NSMutableArray *)section2List { if (!_section2List) _section2List = [NSMutableArray array]; return _section2List; }
- (NSMutableArray *)section3List { if (!_section3List) _section3List = [NSMutableArray array]; return _section3List; }
- (NSMutableArray *)section4List { if (!_section4List) _section4List = [NSMutableArray array]; return _section4List; }
- (NSMutableArray *)section5List { if (!_section5List) _section5List = [NSMutableArray array]; return _section5List; }
- (NSMutableArray *)headerList { if (!_headerList) _headerList = [NSMutableArray array]; return _headerList; }

@end
