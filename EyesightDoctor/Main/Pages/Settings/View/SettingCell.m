//
//  SettingCell.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/22.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell
{
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UILabel *_subTitle;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    _iconView = [[UIImageView alloc] init];
    [self addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = [UIColor colorFromHexString:@"6a6a6a"];
    [self addSubview:_titleLabel];
    
    _subTitle = [[UILabel alloc] init];
    _subTitle.font = [UIFont systemFontOfSize:12];
    _subTitle.textAlignment = NSTextAlignmentRight;
    _subTitle.textColor = [UIColor colorFromHexString:@"30848f"];
    [self addSubview:_subTitle];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconView.frame = CGRectMake(20, (self.height-22)/2.0, 24, 24);
    _titleLabel.frame = CGRectMake(_iconView.right+10, (self.height-22)/2.0, self.width-60, 22);
    _subTitle.frame = CGRectMake(self.width-50-110, (self.height-13)/2.0, 100, 13);
}
- (void)setInfo:(NSDictionary *)info
{
    _info = info;
    FAKIonIcons *icon = [FAKIonIcons iconWithCode:info[@"iconCode"] size:24];
    [icon addAttribute:NSForegroundColorAttributeName value:info[@"tintColor"]];
    _iconView.image = [icon imageWithSize:CGSizeMake(24, 24)];
    _titleLabel.text = info[@"name"];
    if(info[@"subTitle"])_subTitle.text = info[@"subTitle"];
}
@end
