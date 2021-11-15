//
//  ViewController.m
//  MLStepper
//
//  Created by Gavin Xiang on 2021/11/15.
//

#import "ViewController.h"
#import "MLStepper.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MLStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *stepperValueLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _stepperValueLabel.text = [NSString stringWithFormat:@"%.f", _stepper.value];
    __weak __typeof(self) weakSelf = self;
    _stepper.valueChanged = ^(double value) {
        weakSelf.stepperValueLabel.text = [NSString stringWithFormat:@"%.f", value];
    };

    MLStepper *customStepper = [[MLStepper alloc] init];
    [self.view addSubview:customStepper];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:customStepper attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:180]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:customStepper attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:customStepper attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:customStepper attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.stepper attribute:NSLayoutAttributeBottom multiplier:1 constant:30]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 13.0, *)) {
        __block UIWindowScene *activeWindowScene;
        [UIApplication.sharedApplication.connectedScenes enumerateObjectsUsingBlock:^(UIScene * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIWindowScene class]] && obj.activationState == UISceneActivationStateForegroundActive) {
                activeWindowScene = (UIWindowScene *)obj;
                *stop = YES;
            }
        }];
        __block UIWindow *keyWindow;
        [activeWindowScene.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKeyWindow]) {
                keyWindow = obj;
                *stop = YES;
            }
        }];
        if (keyWindow) {
            [keyWindow endEditing:YES];
        }
    } else {
        // Fallback on earlier versions
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [UIApplication.sharedApplication.keyWindow endEditing:true];
#pragma clang diagnostic pop
    }
}

@end
