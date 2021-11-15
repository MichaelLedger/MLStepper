//
//  MLStepper.m
//  MLStepper
//
//  Created by Gavin Xiang on 2021/11/15.
//
//

#import "MLStepper.h"


@interface MLStepper()

@property(nonatomic,copy)UIButton *minusBtn;
@property(nonatomic,copy)UIButton *plusBtn;
@property(nonatomic,copy)UITextField *valueTF;

@end

@implementation MLStepper

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self initData];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
        [self initData];
    }
    return self;
}

-(void)initData{
    self.isValueEditable = true;
    self.stepValue = 1;
    self.minValue = 0;
    self.maxValue = 99;
    self.value = _minValue;
}

-(void)setupUI{
    self.translatesAutoresizingMaskIntoConstraints = false;

    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10.f;
    self.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    
    [self addSubview: self.minusBtn];
    [self addSubview: self.plusBtn];
    [self addSubview: self.valueTF];
    
    [self setupLayout];
}

-(void)setupLayout{
    NSDictionary *views = NSDictionaryOfVariableBindings(_minusBtn, _plusBtn, _valueTF);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_minusBtn][_valueTF(_minusBtn)][_plusBtn(_minusBtn)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_minusBtn]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_plusBtn]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_valueTF]|" options:0 metrics:nil views:views]];
}

#pragma mark - action
-(void)actionForButtonClicked: (UIButton*)sender{
    if ([sender isEqual:_minusBtn]) {
        self.value = _value - _stepValue;
    }
    else if([sender isEqual:_plusBtn]){
        self.value = _value + _stepValue;
    }
}

-(void)actionForTextFieldValueChanged: (UITextField*)sender{
    if ([sender isEqual:_valueTF]) {
        self.value = [sender.text doubleValue];
    }
}


#pragma mark - setters
-(void)setValue:(double)value{
    if (value < _minValue) {
        value = _minValue;
    }
    else if (value > _maxValue){
        value = _maxValue;
    }
    
    _minusBtn.enabled = value > _minValue;
    _plusBtn.enabled = value < _maxValue;
    _valueTF.text = [NSString stringWithFormat:@"%.0f",value];
        
    _value = value;
    
    _valueChanged ? _valueChanged(_value) : nil;
}

-(void)setMaxValue:(double)maxValue{
    _maxValue = maxValue < _minValue ? _minValue : maxValue;
}

-(void)setMinValue:(double)minValue{
    _minValue = minValue > _maxValue ? _maxValue : minValue;
}

-(void)setIsValueEditable:(BOOL)isValueEditable{
    _isValueEditable = isValueEditable;
    _valueTF.enabled = _isValueEditable;
}

#pragma mark - private
-(UIButton*)actionButtonWithTitle: (NSString*)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    btn.tintColor = [UIColor darkTextColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:24];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionForButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UIButton*)actionButtonWithNormalImage:(NSString*)normalImage disableImage:(NSString *)disableImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(actionForButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - getters
-(UITextField *)valueTF{
    if (!_valueTF) {
        UITextField *tf = [UITextField new];
        tf.font = [UIFont systemFontOfSize:16];
        [tf addTarget:self action:@selector(actionForTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        tf.borderStyle = UITextBorderStyleNone;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textAlignment = NSTextAlignmentCenter;
        tf.translatesAutoresizingMaskIntoConstraints = false;
        tf.text = [NSString stringWithFormat:@"%.0f",self.value];
        tf.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
        tf.layer.borderWidth = 1.f;
        _valueTF = tf;
    }
    return _valueTF;
}

-(UIButton *)minusBtn{
    if (!_minusBtn) {
//        UIButton *btn = [self actionButtonWithTitle:@"-"];
        UIButton *btn = [self actionButtonWithNormalImage:@"stepper-minus" disableImage:@"stepper-minus-gray"];
        btn.translatesAutoresizingMaskIntoConstraints = false;

        _minusBtn = btn;
    }
    return _minusBtn;
}

-(UIButton *)plusBtn{
    if (!_plusBtn) {
//        UIButton *btn = [self actionButtonWithTitle:@"+"];
        UIButton *btn = [self actionButtonWithNormalImage:@"stepper-plus" disableImage:@"stepper-plus-gray"];
        btn.translatesAutoresizingMaskIntoConstraints = false;

        _plusBtn = btn;
    }
    return _plusBtn;
}

@end
