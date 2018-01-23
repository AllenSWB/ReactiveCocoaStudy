//
//  ListTableViewCell.m
//  RACDemo
//
//  Created by idol on 2018/1/22.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "ListTableViewCell.h"
@interface ListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconimageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *auther;
@property (weak, nonatomic) IBOutlet UILabel *summary;

@end

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BookModelSub *)model {
    _model = model;
    
    self.iconimageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.image]]];
    self.title.text = model.subtitle;
    self.summary.text = model.summary;

    self.auther.text = (NSString *)[model.author.rac_sequence foldLeftWithStart:@"" reduce:^id(NSString* accumulator, NSString * value) {
        return [NSString stringWithFormat:@"%@ %@",accumulator,value];
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
