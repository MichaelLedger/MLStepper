//
//  MLStepper.h
//  MLStepper
//
//  Created by Gavin Xiang on 2021/11/15.
//
//

#import <UIKit/UIKit.h>

typedef void(^HYStepperCallback)(double value);

@interface MLStepper : UIView

@property(nonatomic)BOOL isValueEditable;
@property(nonatomic)double minValue;
@property(nonatomic)double maxValue;
@property(nonatomic)double value;
@property(nonatomic)double stepValue;

@property(nonatomic,copy)HYStepperCallback valueChanged;

@end
