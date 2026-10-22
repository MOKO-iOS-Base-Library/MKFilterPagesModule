//
//  MKFilterByNanoController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/9/16.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKBaseViewController.h"

#import "MKFilterByNanoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByNanoController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByNanoProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
