//
//  UITableView+MTSectionIndexView.h
//  MTApp
//
//  Created by Season on 2020/1/11.
//  Copyright © 2020 hwtech. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (MTSectionIndexView)
@property(nonatomic, strong) NSArray <NSString *> *titles;
@property(nonatomic, strong) UIView *sectionIndexView;
- (void)mt_showSectionIndex:(NSArray <NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
