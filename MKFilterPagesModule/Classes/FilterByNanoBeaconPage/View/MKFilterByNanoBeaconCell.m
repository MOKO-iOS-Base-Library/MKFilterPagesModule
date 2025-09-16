//
//  MKFilterByNanoBeaconCell.m
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/9/16.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKFilterByNanoBeaconCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKPickerView.h"

static CGFloat const offset_X = 15.f;
static CGFloat const selectButtonWidth = 130.f;
static CGFloat const selectButtonHeight = 30.f;

@implementation MKFilterByNanoBeaconCellModel
@end

@interface MKFilterByNanoBeaconCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *selectedButton;

@end

@implementation MKFilterByNanoBeaconCell

+ (MKFilterByNanoBeaconCell *)initCellWithTableView:(UITableView *)tableView {
    MKFilterByNanoBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKFilterByNanoBeaconCellIdenty"];
    if (!cell) {
        cell = [[MKFilterByNanoBeaconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKFilterByNanoBeaconCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.selectedButton];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.selectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(selectButtonHeight);
    }];
}

#pragma mark - event method
- (void)selectedButtonPressed {
    //隐藏其他cell里面的输入框键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
    if (!ValidArray(self.dataModel.dataList)) {
        return;
    }
    NSInteger row = 0;
    for (NSInteger i = 0; i < self.dataModel.dataList.count; i ++) {
        if ([self.selectedButton.titleLabel.text isEqualToString:self.dataModel.dataList[i]]) {
            row = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.dataModel.dataList selectedRow:row block:^(NSInteger currentRow) {
        [self.selectedButton setTitle:self.dataModel.dataList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(MKFilterByNanoBeaconCellSelected:dataListIndex:)]) {
            [self.delegate MKFilterByNanoBeaconCellSelected:self.dataModel.index dataListIndex:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKFilterByNanoBeaconCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKFilterByNanoBeaconCellModel.class] || _dataModel.dataListIndex >= _dataModel.dataList.count) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    [self.selectedButton setTitle:_dataModel.dataList[_dataModel.dataListIndex] forState:UIControlStateNormal];
    
    [self.selectedButton setBackgroundColor:NAVBAR_COLOR_MACROS];
    [self.selectedButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton.titleLabel setFont:MKFont(15.f)];
        [_selectedButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_selectedButton setBackgroundColor:NAVBAR_COLOR_MACROS];
        [_selectedButton.layer setMasksToBounds:YES];
        [_selectedButton.layer setCornerRadius:6.f];
        [_selectedButton addTarget:self
                            action:@selector(selectedButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

@end
