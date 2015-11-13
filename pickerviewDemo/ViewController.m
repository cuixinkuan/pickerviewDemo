//
//  ViewController.m
//  pickerviewDemo
//
//  Created by admin on 15/11/13.
//  Copyright © 2015年 CXK. All rights reserved.
//

#import "ViewController.h"
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITextField * _textfield;
    UIPickerView * _pickerview;
    NSMutableArray * _dataArr;
    
    NSInteger _selectedrowleft;
    NSInteger _selectedrowright;
    
}
@property (nonatomic,strong)UILabel * state;
@property (nonatomic,strong)UILabel * city;


@end



@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor colorWithRed:236/255.0f green:235/255.0f blue:242/255.0f alpha:1]];
    [self initData];
    [self createPickerview];
}

- (void)initData {
    _dataArr = [[NSMutableArray alloc] init];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray * statenamearr = [NSArray arrayWithContentsOfFile:path];
    [_dataArr addObjectsFromArray:statenamearr];
}

- (void)createPickerview {
    _pickerview =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 200)];
    _pickerview.dataSource = self;
    _pickerview.delegate = self;
    [_pickerview setBackgroundColor: [UIColor whiteColor]];
    _textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH - 20, 30)];
    _textfield.placeholder = @"请输入相关省份或地区";
    _textfield.borderStyle = UITextBorderStyleRoundedRect;
    _textfield.inputView = _pickerview;
    [self.view addSubview:_textfield];
    
    UIView * blueview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    blueview.backgroundColor = [UIColor colorWithRed:73/255.0f green:146/255.0f blue:236/255.0f alpha:1];
    _textfield.inputAccessoryView = blueview;
    
    UIButton * cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(0, 15, 80, 30);
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbutton setBackgroundColor:[UIColor clearColor]];
    [cancelbutton addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
    cancelbutton.tag = 201;
    [blueview addSubview:cancelbutton];
    
    UIButton * surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    surebutton.frame = CGRectMake(SCREEN_WIDTH - 80, 15, 80, 30);
    [surebutton setTitle:@"确定" forState:UIControlStateNormal];
    [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [surebutton setBackgroundColor:[UIColor clearColor]];
    [surebutton addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
    surebutton.tag = 202;
    [blueview addSubview:surebutton];
    
    UILabel * _promptlabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 140)/2, 15, 140, 30)];
    _promptlabel.backgroundColor = [UIColor clearColor];
    _promptlabel.text = @"选择所在地区";
    _promptlabel.textColor = [UIColor whiteColor];
    _promptlabel.textAlignment = NSTextAlignmentCenter;
    _promptlabel.font = [UIFont systemFontOfSize:18.0f];
    [blueview addSubview:_promptlabel];
    
    self.state = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, (SCREEN_WIDTH - 30)/2, 30)];
    self.state.backgroundColor = [UIColor whiteColor];
    self.state.text = @"省份:";
    self.state.textColor = [UIColor blackColor];
    [self.view addSubview:self.state];
    self.city = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30)/2 + 20, 100, (SCREEN_WIDTH - 30)/2, 30)];
    self.city.backgroundColor = [UIColor whiteColor];
    self.city.text = @"省份:";
    self.city.textColor = [UIColor blackColor];
    [self.view addSubview:self.city];
}

- (void)butclick:(UIButton *)sender {
    [_textfield resignFirstResponder];
    switch (sender.tag) {
        case 201:
        {
            NSLog(@"------->执行取消按钮点击事件！");
        }
            break;
        case 202:
        {
            NSLog(@"------->执行确定按钮点击事件！");
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate - 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0 ) {
        return [_dataArr count];
    }else {
        return [[_dataArr[_selectedrowleft] objectForKey:@"Cities"] count];
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0 ) {
        return _dataArr[row][@"State"];
    }else if (component == 1 ) {
        return _dataArr[_selectedrowleft][@"Cities"][row][@"city"];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 ) {
        _selectedrowleft = row;
        [_pickerview reloadComponent:1];
        self.state.text = _dataArr[row][@"State"];
    }else if (component == 1 ) {
        _selectedrowright = row;
    }
    
    if ([_dataArr[_selectedrowleft][@"Cities"] count] <= _selectedrowright) {
        self.city.text = [_dataArr[_selectedrowleft][@"Cities"]lastObject][@"city"];
        _selectedrowright = [_dataArr[_selectedrowleft][@"Cities"] count] - 1;
    }else {
        self.city.text = _dataArr[_selectedrowleft][@"Cities"][_selectedrowright][@"city"];
    }
}

//自定义显示的字体大小以及样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * pickerlabel = (UILabel *)view;
    if (!pickerlabel) {
        pickerlabel = [[UILabel alloc] init];
        pickerlabel.adjustsFontSizeToFitWidth = YES;
        pickerlabel.backgroundColor = [UIColor whiteColor];
        pickerlabel.textColor = [UIColor colorWithRed:14/255.0f green:40/255.0f blue:68/255.0f alpha:1];
        pickerlabel.textAlignment = NSTextAlignmentCenter;
        pickerlabel.font = [UIFont systemFontOfSize:18.0f];
        
        
    }
    pickerlabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerlabel;
}






























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
