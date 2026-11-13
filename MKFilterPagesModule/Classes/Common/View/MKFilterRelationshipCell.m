//
//  MKFilterRelationshipCell.m
//  MKFilterPagesModule
//
//  Created by aa on 2026/11/13.
//

#import "MKFilterRelationshipCell.h"
#import "Masonry.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

@interface MKFilterRelationshipCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *buttonContainer;

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@end

@implementation MKFilterRelationshipCell

- (void)dealloc {
    NSLog(@"MKFilterRelationshipCell销毁");
}

+ (instancetype)initCellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MKFilterRelationshipCellId";
    MKFilterRelationshipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MKFilterRelationshipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.contentView.backgroundColor = UIColor.whiteColor;

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = DEFAULT_TEXT_COLOR;
    self.titleLabel.font = MKFont(13.f);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
    }];

    self.buttonContainer = [[UIView alloc] init];
    [self.contentView addSubview:self.buttonContainer];
    [self.buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)setDataModel:(MKFilterRelationshipCellModel *)dataModel {
    _dataModel = dataModel;
    self.titleLabel.text = dataModel.msg;

    // 清除旧按钮
    for (UIButton *btn in self.buttons) {
        [btn removeFromSuperview];
    }
    [self.buttons removeAllObjects];

    // 创建新按钮
    CGFloat btnWidth = [self buttonWidthForCount:dataModel.dataList.count];
    CGFloat spacing = 5.f;
    for (NSUInteger i = 0; i < dataModel.dataList.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:dataModel.dataList[i] forState:UIControlStateNormal];
        btn.titleLabel.font = MKFont(12.f);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4.f;
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainer addSubview:btn];
        [self.buttons addObject:btn];

        // button 布局：从左到右
        CGFloat x = i * (btnWidth + spacing);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
            make.width.mas_equalTo(btnWidth);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
    }

    [self updateButtonSelectedState];
}

- (CGFloat)buttonWidthForCount:(NSUInteger)count {
    CGFloat containerWidth = [UIScreen mainScreen].bounds.size.width - 30;
    CGFloat spacing = 5.f;
    return (containerWidth - spacing * (count - 1)) / count;
}

- (void)updateButtonSelectedState {
    for (NSUInteger i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        if (i == self.dataModel.dataListIndex) {
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            btn.backgroundColor = DEFAULT_COLOR;
        } else {
            [btn setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
            btn.backgroundColor = RGBCOLOR(242, 242, 242);
        }
    }
}

- (void)buttonTapped:(UIButton *)sender {
    if (!self.dataModel) return;
    NSUInteger oldIndex = self.dataModel.dataListIndex;
    NSUInteger newIndex = sender.tag;
    if (oldIndex == newIndex) return;

    self.dataModel.dataListIndex = newIndex;
    [self updateButtonSelectedState];

    if (self.delegate && [self.delegate respondsToSelector:@selector(mk_filterRelationshipCell:relationshipChanged:dataListIndex:)]) {
        [self.delegate mk_filterRelationshipCell:self
                               relationshipChanged:self.dataModel.index
                                     dataListIndex:newIndex];
    }
}

@end
