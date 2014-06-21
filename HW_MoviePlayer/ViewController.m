//
//  ViewController.m
//  HW_MoviePlayer
//
//  Created by Alexander on 10.05.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
@import MediaPlayer;

@interface ViewController ()
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;
@property(nonatomic) BOOL pressed;
@property(nonatomic,weak) NSTimer *playTimer;
@property(nonatomic) CGFloat totalTime,currenTime,timeTillEnd;
@end

@implementation ViewController
@synthesize moviePlayer, slider, totalTimeLabel, currentTimeLabel, playPauseButton,playTimer,totalTime,currenTime,timeTillEnd,pressed;

- (void)viewDidLoad
{
    [super viewDidLoad];
    pressed = NO;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.view.frame = self.view.bounds;
    moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [moviePlayer play];
   
    
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(updatePlaybackTime:)
                                   userInfo:nil
                                    repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(totalTime:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
 
    
}


-(IBAction)pause{
    
    if (pressed){
        pressed = NO;
        [moviePlayer play];
        [playPauseButton setImage: [UIImage imageNamed:@"play@2x.png"]forState:UIControlStateNormal];
    }
    else {
        pressed = YES;
        [moviePlayer pause];
        [playPauseButton setImage: [UIImage imageNamed:@"pause@2x.png"]forState:UIControlStateNormal];
    }
}
-(void)totalTime:(NSTimer *)theTimer{
    totalTime = self.moviePlayer.playableDuration;
    int time = (int)totalTime;
    if (time%60<10){
         [totalTimeLabel setText:[NSString stringWithFormat:@"%d:0%d",time/60,time%60]];
    }
    else{
         [totalTimeLabel setText:[NSString stringWithFormat:@"%d:%d",time/60,time%60]];
    }
   
}
- (void)updatePlaybackTime:(NSTimer*)theTimer {
    currenTime = self.moviePlayer.currentPlaybackTime;
    int current = (int)currenTime;
    timeTillEnd = totalTime - currenTime;
    int timeLeft = (int)timeTillEnd;
    if (current%60<10){
   [ currentTimeLabel setText:[NSString stringWithFormat:@"%d:0%d/%d:%d",current/60,current%60,timeLeft/60,timeLeft%60]];
        [slider setValue:currenTime/totalTime animated:YES];
    
    }
    else {
       [ currentTimeLabel setText:[NSString stringWithFormat:@"%d:%d/%d:%d",current/60,current%60,timeLeft/60,timeLeft%60]];
        [slider setValue:currenTime/totalTime animated:YES];
    }
    
   
}

- (IBAction)sliderChanged:(id)sender {
    [moviePlayer setCurrentPlaybackTime:slider.value*totalTime];
    
}





@end
