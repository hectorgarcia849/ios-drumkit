//
//  ViewController.m
//  drumkit
//
//  Created by Hector Garcia on 2017-01-15.
//  Copyright © 2017 Hector Garcia. All rights reserved.
//

#import "ViewController.h"
@import AudioToolbox;
@import AVFoundation.AVAudioPlayer;


@interface ViewController ()
@property (strong, nonatomic) NSDictionary *soundUrls;
@property (strong, nonatomic) NSMutableDictionary *soundIDs;
@property (assign, nonatomic) BOOL soundLoaded;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (assign, nonatomic) BOOL songLoaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *soundNames = @[@"BD1",@"BD2",@"HHCLS",@"HHOPEN",@"PERC",@"SNARE",@"TOM H", @"TOM M"];
                           
    NSString *type = @"wav";
    NSMutableArray *soundPathArray = [[NSMutableArray alloc] init];
    
    for (NSString *s in soundNames) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:s ofType:type];
        NSURL *url = [NSURL fileURLWithPath:soundPath];
        [soundPathArray addObject:url];
    }
    
    self.soundUrls = [[NSDictionary alloc] initWithObjects:soundPathArray forKeys:soundNames];
    self.soundIDs = [[NSMutableDictionary alloc] init];
    
    
    for(NSString *s in soundNames) {
        SystemSoundID soundID;
        OSStatus statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)self.soundUrls[s],  &soundID);
        if(statusReport == kAudioServicesNoError) {
            self.soundLoaded = YES;
            NSNumber *soundIDobject = [[NSNumber alloc] initWithInt:soundID];
            [self.soundIDs setObject:soundIDobject forKey:s];
        } else {
            self.soundLoaded = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn't load sound" message:@"Loading Problem" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController: alert animated: YES completion: nil];
        }
    }
    
    NSString *songPath = [[NSBundle mainBundle] pathForResource:@"suburbs" ofType: @"wav"];
    NSURL *songURL = [NSURL fileURLWithPath:songPath];
    
    NSError *err;
    //setup  AVAudioPlayer
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL: songURL error: &err];
    
    //
    if(!self.player) {
        self.songLoaded = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn't load Song" message:@"Song Problem" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController: alert animated: YES completion: nil];
    } else {
        self.songLoaded = YES;
    }

    
    
    
}



- (IBAction)bd1Tapped:(id)sender {
    if(self.soundLoaded) {
        //to retreive the wrapped unsigned int in SystemSoundID, it must be wrapped by an object, NSNumer, to retreive this value (which is a reference to opaque reference data) must use the intValue method.
            AudioServicesPlaySystemSound([self.soundIDs[@"BD1"] intValue]);
    }
}
- (IBAction)bd2Tapped:(id)sender {
    if(self.soundLoaded) {
        AudioServicesPlaySystemSound([self.soundIDs[@"BD2"] intValue]);
    }
}
- (IBAction)hhclsTapped:(id)sender {
    if(self.soundLoaded) {
        AudioServicesPlaySystemSound([self.soundIDs[@"HHCLS"] intValue]);
    }
}
- (IBAction)hhopenTapped:(id)sender {
    if(self.soundLoaded) {
        AudioServicesPlaySystemSound([self.soundIDs[@"HHOPEN"] intValue]);
    }
}
- (IBAction)snareTapped:(id)sender {
    if(self.soundLoaded) {
        AudioServicesPlaySystemSound([self.soundIDs[@"SNARE"] intValue]);
    }
}
- (IBAction)percTapped:(id)sender {
    if(self.soundLoaded) {
        AudioServicesPlaySystemSound([self.soundIDs[@"PERC"] intValue]);
    }
}
- (IBAction)tomhTapped:(id)sender {
    if(self.soundLoaded) {
        AudioServicesPlaySystemSound([self.soundIDs[@"TOM H"] intValue]);
    }
}
- (IBAction)tommTapped:(id)sender {
    if(self.soundLoaded) {
        AudioServicesPlaySystemSound([self.soundIDs[@"TOM M"] intValue]);
    }
}
- (IBAction)playTapped:(id)sender {
    if(self.songLoaded) {
        [self.player play];
    }
    
}
- (IBAction)stopTapped:(id)sender {
    if(self.songLoaded) {
        [self.player stop];
    }
}

@end
