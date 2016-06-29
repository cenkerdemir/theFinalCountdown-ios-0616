//
//  FISViewController.m
//  theFinalCountdown
//
//  Created by Joe Burgess on 7/9/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak,nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval countDownInterval;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic) NSTimeInterval pausedInterval;
@property (nonatomic) BOOL pausedTapped;

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timerLabel.hidden = YES;
    self.pauseButton.enabled = NO;
    self.pausedTapped = NO;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTapped:(id)sender {
    self.datePicker.hidden = YES;
    self.timerLabel.hidden = NO;
    self.pauseButton.enabled = YES;
    
    if ([self.startButton.titleLabel.text isEqualToString:@"Cancel"]) {
        [self.timer invalidate];
        self.countDownInterval = 0;
        self.pausedTapped = NO;
        self.timerLabel.hidden = YES;
        self.datePicker.hidden = NO;
        self.pauseButton.enabled = NO;
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    else {
        [self.startButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    
    if (self.pausedTapped == NO) {
        self.countDownInterval = self.datePicker.countDownDuration;
    }
    else {
        self.countDownInterval = self.pausedInterval;
        self.pausedTapped = NO;
    }
    self.timerLabel.text = [NSString stringWithFormat:@"%@", [self secondsToHoursAndMinutes:self.countDownInterval]];
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshSeconds) userInfo:nil repeats:YES];
    }
}

- (void)refreshSeconds {
    self.countDownInterval -= 1;
    if (self.countDownInterval > 0) {
        self.timerLabel.text = [NSString stringWithFormat:@"%@", [self secondsToHoursAndMinutes:self.countDownInterval]];
    }
    else if (self.countDownInterval == 0) {
        [self.timer invalidate];
        self.countDownInterval = 0;
        self.pausedTapped = NO;
        self.timerLabel.hidden = YES;
        self.datePicker.hidden = NO;
        self.pauseButton.enabled = NO;
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        NSLog(@"count ended!");
    }
}

- (IBAction)PauseTapped:(id)sender {
    self.pausedInterval = self.countDownInterval;
    self.pauseButton.enabled = NO;
    self.pausedTapped = YES;
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.timer invalidate];
}

-(NSString *)secondsToHoursAndMinutes:(NSTimeInterval)seconds {
    NSString *formattedTime = @"";
    NSInteger hour = seconds/3600;
    NSInteger minute = (seconds-(3600*hour))/60;
    NSInteger second = (NSInteger)seconds % 60;
    NSString *formattedHour = @"";
    NSString *formattedMin = @"";
    NSString *formattedSec = @"";
    
    if (hour < 10) {
        formattedHour = [formattedHour stringByAppendingString:[NSString stringWithFormat:@"0%li", hour]];
    }
    else {
        formattedHour = [formattedHour stringByAppendingString:[NSString stringWithFormat:@"%li", hour]];
    }
    
    if (minute <10) {
        formattedMin = [formattedMin stringByAppendingString:[NSString stringWithFormat:@"0%li", minute]];
    }
    else {
        formattedMin = [formattedMin stringByAppendingString:[NSString stringWithFormat:@"%li", minute]];
    }
    
    
    if (second < 10) {
        formattedSec = [formattedSec stringByAppendingString:[NSString stringWithFormat:@"0%li", second]];
    }
    else {
        formattedSec = [formattedSec stringByAppendingString:[NSString stringWithFormat:@"%li", second]];
    }
    
    formattedTime = [NSString stringWithFormat:@"%@:%@:%@", formattedHour,formattedMin,formattedSec];
    return formattedTime;
}


@end
