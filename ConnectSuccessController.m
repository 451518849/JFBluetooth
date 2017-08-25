//
//  ConnectSuccessController.m
//  CiBluetooth
//
//  Created by 小发工作室 on 2017/8/18.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "ConnectSuccessController.h"
#import "Masonry.h"

@interface ConnectSuccessController ()

@property (nonatomic, strong) UIImageView *connectSuccessView;

@property (nonatomic, strong) UILabel  *successLabel;

@property (nonatomic, strong) UILabel  *hintLabel;

@property (nonatomic, strong) UIButton *bindBleBtn;

@property (nonatomic, strong) UIButton *closeBtn;


@end


@implementation ConnectSuccessController

- (UIImageView *)connectSuccessView {
    
    if (_connectSuccessView == nil) {
        _connectSuccessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_guide_connected"]];
    }
    return _connectSuccessView;
}

- (UILabel *)successLabel {
    if (_successLabel == nil) {
        _successLabel = [[UILabel alloc] init];
        _successLabel.font = [UIFont systemFontOfSize:20];
        _successLabel.textColor = [UIColor whiteColor];
        _successLabel.text = @"设备连接成功";
    }
    return _successLabel;
}

- (UILabel *)hintLabel {
    if (_hintLabel == nil) {
        
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:13];
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.text = @"请支具师设置传感器参数";
    }
    return _hintLabel;
}

- (UIButton *)bindBleBtn {
    if (_bindBleBtn == nil) {
        _bindBleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_bindBleBtn setBackgroundColor:[UIColor whiteColor]];
        [_bindBleBtn setTitleColor:[UIColor colorWithRed:64/255.0 green:199/255.0 blue:193/255.0 alpha:1]
                          forState:UIControlStateNormal];
        [_bindBleBtn setTitle:@"绑定" forState:UIControlStateNormal];
        
        _bindBleBtn.layer.cornerRadius = 2;
        _bindBleBtn.layer.masksToBounds = YES;
        
    }
    return _bindBleBtn;
}

- (UIButton *)closeBtn {
    
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_guide_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (void)layoutSubviews{
    
    [self.view addSubview:self.connectSuccessView];
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.hintLabel];
    [self.view addSubview:self.bindBleBtn];
    [self.view addSubview:self.closeBtn];

    [self.connectSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.top.equalTo(@80);
    }];
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.connectSuccessView.mas_bottom).mas_offset(10);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.successLabel.mas_bottom).mas_offset(10);
    }];
    
    [self.bindBleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).mas_offset(-30);
        make.left.equalTo(self.view.mas_left).mas_offset(30);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.hintLabel.mas_bottom).mas_offset(40);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.height.width.mas_equalTo(30);
        make.bottom.equalTo(self.view).mas_offset(-30);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:64/255.0 green:199/255.0 blue:193/255.0 alpha:1];
    
    [self layoutSubviews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
