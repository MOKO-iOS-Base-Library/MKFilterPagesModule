//
//  MKFilterByNanoBeaconCell.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/9/16.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKBaseCell.h"

/*
    右侧按钮点击事件会抛出MKTextFieldNeedHiddenKeyboard通知
 [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
 */

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByNanoBeaconCellModel : NSObject

#pragma mark ------------------------- cell顶层配置 ---------------------------------

/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

#pragma mark ------------------------- 左侧label配置 ---------------------------------

/// 左侧显示的msg
@property (nonatomic, copy)NSString *msg;

#pragma mark ------------------------- 右侧按钮和数据源配置 ---------------------------------

/// 点击右侧按钮时显示的pickView列表数据源
@property (nonatomic, strong)NSArray *dataList;

/// 当前数据源dataList选中的index,右侧按钮会显示dataList[dataListIndex]
@property (nonatomic, assign)NSInteger dataListIndex;

@end

@protocol MKFilterByNanoBeaconCellDelegate <NSObject>

/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
- (void)MKFilterByNanoBeaconCellSelected:(NSInteger)index
                           dataListIndex:(NSInteger)dataListIndex;

@end

@interface MKFilterByNanoBeaconCell : MKBaseCell

@property (nonatomic, strong)MKFilterByNanoBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKFilterByNanoBeaconCellDelegate>delegate;

+ (MKFilterByNanoBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
