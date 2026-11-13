//
//  MKFilterBleFixProtocol.h
//  MKFilterPagesModule
//
//  Created by aa on 2026/11/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKFilterBleFixProtocol <NSObject>

/// 导航栏标题（defaultTitle），一般是 @"Bluetooth Fix"
@property (nonatomic, copy) NSString *pageTitle;

/// 保存按钮图标名（业务模块 asset 里的 png），比如 @"aj_slotSaveIcon"
@property (nonatomic, copy) NSString *saveIconName;

#pragma mark - section0: TextFieldCell（2 个）

/// Positioning Timeout：1~10，单位秒
@property (nonatomic, copy) NSString *timeout;
/// Number Of MAC：1~15
@property (nonatomic, copy) NSString *number;

- (void)timeoutTextFieldValueChanged:(NSString *)value;
- (void)numberOfMACTextFieldValueChanged:(NSString *)value;

#pragma mark - section1: FilterRelationshipCell（2 个）

/// Bluetooth Fix Mechanism：0=Time Priority, 1=RSSI Priority
@property (nonatomic, assign) NSInteger priority;
/// Scanning Type/PHY：0=1M PHY(BLE 4.x), 1=1M PHY(BLE 5), 2=1M PHY(BLE 4.x+BLE 5), 3=Coded PHY(BLE 5)
@property (nonatomic, assign) NSInteger phy;

/// Bluetooth Fix Mechanism 的 dataList
- (NSArray<NSString *> *)priorityDataList;
/// Scanning Type/PHY 的 dataList
- (NSArray<NSString *> *)phyDataList;

- (void)priorityChanged:(NSInteger)dataListIndex;
- (void)phyChanged:(NSInteger)dataListIndex;

#pragma mark - section2: NormalSliderCell（1 个）

/// -127~0 dBm
@property (nonatomic, assign) NSInteger rssi;

- (void)rssiSliderValueChanged:(NSInteger)value;

#pragma mark - section3: FilterRelationshipCell（1 个）

/// Filter Relationship：7 种组合，见 section3 dataList
@property (nonatomic, assign) NSInteger relationship;

- (NSArray<NSString *> *)relationshipDataList;
- (void)relationshipChanged:(NSInteger)dataListIndex;

#pragma mark - section4: SettingTextCell（固定 3 个 → push 到基础库 MAC/ADV Name + 自建 RawData）

/// push 哪个子 Controller
- (void)pushFilterByMACControllerWithNav:(UINavigationController *)nav;
- (void)pushFilterByAdvNameControllerWithNav:(UINavigationController *)nav;
- (void)pushFilterByRawDataControllerWithNav:(UINavigationController *)nav;

#pragma mark - section5: SettingTextCell（可选，payload/report contents）

/// 是否显示 section5
- (BOOL)hasPayloadContentsSection;
/// section5 标题，比如 @"Report Contents Selection"
- (NSString *)payloadContentsTitle;
/// 点击 section5 第一行 push 哪个 Controller
- (void)pushPayloadContentsControllerWithNav:(UINavigationController *)nav;

#pragma mark - 核心

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
