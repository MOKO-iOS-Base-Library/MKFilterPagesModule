//
//  MKFilterByURLController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/9.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"

#import "MKFilterByURLProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByURLController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByURLProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
