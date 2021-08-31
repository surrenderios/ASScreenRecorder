//
//  MasterViewController.m
//  ExampleRecorder
//
//  Created by Alan Skipp on 23/04/2014.
//  Copyright (c) 2014 Alan Skipp. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "UIViewController+ScreenRecorder.h"

#import "ExampleRecorder-Swift.h"

@interface UIColor (Additions)
+ (UIColor *)randomColor;
@end

@implementation UIColor (Additions)

+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:(arc4random() % 255/255.0f)
                           green:(arc4random() % 255/255.0f)
                            blue:(arc4random() % 255/255.0f)
                           alpha:1.0];
}
@end


@interface MasterViewController ()
{
    NSMutableArray *_colors;
    CIImageView *_imageView;
}
@property(weak) IBOutlet UITableView *tableView;
@property(weak) IBOutlet UIView *imageContainer;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareScreenRecorder];
    
    _colors = [NSMutableArray array];

    for (NSUInteger i=0; i<1000; i++) {
        [_colors addObject:[UIColor randomColor]];
    }
    
    
    
    _imageView = [[CIImageView alloc] initWithFrame:self.imageContainer.bounds];
    [self.imageContainer addSubview:_imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)insertNewObject:(id)sender
{
    [_colors insertObject:[UIColor randomColor] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = _colors[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu",indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_colors removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UIColor *color = _colors[indexPath.row];
        [[segue destinationViewController] setColor:color];
    }
}


#pragma mark -
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [_imageView setFrame:CGRectMake(0, 0, self.imageContainer.bounds.size.width, self.imageContainer.bounds.size.height/2)];
}

- (void)writeFilterImage:(id)image;
{
//    UIImage *cimage = [UIImage imageWithData:image];
//    if (!cimage){
//        NSLog(@"__%s__",__FUNCTION__);
//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_imageView setImage:cimage];
//        });
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_imageView setImage:image];
    });
}
@end
