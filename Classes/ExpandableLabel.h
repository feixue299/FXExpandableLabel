//
//  ExpandableLabel.h
//  ExpandableLabelOC
//
//  Created by 8-PC on 2020/6/10.
//  Copyright © 2020 wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ExpandableLabel;

@protocol ExpandableLabelDelegate <NSObject>

@optional
- (void)willExpandLabel:(ExpandableLabel *)label;
- (void)didExpandLabel:(ExpandableLabel *)label;
- (void)willCollapseLabel:(ExpandableLabel *)label;
- (void)didCollapseLabel:(ExpandableLabel *)label;

@end

typedef NS_ENUM(NSUInteger, ExpandableLabelTextReplacementType) {
    ExpandableLabelTextReplacementTypeCharacter,
    ExpandableLabelTextReplacementTypeWord,
};

@interface ExpandableLabel : UILabel

@property (nonatomic, weak, nullable) id<ExpandableLabelDelegate> delegate;
/// Set 'true' if the label should be collapsed or 'false' for expanded.
@property (nonatomic, assign) BOOL collapsed;
/// Set 'true' if the label can be expanded or 'false' if not.
/// The default value is 'true'.
@property (nonatomic, assign) BOOL shouldExpand;
/// Set 'true' if the label can be collapsed or 'false' if not.
/// The default value is 'false'.
@property (nonatomic, assign) BOOL shouldCollapse;
/// Set the link name (and attributes) that is shown when collapsed.
/// The default value is "More". Cannot be nil.
@property (nonatomic, copy, nonnull) NSAttributedString *collapsedAttributedLink;
/// Set the link name (and attributes) that is shown when expanded.
/// The default value is "Less". Can be nil.
@property (nonatomic, copy, nullable) NSAttributedString *expandedAttributedLink;
/// Set the ellipsis that appears just after the text and before the link.
/// The default value is "...". Can be nil.
@property (nonatomic, copy, nullable) NSAttributedString *ellipsis;
/// Set a view to animate changes of the label collapsed state with. If this value is nil, no animation occurs.
/// Usually you assign the superview of this label or a UIScrollView in which this label sits.
/// Also don't forget to set the contentMode of this label to top to smoothly reveal the hidden lines.
/// The default value is 'nil'.
@property (nonatomic, strong, nullable) UIView *animationView;
@property (nonatomic, assign) ExpandableLabelTextReplacementType textReplacementType;
@property (nonatomic, readonly) NSAttributedString *expandedText;

- (void)setLessLinkWithLessLink:(NSString *)lessLink attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes position:(NSTextAlignment)position;

@end

NS_ASSUME_NONNULL_END
