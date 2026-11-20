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

#pragma mark - 基础配置（@required）

/// 导航栏标题（defaultTitle），一般是 @"Bluetooth Fix"
@property (nonatomic, copy) NSString *pageTitle;

#pragma mark - 以下全部 @optional

@optional

// PHY 相关 —— 硬件不支持 PHY 时全部不实现（section1 只显示 Mechanism 一行）
@property (nonatomic, assign) NSInteger phy;
- (NSArray<NSString *> *)phyDataList;
- (void)phyChanged:(NSInteger)dataListIndex;

// ADV Name 过滤 —— 部分硬件不支持，不实现则点击时不 push
- (void)pushFilterByAdvNameControllerWithNav:(UINavigationController *)nav;

// Payload Contents section —— 整个 section 可选
- (BOOL)hasPayloadContentsSection;
- (NSString *)payloadContentsTitle;
- (void)pushPayloadContentsControllerWithNav:(UINavigationController *)nav;

#pragma mark - 以下全部 @required

@required

#pragma mark - section0: TextFieldCell（2 个，必填）

/// Positioning Timeout：1~10，单位秒
@property (nonatomic, copy) NSString *timeout;
/// Number Of MAC：1~15
@property (nonatomic, copy) NSString *number;

- (void)timeoutTextFieldValueChanged:(NSString *)value;
- (void)numberOfMACTextFieldValueChanged:(NSString *)value;

#pragma mark - section1: Bluetooth Fix Mechanism（必填）

@property (nonatomic, assign) NSInteger priority;
- (NSArray<NSString *> *)priorityDataList;
- (void)priorityChanged:(NSInteger)dataListIndex;

#pragma mark - section2: NormalSliderCell（1 个，必填）

@property (nonatomic, assign) NSInteger rssi;
- (void)rssiSliderValueChanged:(NSInteger)value;

#pragma mark - section3: FilterRelationshipCell（1 个，必填）

@property (nonatomic, assign) NSInteger relationship;
- (NSArray<NSString *> *)relationshipDataList;
- (void)relationshipChanged:(NSInteger)dataListIndex;

#pragma mark - section4: SettingTextCell（3 个）

- (void)pushFilterByMACControllerWithNav:(UINavigationController *)nav;
- (void)pushFilterByRawDataControllerWithNav:(UINavigationController *)nav;

#pragma mark - 核心（必填）

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;
- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
