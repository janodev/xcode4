
//  Created by ___FULLUSERNAME___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

@synthesize tableView, recipes;


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recipes count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
    }
	
	cell.textLabel.text = [recipes objectAtIndex:[indexPath row]];
	
    return cell;
}


# pragma mark - UIViewController


- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
	[[self.tableView layer] setNeedsDisplay];
	[super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	recipes = [NSArray arrayWithObjects:@"Ranch Burgers", @"Jack-O-Lantern Burgers", @"Inwood Hamburgers", nil];
	[recipes retain];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
	self.recipes = nil;
}


# pragma mark -
# pragma mark NSObject


- (void)dealloc {
    [super dealloc];
}


@end
