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

@property (nonatomic, weak) id<ExpandableLabelDelegate> delegate;



@end

NS_ASSUME_NONNULL_END
