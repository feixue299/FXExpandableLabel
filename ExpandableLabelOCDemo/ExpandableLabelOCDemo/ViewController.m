//
//  ViewController.m
//  ExpandableLabelOCDemo
//
//  Created by 8-PC on 2020/6/11.
//  Copyright © 2020 wu. All rights reserved.
//

#import "ViewController.h"
#import "ExpandableCell.h"

@interface ViewController ()<ExpandableLabelDelegate>

@property (nonatomic, assign) NSInteger numberOfCells;
@property (nonatomic, strong) NSMutableArray *states;

@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSArray *numberOfLines;
@property (nonatomic, strong) NSArray *alignments;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfCells = 12;
    NSMutableArray *arr = @[].mutableCopy;

    for (int i = 0; i < self.numberOfCells; i++) {
        [arr addObject:@(YES)];
    }
    self.states = arr;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.texts = @[[self loremIpsumText], [self textWithNewLinesInCollapsedLine], [self textWithLongWordInCollapsedLine], [self textWithVeryLongWords], [self loremIpsumText], [self loremIpsumText], [self loremIpsumText], [self loremIpsumText], [self loremIpsumText], [self loremIpsumText], [self textWithShortWordsPerLine], [self textEmojis]];
    self.types = @[@(ExpandableLabelTextReplacementTypeWord), @(ExpandableLabelTextReplacementTypeWord), @(ExpandableLabelTextReplacementTypeCharacter), @(ExpandableLabelTextReplacementTypeCharacter), @(ExpandableLabelTextReplacementTypeWord), @(ExpandableLabelTextReplacementTypeCharacter), @(ExpandableLabelTextReplacementTypeWord), @(ExpandableLabelTextReplacementTypeCharacter), @(ExpandableLabelTextReplacementTypeWord), @(ExpandableLabelTextReplacementTypeCharacter), @(ExpandableLabelTextReplacementTypeCharacter), @(ExpandableLabelTextReplacementTypeCharacter)];
    self.numberOfLines = @[@3, @2, @1, @1, @4, @3, @2, @5, @3, @1, @3, @3];
    self.alignments = @[@(NSTextAlignmentLeft), @(NSTextAlignmentCenter), @(NSTextAlignmentRight),
                        @(NSTextAlignmentLeft), @(NSTextAlignmentCenter), @(NSTextAlignmentRight),
                        @(NSTextAlignmentLeft), @(NSTextAlignmentCenter), @(NSTextAlignmentRight),
                        @(NSTextAlignmentLeft), @(NSTextAlignmentCenter), @(NSTextAlignmentRight)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpandableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.delegate = self;

    [cell.label setLessLinkWithLessLink:@"Close" attributes:@{NSForegroundColorAttributeName: UIColor.redColor} position:((NSNumber *)self.alignments[indexPath.row]).integerValue];
    [cell layoutIfNeeded];

    cell.label.shouldCollapse = YES;
    cell.label.textReplacementType = ((NSNumber *)self.types[indexPath.row]).integerValue;
    cell.label.numberOfLines = ((NSNumber *)self.numberOfLines[indexPath.row]).integerValue;
    cell.label.collapsed = ((NSNumber *)self.states[indexPath.row]).boolValue;
    cell.label.text = self.texts[indexPath.row];

    return cell;
}

- (NSString *)loremIpsumText {
    return @"On third line our text need be collapsed because we have ordinary text, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
}

- (NSString *)textWithNewLinesInCollapsedLine {
    return @"When u had new line specialChars \n More not appeared eirmod\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n tempor invidunt ut\n\n\n\n labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
}

- (NSString *)textWithLongWordInCollapsedLine {
    return @"When u had long word which not entered in one line More not appeared FooBaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaR tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
}

- (NSString *)textWithVeryLongWords {
    return @"FooBaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaR FooBaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaR FooBaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaR FooBaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaR Will show first line and will increase touch area for more voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
}

- (NSString *)textWithShortWordsPerLine {
    return @"A\nB\nC\nD\nE\nF\nG\nH\nI\nJ\nK\nL\nM\nN";
}

- (NSString *)textEmojis {
    return @"😂😄😃😊😍😗😜😅😓☺️😶🤦😒😁😟😵🙁🤔🤓☹️🙄😑😫😱🙂😧🤵😶👥👩‍❤️‍👩💖👨‍❤️‍💋‍👨💏👩‍👩‍👦‍👦👦👀👨‍👩‍👧‍👦👩‍❤️‍👩🗨🕴👩‍❤️‍💋‍👩👧☹️😠😤😆💚🙄🤒💋😿👄";
}

#pragma mark ExpandableLabelDelegate
- (void)willExpandLabel:(ExpandableLabel *)label {
    [self.tableView beginUpdates];
}

- (void)didExpandLabel:(ExpandableLabel *)label {
    CGPoint point = [label convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
    if (indexpath) {
        self.states[indexpath.row] = @(NO);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
    [self.tableView endUpdates];
}

- (void)willCollapseLabel:(ExpandableLabel *)label {
    [self.tableView beginUpdates];
}

- (void)didCollapseLabel:(ExpandableLabel *)label {
    CGPoint point = [label convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
    if (indexpath) {
        self.states[indexpath.row] = @(YES);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
    [self.tableView endUpdates];
}

@end
