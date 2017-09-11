//
//  MessageViewController.m
//  VK_API_App
//
//  Created by iStef on 09.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "MessageViewController.h"
#import "ServerManager.h"

@interface MessageViewController ()

@property (strong, nonatomic) NSString *messageText;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.delegate = self;
    [self.view addSubview:textView];
    
    self.navigationItem.title = @"Message";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToWall)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessageToUser)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)backToWall
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendMessageToUser
{
    [[ServerManager sharedManager] sendMessage:self.messageText
                                     onSuccess:^(id result) {
                                         NSLog(@"SENT!");
    }
                                     onFailure:^(NSError *error, NSInteger statusCode) {
                                         NSLog(@"DID NOT SEND!");
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if (textView.text.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.messageText = textView.text;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

@end
