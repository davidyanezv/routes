//
//  DetailViewController.m
//  test
//
//  Created by David Yanez on 8/14/14.
//  Copyright (c) 2014 arctouch. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "DetailViewController.h"
#import "DepartureViewController.h"
#import "SessionManager.h"

static NSString *const TableViewCellIdentifier = @"TableViewCellIdentifier";

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *items;

@end

@implementation DetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[SessionManager manager] stopDetails:self.item[@"id"] completionHandler:^(id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            if (error) {
                [[[UIAlertView alloc] initWithTitle:@"Unable to search. please try again!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                return;
            }
            
            if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
                self.items = responseObject;
                if (self.items.count == 0) {
                    [[[UIAlertView alloc] initWithTitle:@"Results not found" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                }
                [self.tableView reloadData];
            }
        });
    }];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.items[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (item[@"name"] && [item[@"name"] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = item[@"name"];
    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.items[indexPath.row];
    DepartureViewController *vc = [[DepartureViewController alloc] init];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
