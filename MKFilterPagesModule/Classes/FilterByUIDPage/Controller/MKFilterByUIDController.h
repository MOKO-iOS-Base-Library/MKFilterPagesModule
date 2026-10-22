//
//  MKFilterByUIDController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/9.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"

#import "MKFilterByUIDProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByUIDController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByUIDProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
