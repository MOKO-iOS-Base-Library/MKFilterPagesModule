//
//  MKFilterByAdvNameController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"

#import "MKFilterByAdvNameProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByAdvNameController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByAdvNameProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
