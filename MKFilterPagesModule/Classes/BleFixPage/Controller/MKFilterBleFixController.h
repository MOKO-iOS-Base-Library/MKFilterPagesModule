//
//  MKFilterBleFixController.h
//  MKFilterPagesModule
//
//  Created by aa on 2026/11/13.
//

#import "MKBaseViewController.h"
#import "MKFilterBleFixProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// 通用的 Bluetooth Fix 入口页面
/// 业务模块实现 MKFilterBleFixProtocol 后，直接 init 即可
@interface MKFilterBleFixController : MKBaseViewController

- (instancetype)initWithProtocol:(id<MKFilterBleFixProtocol>)protocol;

@end

NS_ASSUME_NONNULL_END
