/*
 * Copyright (c) 2015 Adobe Systems Incorporated. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#import <AdobeCreativeSDKCore/AdobeCreativeSDKCore.h>

#import "ViewController.h"

#warning Please update the ClientId and Secret to the values provided by creativesdk.com or from Adobe
static NSString * const kCreativeSDKClientId = @"Change me";
static NSString * const kCreativeSDKClientSecret = @"Change me";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[AdobeUXAuthManager sharedManager] setAuthenticationParametersWithClientID:kCreativeSDKClientId
                                                                   clientSecret:kCreativeSDKClientSecret
                                                                   enableSignUp:NO];
    
    if ([AdobeUXAuthManager sharedManager].isAuthenticated)
    {
        NSLog(@"The user has already been authenticated.");
        
        self.userNameLabel.text = [AdobeUXAuthManager sharedManager].userProfile.displayName;
        self.emailLabel.text = [AdobeUXAuthManager sharedManager].userProfile.email;
        
        [self.loginButton setTitle:@"Log Out" forState:UIControlStateNormal];
    }
}

- (IBAction)loginButtonTouchUpInside
{
    if ([AdobeUXAuthManager sharedManager].isAuthenticated)
    {
        [[AdobeUXAuthManager sharedManager] logout:^{
          
            NSLog(@"User was successfully logged out.");
            
            self.userNameLabel.text = @"<Not Logged In>";
            self.emailLabel.text = @"<Not Logged In>";
            
            [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
            
        } onError:^(NSError *error) {
            
            NSLog(@"There was a problem logging out: %@", error);
        }];
    }
    else
    {
        [[AdobeUXAuthManager sharedManager] login:self onSuccess:^(AdobeAuthUserProfile *profile) {
            
            NSLog(@"Successfully logged in. User profile: %@", profile);
            
            self.userNameLabel.text = [AdobeUXAuthManager sharedManager].userProfile.displayName;
            self.emailLabel.text = [AdobeUXAuthManager sharedManager].userProfile.email;
            
            [self.loginButton setTitle:@"Log Out" forState:UIControlStateNormal];
            
        } onError:^(NSError *error) {
           
            NSLog(@"There was a problem logging in: %@", error);
        }];
    }
}

@end
