//
//  UIViewController+MASAdditions.m
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+MASAdditions.h"

#ifdef MAS_VIEW_CONTROLLER

@implementation MAS_VIEW_CONTROLLER (MASAdditions)

- (MASViewAttribute *)mas_topLayoutGuide {
    return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide.topAnchor layoutAttribute:NSLayoutAttributeBottom];
}
- (MASViewAttribute *)mas_topLayoutGuideTop {
    return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide.topAnchor layoutAttribute:NSLayoutAttributeTop];
}
- (MASViewAttribute *)mas_topLayoutGuideBottom {
    return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide.topAnchor layoutAttribute:NSLayoutAttributeBottom];
}

- (MASViewAttribute *)mas_bottomLayoutGuide {
    return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide.bottomAnchor layoutAttribute:NSLayoutAttributeTop];
}
- (MASViewAttribute *)mas_bottomLayoutGuideTop {
    return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide.bottomAnchor layoutAttribute:NSLayoutAttributeTop];
}
- (MASViewAttribute *)mas_bottomLayoutGuideBottom {
    return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide.bottomAnchor layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
