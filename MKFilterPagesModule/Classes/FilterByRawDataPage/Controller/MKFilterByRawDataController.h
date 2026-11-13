//
//  MKFilterByRawDataController.h
//  MKFilterPagesModule
//
//  Created by aa on 2026/11/13.
//

#import "MKBaseViewController.h"
#import "MKFilterByRawDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// 通用的 Filter by Raw Data 入口页面
/// 业务模块实现 MKFilterByRawDataProtocol 后，直接 init 即可
@interface MKFilterByRawDataController : MKBaseViewController

- (instancetype)initWithProtocol:(id<MKFilterByRawDataProtocol>)protocol;

@end

NS_ASSUME_NONNULL_END
