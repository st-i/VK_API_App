//
//  LoginViewControlle.m
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "LoginViewController.h"
#import "AccessToken.h"
#import "GroupWallViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "ViewController.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation LoginViewController

- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    
    self.navigationItem.title = @"Login";
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    "client_id=6157927&"
    "scope=274438&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "display=mobile&"
    "v=5.68&"
    "revoke=1&"
    "response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    self.webView.delegate = nil;
}

#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound) {
        
        AccessToken* token = [[AccessToken alloc] init];
        
        NSString* query = [[request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [values lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userID = [values lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        
        [[ServerManager sharedManager] authorizeUser:token];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        GroupWallViewController *groupWallVC = [[GroupWallViewController alloc] init];
        UINavigationController *groupNavCon = [[UINavigationController alloc] initWithRootViewController:groupWallVC];
        groupNavCon.tabBarItem.title = @"Wall";
        groupNavCon.tabBarItem.image = [UIImage imageNamed:@"Wall.png"];
        
        ViewController *vc = [[ViewController alloc] init];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
        navCon.tabBarItem.title = @"Friends";
        navCon.tabBarItem.image = [UIImage imageNamed:@"Friends.png"];
        
        UITabBarController *tabBarContr = [[UITabBarController alloc] init];
        tabBarContr.viewControllers = @[groupNavCon, navCon];
        
        [self presentViewController:tabBarContr animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

@end

