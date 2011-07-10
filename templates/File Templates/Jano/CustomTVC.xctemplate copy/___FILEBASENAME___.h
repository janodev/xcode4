
//  Created by ___FULLUSERNAME___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.

#import <UIKit/UIKit.h>

/**
 * Custom table view controller.
 */
@interface ___FILEBASENAME___ : UIViewController {
    NSArray *recipes;
	UITableView *tableView;
}

@property (nonatomic, retain) NSArray *recipes;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end


#warning readme
// To add this class to a project add a UIViewController and UITableView objects to the xib
// and link their ivars tableView, view, datasource, and delegate to each other.
