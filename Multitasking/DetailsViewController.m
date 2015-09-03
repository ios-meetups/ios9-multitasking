//
// DetailsViewController.m
//
// Copyright (c) 2015 Bogdan Kovachev (http://1337.bg)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "DetailsViewController.h"

@implementation DetailsViewController

#pragma mark - IB Actions

- (IBAction)playButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"Play" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Play"]) {
        // Set audio session if it's not configured
        if (![[[AVAudioSession sharedInstance] category] isEqualToString:AVAudioSessionCategoryPlayback]) {
            NSError *error;

            if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]) {
                NSLog(@"Cannot set the audio session. Error: %@", error.localizedDescription);
            }
        }

        // Get the instance to the AVPlayerViewController
        AVPlayerViewController *playerViewController = segue.destinationViewController;

        // Enable PiP and set the delegate
        playerViewController.allowsPictureInPicturePlayback = YES;
        playerViewController.delegate = self;

        // Get the URL to the video file
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ZdravkoTheBest" ofType:@"mov"];
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];

        // Initialize the player and pass the reference to AVPlayerViewController
        playerViewController.player = [AVPlayer playerWithURL:fileUrl];
    }
}

#pragma mark - AVPlayerViewController delegate

- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler {
    // If the user pause the video in PiP, it should be paused in the AVPlayerViewController too
    BOOL isPaused = playerViewController.player.rate == 0.0f;
    if (isPaused) {
        [playerViewController.player pause];
    }

    // Present the AVPlayerViewController again
    [self presentViewController:playerViewController animated:YES completion:^{
        // Return the completion handler
        completionHandler(YES);
    }];
}

@end