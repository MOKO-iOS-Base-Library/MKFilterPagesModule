//
//  MKFilterByRawDataProtocol.h
//  MKFilterPagesModule
//
//  Created by aa on 2026/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 定义每个 section 里可以显示哪些 BLE Raw Data 类型
typedef NS_ENUM(NSInteger, mk_filterByRawDataType) {
    mk_filterByRawDataType_iBeacon,
    mk_filterByRawDataType_EddystoneUID,
    mk_filterByRawDataType_EddystoneURL,
    mk_filterByRawDataType_EddystoneTLM,
    mk_filterByRawDataType_BXPBeacon,
    mk_filterByRawDataType_BXPDeviceInfo,
    mk_filterByRawDataType_BXPACC,
    mk_filterByRawDataType_BXPTH,
    mk_filterByRawDataType_BXPButton,
    mk_filterByRawDataType_BXPTag,
    mk_filterByRawDataType_PIR,
    mk_filterByRawDataType_TOF,
    mk_filterByRawDataType_NanoBeacon,
    mk_filterByRawDataType_Other,
};

@protocol MKFilterByRawDataProtocol <NSObject>

/// 导航栏标题（defaultTitle）
@property (nonatomic, copy) NSString *pageTitle;

#pragma mark - section0: iBeacon + Eddystone + BXP-iBeacon（开关状态，右侧显示 ON/OFF）

@property (nonatomic, assign) BOOL iBeacon;
@property (nonatomic, assign) BOOL uid;
@property (nonatomic, assign) BOOL url;
@property (nonatomic, assign) BOOL tlm;
@property (nonatomic, assign) BOOL bxpBeacon;

#pragma mark - section1: BXP 三个开关（行内直接切换）

@property (nonatomic, assign) BOOL bxpDeviceInfo;
@property (nonatomic, assign) BOOL bxpAcc;
@property (nonatomic, assign) BOOL bxpTH;

#pragma mark - section2: 原始数据类型列表（开关状态 + 点击 push 子 Controller）

@property (nonatomic, assign) BOOL bxpButton;
@property (nonatomic, assign) BOOL bxpTag;
@property (nonatomic, assign) BOOL pir;
@property (nonatomic, assign) BOOL tof;
@property (nonatomic, assign) BOOL nanoBeacon;
@property (nonatomic, assign) BOOL other;

#pragma mark - 必须由业务模块实现的方法

/// 告诉 Controller section2 应该显示哪些类型
/// 业务模块决定哪些类型在硬件上受支持。返回值里的 rawType 决定行顺序。
/// 示例：AJ 返回 @[@(PIR), @(TOF), @(NanoBeacon), @(Other)]；PB 返回 @[@(PIR), @(Other)]
- (NSArray<NSNumber *> *)supportedRawDataTypesForSection2;

/// section2 点击后 push 哪个子 Controller
/// rawType 指明用户点了哪种类型
- (void)pushFilterControllerForRawType:(mk_filterByRawDataType)rawType
                          navController:(UINavigationController *)navController;

/// section1 开关变化回调（三个 BXP 开关）
/// isOn: 新值
/// sucBlock: 写设备成功后业务模块需要 reload 当前 cell
/// failedBlock: 写设备失败
- (void)configBXPDeviceInfoStatus:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;
- (void)configBXPAccStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;
- (void)configBXPTHStatus:(BOOL)isOn
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// 读设备状态 → 更新所有开关状态
- (void)readDataWithSucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
