//
//  MKFilterRelationshipCell.h
//  MKFilterPagesModule
//
//  Created by aa on 2026/11/13.
//  通用的 filter 关系/枚举选择 cell，所有业务模块 BleFixController 里用的自定义 FilterRelationshipCell 统一到这个
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterRelationshipCellModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<NSString *> *dataList;

@property (nonatomic, assign) NSInteger dataListIndex;

/// 对应 relationship 配置项的唯一 index（用于 Protocol 回调分发）
@property (nonatomic, assign) NSInteger index;

@end

@protocol MKFilterRelationshipCellDelegate <NSObject>

/// 某个 relationship cell 的选中项发生变化
/// @param cell 当前变化的 cell
/// @param index cell 自身的 index（MKFilterRelationshipCellModel.index，由业务模块定义）
/// @param dataListIndex 新选中项在 dataList 里的 index
- (void)mk_filterRelationshipCell:(MKFilterRelationshipCell *)cell
            relationshipChanged:(NSInteger)index
                   dataListIndex:(NSInteger)dataListIndex;

@end

@interface MKFilterRelationshipCell : MKBaseCell

@property (nonatomic, strong) MKFilterRelationshipCellModel *dataModel;

@property (nonatomic, weak) id<MKFilterRelationshipCellDelegate> delegate;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
