//
//  UITableView+MTSectionIndexView.m
//  MTApp
//
//  Created by Season on 2020/1/11.
//  Copyright © 2020 hwtech. All rights reserved.
//

#import "UITableView+MTSectionIndexView.h"

static const char sectionTitlesKey;
static const char sectionIndexViewKey;
static const char lastIndexKey;

@implementation UITableView (MTSectionIndexView)

- (void)mt_showSectionIndex:(NSArray<NSString *> *)titles {
    
    self.titles = titles;
    objc_setAssociatedObject(self, &lastIndexKey, @(99), OBJC_ASSOCIATION_ASSIGN);
    if (!self.sectionIndexView) {
        self.sectionIndexView = [[UIView alloc] init];
        [self.sectionIndexView setBackgroundColor:[UIColor clearColor]];
        [self setShowsVerticalScrollIndicator:NO];
        [self.superview addSubview:self.sectionIndexView];
        [self.sectionIndexView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSection:)]];
        [self.sectionIndexView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSection:)]];
        [self.sectionIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(55);
        }];
        
        UILabel *lastLabel;
        for (int i = 0; i < self.titles.count; i++) {
            
            UILabel *textLabel = [UILabel labelText:[NSString stringWithFormat:@"      %@",self.titles[i]] withFont:[UIFont font10Name:FontNameHelveticaRegular] withColor:[UIColor mt_titleGrayColor]];
            textLabel.textAlignment = NSTextAlignmentCenter;
            [self.sectionIndexView addSubview:textLabel];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.sectionIndexView);
                make.height.mas_equalTo(KMargin25);
                i == 0 ? make.top.mas_equalTo(20) : make.top.equalTo(lastLabel.mas_bottom).offset(0);
                if (i == self.titles.count-1) {
                    make.bottom.mas_equalTo(-20);
                }
            }];
            lastLabel = textLabel;
        }
    }
}

- (void)panSection:(UIPanGestureRecognizer *)pan {
    
    CGPoint point = [pan locationInView:pan.view];
    if(!CGRectContainsPoint(self.sectionIndexView.bounds, point)) {
        return;
    }
    NSInteger lastIndex = [objc_getAssociatedObject(self, &lastIndexKey) integerValue];
    NSInteger currentIndex =((int)point.y-20-1) / KMargin25;
    if (currentIndex != lastIndex) {
        [self scrollAtIndex:currentIndex];
        objc_setAssociatedObject(self, &lastIndexKey, @(currentIndex), OBJC_ASSOCIATION_ASSIGN);
    }
}

- (void)touchSection:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:tap.view];
    if(!CGRectContainsPoint(self.sectionIndexView.bounds, point)) {
        return;
    }
    NSInteger index =((int)point.y-20-1) / KMargin25;
    [self scrollAtIndex:index];
}

- (void)scrollAtIndex:(NSInteger)index {
    if (self.numberOfSections <= index) {
        return;
    }
  
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGenertor impactOccurred];
    } 
    
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    objc_setAssociatedObject(self, &sectionTitlesKey, titles, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<NSString *> *)titles {
    return objc_getAssociatedObject(self, &sectionTitlesKey);
}

- (void)setSectionIndexView:(UIView *)view {
    objc_setAssociatedObject(self, &sectionIndexViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sectionIndexView {
   return objc_getAssociatedObject(self, &sectionIndexViewKey);
}


@end
