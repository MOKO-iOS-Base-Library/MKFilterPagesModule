//
//  MKFilterByMacController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"

#import "MKFilterByMacProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByMacController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByMacProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
