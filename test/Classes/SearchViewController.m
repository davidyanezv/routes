//
//  SearchViewController.m
//  test
//
//  Created by David Yanez on 8/13/14.
//  Copyright (c) 2014 arctouch. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "SearchViewController.h"
#import "DetailViewController.h"
#import "SessionManager.h"


static NSString *const TableViewCellIdentifier = @"TableViewCellIdentifier";

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *items;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Routes";
    self.searchBar.placeholder = @"Search (Lauro)";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
}

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[SessionManager manager] search:searchBar.text completionHandler:^(id responseObject, NSError *error) {
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
    if (item[@"longName"] && [item[@"longName"] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = item[@"longName"];
    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.items[indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

@end
