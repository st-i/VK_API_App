//
//  GroupWallViewControlle.m
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "GroupWallViewController.h"
#import "ServerManager.h"
#import "PostCell.h"
#import "UIImageView+AFNetworking.h"

#import "User.h"
#import "Post.h"
#import "WallPostCell.h"
#import "MessageViewController.h"

@interface GroupWallViewController ()

@property (strong, nonatomic) NSMutableArray* postsArray;


@end

static NSInteger postsInRequest = 5;

@implementation GroupWallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"iOS Dev Course";
    
    self.postsArray = [NSMutableArray array];
    
    UIRefreshControl* refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshWall) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"New Post" style:UIBarButtonItemStylePlain target:self action:@selector(postOnWall:)];
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.tabBarItem.title = @"Wall";
    self.tabBarItem.image = [UIImage imageNamed:@"Wall.png"];
    
    [self getPostsFromServer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)sendMessage
{
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:messageVC];
    [self presentViewController:navCon animated:YES completion:nil];
}

#pragma mark - API

- (void) postOnWall:(id) sender
{
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"Запись опубликована" message:@"Вы опубликовали запись \"Новая заметка на стене!\" в сообществе iOS Development Course (vk.com/iosdevcourse)" preferredStyle:UIAlertControllerStyleAlert];
    [alertContr addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertContr animated:YES completion:nil];
    
    
    [[ServerManager sharedManager]
     postText:@"Новая заметка на стене!"
     onGroupWall:@"58860049"
     onSuccess:^(id result) {
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
     }];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshWall];
    });
}

- (void) refreshWall
{
    
    [[ServerManager sharedManager] getWallOfGroup:@"58860049"
                                           offset:0
                                            count:MAX(postsInRequest, [self.postsArray count])
                                        onSuccess:^(NSArray *wallPosts) {
                                            [self.postsArray removeAllObjects];
                                            
                                            for (Post *post in wallPosts) {
                                                
                                                NSString *someID = [NSString stringWithFormat:@"%@", post.ownerID];
                                                
                                                if ([someID hasPrefix:@"-"]) {
                                                    [[ServerManager sharedManager] getGroup:someID
                                                                                  onSuccess:^(Group *group) {
                                                                                      
                                                                                      post.ownerFullName = group.name;
                                                                                      post.ownerPhoto = group.photoURL;
                                                                                      
                                                                                      [self.tableView reloadData];
                                                                                      
                                                                                  } onFailure:^(NSError *error, NSInteger statusCode) {
                                                                                      NSLog(@"NO");
                                                                                  }];
                                                }else{
                                                    [[ServerManager sharedManager] getUser:post.ownerID
                                                                                 onSuccess:^(User *user) {
                                                                                     
                                                                                     post.ownerFullName = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                                                                                     post.ownerPhoto = user.imageURL;
                                                                                     
                                                                                     [self.tableView reloadData];
                                                                                     
                                                                                 } onFailure:^(NSError *error, NSInteger statusCode) {
                                                                                     NSLog(@"NO");
                                                                                 }];
                                                }
                                                [self.postsArray addObject:post];
                                            }
                                            
                                            [self.tableView reloadData];
                                            
                                            [self.refreshControl endRefreshing];
                                            
                                            
                                        } onFailure:^(NSError *error, NSInteger statusCode) {
                                            NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                            
                                            [self.refreshControl endRefreshing];
                                        }];
    
}

- (void) getPostsFromServer
{
    //58860049
    [[ServerManager sharedManager] getWallOfGroup:@"58860049"
                                           offset:self.postsArray.count
                                            count:postsInRequest
                                        onSuccess:^(NSArray *wallObjects) {
                                            
                                            
                                            for (Post *post in wallObjects) {
                                                
                                                NSString *someID = [NSString stringWithFormat:@"%@", post.ownerID];
                                                
                                                if ([someID hasPrefix:@"-"]) {
                                                    [[ServerManager sharedManager] getGroup:someID
                                                                                  onSuccess:^(Group *group) {
                                                                                      
                                                                                      post.ownerFullName = group.name;
                                                                                      post.ownerPhoto = group.photoURL;
                                                                                      
                                                                                      [self.tableView reloadData];
                                                                                      
                                                                                  } onFailure:^(NSError *error, NSInteger statusCode) {
                                                                                      NSLog(@"NO");
                                                                                  }];
                                                }else{
                                                    [[ServerManager sharedManager] getUser:post.ownerID
                                                                                 onSuccess:^(User *user) {
                                                                                     
                                                                                     post.ownerFullName = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                                                                                     post.ownerPhoto = user.imageURL;
                                                                                     
                                                                                     [self.tableView reloadData];
                                                                                     
                                                                                 } onFailure:^(NSError *error, NSInteger statusCode) {
                                                                                     NSLog(@"NO");
                                                                                 }];
                                                }
                                                [self.postsArray addObject:post];
                                            }
                                            
                                        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                        }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.postsArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.postsArray count]) {
        
        static NSString* identifier = @"Cell";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = @"Load more...";
        cell.textLabel.textColor = [UIColor blueColor];
        cell.imageView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        return cell;
        
    } else {
        
        static NSString* identifier = @"cutomCell";
        
        WallPostCell *cell = (WallPostCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WallPostCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Post* post = [self.postsArray objectAtIndex:indexPath.row];
        
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [messageButton addTarget:self
                          action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [messageButton setTitle:@"" forState:UIControlStateNormal];
        messageButton.frame = cell.photoImageView.frame;
        messageButton.center = cell.photoImageView.center;
        [cell.contentView addSubview:messageButton];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:post.ownerPhoto];
        
        __weak WallPostCell* weakCell = cell;
        
        cell.photoImageView.image = nil;
        
        [cell.photoImageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             weakCell.photoImageView.image = image;
             weakCell.photoImageView.layer.cornerRadius = 30;
             [weakCell.photoImageView setClipsToBounds:YES];
             [weakCell layoutSubviews];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
         }];
        
        cell.fullName.text = post.ownerFullName;
        cell.postingDate.text = post.date;
        
        cell.postText.text = post.text;
        cell.postText.numberOfLines = 1000;
        cell.postText.textColor = [UIColor blackColor];
        
        cell.likes.text = [NSString stringWithFormat:@"Likes: %ld", (long)post.likes];
        cell.comments.text = [NSString stringWithFormat:@"Comments: %ld", post.comments];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.postsArray count]) {
        
        return 44.f;
        
    } else {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WallPostCell" owner:self options:nil];
        WallPostCell *cell = [nib objectAtIndex:0];
        
        Post* post = [self.postsArray objectAtIndex:indexPath.row];
        
        UIFont* font = [UIFont systemFontOfSize:17.f];
        
        NSShadow* shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowBlurRadius = 0.5;
        
        NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
        [paragraph setAlignment:NSTextAlignmentLeft];
        
        NSDictionary* attributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
         font, NSFontAttributeName,
         paragraph, NSParagraphStyleAttributeName,
         shadow, NSShadowAttributeName, nil];
        
        CGRect rect = [post.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(cell.postText.frame), CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attributes
                                              context:nil];
        
        return CGRectGetHeight(rect) + 160;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.postsArray count]) {
        [self getPostsFromServer];
    }
    
}

@end
