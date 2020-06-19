//
//  ExpandableLabel.m
//  ExpandableLabelOC
//
//  Created by 8-PC on 2020/6/10.
//  Copyright © 2020 wu. All rights reserved.
//

#import "ExpandableLabel.h"
#import <CoreText/CoreText.h>

@interface ExpandableLabel ()

@property (nonatomic, copy, nullable) NSAttributedString *collapsedText;
@property (nonatomic, assign) BOOL linkHighlighted;
@property (nonatomic, assign) CGSize touchSize;
@property (nonatomic, assign) CGRect linkRect;
@property (nonatomic, assign) NSInteger collapsedNumberOfLines;
@property (nonatomic, assign) NSTextAlignment expandedLinkPosition;
@property (nonatomic, assign) NSRange collapsedLinkTextRange;
@property (nonatomic, assign) NSRange expandedLinkTextRange;
@property (nonatomic, copy) NSAttributedString *expandedText;

@end

@interface NSAttributedString (Explandable)
- (NSAttributedString *)copyWithAddedFontAttributeWithFont:(UIFont *)font;
- (NSAttributedString *)copyWithParagraphAttributeWithFont:(UIFont *)font;
- (NSAttributedString *)textForLineRef:(CTLineRef)lineRef;
- (CGRect)boundingRectForWidth:(CGFloat)width;
- (NSArray *)linesWithWidth:(CGFloat)width;
- (NSAttributedString *)copyWithHighlightedColor;
@end

@interface NSString (Expamdable)
- (NSInteger)composedCount;
@end

@interface UILabel (Expamdable)
- (BOOL)checkWithTouch:(UITouch *)touch isInRange:(NSRange)targetRange;
@end

@implementation ExpandableLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.collapsed = YES;
    self.shouldExpand = YES;
    self.shouldCollapse = NO;
    self.textReplacementType = ExpandableLabelTextReplacementTypeWord;
    self.touchSize = CGSizeMake(44, 44);
    self.collapsedNumberOfLines = 0;
    self.userInteractionEnabled = YES;
    self.lineBreakMode = NSLineBreakByClipping;
    self.collapsedNumberOfLines = self.numberOfLines;
    self.expandedAttributedLink = nil;
    self.collapsedAttributedLink = [[NSAttributedString alloc] initWithString:@"More" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:self.font.pointSize] }];
    self.ellipsis = [[NSAttributedString alloc] initWithString:@"..."];
    self.textAlignment = NSTextAlignmentLeft;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines  {
    [super setNumberOfLines:numberOfLines];
    self.collapsedNumberOfLines = numberOfLines;
}

- (void)setText:(NSString *)text {
    if (text) {
        self.attributedText = [[NSAttributedString alloc] initWithString:text];
    } else {
        self.attributedText = nil;
    }
}

- (NSString *)text {
    return self.attributedText.string;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    attributedText = [[attributedText copyWithAddedFontAttributeWithFont:self.font] copyWithParagraphAttributeWithFont:self.font];
    if (attributedText.length > 0) {
        NSAttributedString *link = self.linkHighlighted ? [self.collapsedAttributedLink copyWithHighlightedColor] : self.collapsedAttributedLink;
        self.collapsedText = [self getCollapsedTextForText:attributedText link:link];
        self.expandedText = [self getExpandedTextForText:attributedText link:self.linkHighlighted ? [self.expandedAttributedLink copyWithHighlightedColor] : self.expandedAttributedLink];
        super.attributedText = self.collapsed ? self.collapsedText : self.expandedText;
    } else {
        self.expandedText = nil;
        self.collapsedText = nil;
        super.attributedText = nil;
    }
}

- (void)setCollapsed:(BOOL)collapsed {
    _collapsed = collapsed;
    [super setAttributedText:collapsed ? self.collapsedText : self.expandedText];
    [super setNumberOfLines:collapsed ? self.collapsedNumberOfLines : 0];
    if (self.animationView) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.animationView layoutIfNeeded];
        }];
    }
}

- (void)setCollapsedAttributedLink:(NSAttributedString *)collapsedAttributedLink {
    _collapsedAttributedLink = [collapsedAttributedLink copyWithAddedFontAttributeWithFont:self.font];
}

- (void)setEllipsis:(NSAttributedString *)ellipsis {
    _ellipsis = [ellipsis copyWithAddedFontAttributeWithFont:self.font];
}

- (void)setLessLinkWithLessLink:(NSString *)lessLink attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes position:(NSTextAlignment)position {
    NSMutableDictionary *alignedattributes = attributes.mutableCopy;
    if (position) {
        self.expandedLinkPosition = position;
        NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        titleParagraphStyle.alignment = position;
        alignedattributes[NSParagraphStyleAttributeName] = titleParagraphStyle;
    }
    self.expandedAttributedLink = [[NSMutableAttributedString alloc] initWithString:lessLink attributes:alignedattributes];
}

#pragma mark Touch Handling
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setLinkHighlighted:touches.allObjects event:event highlighted:YES];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setLinkHighlighted:touches.allObjects event:event highlighted:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *firstTouch = touches.allObjects.firstObject;
    if (firstTouch) {
        if (!self.collapsed) {
            if (self.shouldCollapse && [self checkWithTouch:firstTouch isInRange:self.expandedLinkTextRange]) {
                if (self.delegate) {
                    [self.delegate willCollapseLabel:self];
                }
                self.collapsed = YES;
                if (self.delegate) {
                    [self.delegate didCollapseLabel:self];
                }
                self.linkHighlighted = self.isHighlighted;
                [self setNeedsDisplay];
            }
        } else {
            if (self.shouldExpand && [self setLinkHighlighted:touches.allObjects event:event highlighted:NO]) {
                if (self.delegate) {
                    [self.delegate willExpandLabel:self];
                }
                self.collapsed = NO;
                if (self.delegate) {
                    [self.delegate didExpandLabel:self];
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setLinkHighlighted:touches.allObjects event:event highlighted:NO];
}

#pragma mark Privates
- (NSAttributedString *)textReplaceWordWithLink:(CTLineRef)line index:(NSInteger)index text:(NSAttributedString *)text linkName:(NSAttributedString *)linkName {
    NSAttributedString *lineText = [text textForLineRef:line];
    __block NSAttributedString *lineTextWithLink;

    [lineText.string enumerateSubstringsInRange:NSMakeRange(0, lineText.length) options:NSStringEnumerationByWords | NSStringEnumerationReverse usingBlock:^(NSString *_Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *_Nonnull stop) {
        NSAttributedString *lineTextWithLastWordRemoved = [lineText attributedSubstringFromRange:NSMakeRange(0, substringRange.location)];
        NSMutableAttributedString *lineTextWithAddedLink = [[NSMutableAttributedString alloc] initWithAttributedString:lineTextWithLastWordRemoved];

        if (self.ellipsis) {
            [lineTextWithAddedLink appendAttributedString:self.ellipsis];
            [lineTextWithAddedLink appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{ NSFontAttributeName: self.font }]];
        }
        [lineTextWithAddedLink appendAttributedString:linkName];
        BOOL fits = [self textFitsWidth:lineTextWithAddedLink];

        if (fits) {
            lineTextWithLink = lineTextWithAddedLink;
            CGRect lineTextWithLastWordRemovedRect = [lineTextWithLastWordRemoved boundingRectForWidth:self.frame.size.width];
            CGRect wordRect = [linkName boundingRectForWidth:self.frame.size.width];
            CGFloat width = [lineTextWithLastWordRemoved.string isEqualToString:@""] ? self.frame.size.width : wordRect.size.width;
            self.linkRect = CGRectMake(lineTextWithLastWordRemovedRect.size.width, self.font.lineHeight * index, width, wordRect.size.height);
            *stop = YES;
        }
    }];
    return lineTextWithLink;
}

- (NSAttributedString *)textReplaceWithLink:(CTLineRef)line index:(NSInteger)index text:(NSAttributedString *)text linkName:(NSAttributedString *)linkName {
    NSAttributedString *lineText = [text textForLineRef:line];
    NSMutableAttributedString *lineTextTrimmedNewLines = [[NSMutableAttributedString alloc] init];
    [lineTextTrimmedNewLines appendAttributedString:lineText];
    NSString *string = lineTextTrimmedNewLines.string;
    NSRange range = [string rangeOfCharacterFromSet:NSCharacterSet.newlineCharacterSet];
    if (range.length > 0) {
        [lineTextTrimmedNewLines replaceCharactersInRange:range withString:@""];
    }
    NSMutableAttributedString *linkText = [[NSMutableAttributedString alloc] init];
    if (self.ellipsis) {
        [linkText appendAttributedString:self.ellipsis];
        [linkText appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{ NSFontAttributeName: self.font }]];
    }
    [linkText appendAttributedString:linkName];

    NSInteger lengthDifference = lineTextTrimmedNewLines.string.composedCount - linkText.string.composedCount;
    NSAttributedString *truncatedString = [lineTextTrimmedNewLines attributedSubstringFromRange:NSMakeRange(0, lengthDifference >= 0 ? lengthDifference : lineTextTrimmedNewLines.string.composedCount)];
    NSMutableAttributedString *lineTextWithLink = [[NSMutableAttributedString alloc] initWithAttributedString:truncatedString];
    [lineTextWithLink appendAttributedString:linkText];
    return lineTextWithLink;
}

- (NSAttributedString *)getExpandedTextForText:(NSAttributedString *)text link:(NSAttributedString *)link {
    if (text) {
        NSMutableAttributedString *expandedText = [[NSMutableAttributedString alloc] init];
        [expandedText appendAttributedString:text];
        if (link && [self textWillBeTruncated:expandedText]) {
            NSString *spaceOrNewLine = @"  ";
            [expandedText appendAttributedString:[[NSAttributedString alloc] initWithString:spaceOrNewLine]];
            [expandedText appendAttributedString:[[NSAttributedString alloc] initWithString:link.string attributes:[link attributesAtIndex:0 effectiveRange:nil]]];
            self.expandedLinkTextRange = NSMakeRange(expandedText.length - link.length, link.length);
        }
        return expandedText;
    }
    return nil;
}

- (NSAttributedString *)getCollapsedTextForText:(NSAttributedString *)text link:(NSAttributedString *)link {
    if (text) {
        NSArray *lines = [text linesWithWidth:self.frame.size.width];
        if (self.collapsedNumberOfLines > 0 && self.collapsedNumberOfLines < lines.count) {
            CTLineRef lastLineRef = (__bridge CTLineRef)lines[self.collapsedNumberOfLines - 1];
            CTLineRef line;
            NSInteger index;
            NSAttributedString *modifiedLastLineText;

            if (self.textReplacementType == ExpandableLabelTextReplacementTypeWord) {
                NSArray *lineIndex = [self findLineWithWords:lastLineRef text:text lines:lines];
                line = (__bridge CTLineRef)lineIndex[0];
                index = ((NSNumber *)lineIndex[1]).integerValue;
                modifiedLastLineText = [self textReplaceWordWithLink:line index:index text:text linkName:link];
            } else {
                line = lastLineRef;
                index = self.collapsedNumberOfLines - 1;
                modifiedLastLineText = [self textReplaceWithLink:line index:index text:text linkName:link];
            }

            NSMutableAttributedString *collapsedLines = [[NSMutableAttributedString alloc] init];
            for (int i = 0; i < index; i++) {
                [collapsedLines appendAttributedString:[text textForLineRef:(__bridge CTLineRef)lines[i]]];
            }
            [collapsedLines appendAttributedString:modifiedLastLineText];

            self.collapsedLinkTextRange = NSMakeRange(collapsedLines.length - link.length, link.length);
            return collapsedLines;
        }
    }
    return text;
}

- (NSArray *)findLineWithWords:(CTLineRef)lastLine text:(NSAttributedString *)text lines:(NSArray *)lines {
    CTLineRef lastLineRef = lastLine;
    NSInteger lastLineIndex = self.collapsedNumberOfLines - 1;
    NSArray *lineWords = [self spiltIntoWords:[text textForLineRef:lastLine].string];
    while (lineWords.count < 2 && lastLineIndex > 0) {
        lastLineIndex -= 1;
        lastLineRef = (__bridge CTLineRef)lines[lastLineIndex];
        lineWords = [self spiltIntoWords:[text textForLineRef:lastLineRef].string];
    }
    return @[(__bridge id)lastLineRef, @(lastLineIndex)];
}

- (NSArray<NSString *> *)spiltIntoWords:(NSString *)str {
    NSMutableArray *strings = @[].mutableCopy;
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByWords | NSStringEnumerationReverse usingBlock:^(NSString *_Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *_Nonnull stop) {
        if (substring) {
            [strings addObject:substring];
        }
        if (strings.count > 1) {
            *stop = YES;
        }
    }];
    return strings.copy;
}

- (BOOL)textFitsWidth:(NSAttributedString *)text {
    return ([text boundingRectForWidth:self.frame.size.width].size.height <= self.font.lineHeight);
}

- (BOOL)textWillBeTruncated:(NSAttributedString *)text {
    NSArray *lines = [text linesWithWidth:self.frame.size.width];

    return self.collapsedNumberOfLines > 0 && self.collapsedNumberOfLines < lines.count;
}

- (BOOL)setLinkHighlighted:(NSArray<UITouch *> *)touches event:(UIEvent *)event highlighted:(BOOL)highlighted {
    UITouch *firstTouch = touches.firstObject;
    if (!firstTouch) return NO;

    if (self.collapsed && [self checkWithTouch:firstTouch isInRange:self.collapsedLinkTextRange]) {
        self.linkHighlighted = highlighted;
        [self setNeedsDisplay];
        return YES;
    }
    return NO;
}

@end

@implementation NSAttributedString (Explandable)

- (BOOL)hasFontAttribute {
    if (self.string.length == 0) {
        return NO;
    } else {
        UIFont *font = [self attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        return font != nil;
    }
}

- (NSAttributedString *)copyWithParagraphAttributeWithFont:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.05;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 0;
    paragraphStyle.minimumLineHeight = font.lineHeight;
    paragraphStyle.maximumLineHeight = font.lineHeight;

    NSMutableAttributedString *copy = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSRange range = NSMakeRange(0, copy.length);
    [copy addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [copy addAttribute:NSBaselineOffsetAttributeName value:@(font.pointSize * 0.08) range:range];
    return copy;
}

- (NSAttributedString *)copyWithAddedFontAttributeWithFont:(UIFont *)font {
    if (![self hasFontAttribute]) {
        NSMutableAttributedString *copy = [[NSMutableAttributedString alloc] initWithAttributedString:self];
        [copy addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, copy.length)];
        return copy;
    }
    return self.copy;
}

- (NSAttributedString *)copyWithHighlightedColor {
    CGFloat alphaComponent = 0.5;
    UIColor *baseColor = [((UIColor *)[self attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil]) colorWithAlphaComponent:alphaComponent];
    baseColor = baseColor != nil ? baseColor : [UIColor.blackColor colorWithAlphaComponent:alphaComponent];
    NSMutableAttributedString *highlightedCopy = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSRange range = NSMakeRange(0, highlightedCopy.length);
    [highlightedCopy removeAttribute:NSForegroundColorAttributeName range:range];
    [highlightedCopy addAttribute:NSForegroundColorAttributeName value:baseColor range:range];
    return highlightedCopy;
}

- (NSArray *)linesWithWidth:(CGFloat)width {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.CGPath, nil);

    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);

    return lines;
}

- (NSAttributedString *)textForLineRef:(CTLineRef)lineRef {
    CFRange lineRangeRef = CTLineGetStringRange(lineRef);
    NSRange range = NSMakeRange(lineRangeRef.location, lineRangeRef.length);
    return [self attributedSubstringFromRange:range];
}

- (CGRect)boundingRectForWidth:(CGFloat)width {
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
}

@end

@implementation NSString (Expamdable)

- (NSInteger)composedCount {
    __block NSInteger count = 0;

    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *_Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *_Nonnull stop) {
        count += 1;
    }];

    return count;
}

@end

@implementation UILabel (Expamdable)

- (BOOL)checkWithTouch:(UITouch *)touch isInRange:(NSRange)targetRange {
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger index = [self characterIndexAtTouchPoint:touchPoint];
    return NSLocationInRange(index, targetRange);
}

- (NSInteger)characterIndexAtTouchPoint:(CGPoint)touchPoint {
    if (!self.attributedText) return NSNotFound;
    if (!CGRectContainsPoint(self.bounds, touchPoint)) return NSNotFound;
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    if (!CGRectContainsPoint(textRect, touchPoint)) return NSNotFound;

    CGPoint point = touchPoint;
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, self.attributedText.length), nil, CGSizeMake(textRect.size.width, CGFLOAT_MAX), nil);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(0, 0, suggestedSize.width, suggestedSize.height));

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText.length), path, nil);
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger linesCount = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (linesCount == 0) return NSNotFound;

    CGPoint lineOrigins[linesCount];
    for (int i = 0; i < linesCount; i++) {
        lineOrigins[i] = CGPointZero;
    }
    CTFrameGetLineOrigins(frame, CFRangeMake(0, linesCount), lineOrigins);

    for (int i = 0; i < linesCount; i++) {
        CGPoint lineOrigin = lineOrigins[i];
        CFIndex lineIndex = i;
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);

        // Get bounding information of line
        CGFloat ascent = 0;
        CGFloat descent = 0;
        CGFloat leading = 0;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        // Apply penOffset using flushFactor for horizontal alignment to set lineOrigin since this is the horizontal offset from drawFramesetter

        CGFloat flushFactor = [self flushFactorForTextAlignment:self.textAlignment];
        CGFloat penOffset = CTLineGetPenOffsetForFlush(line, flushFactor, textRect.size.width);
        lineOrigin.x = penOffset;

        // Check if we've already passed the line
        if (point.y > yMax) return NSNotFound;
        // Check if the point is within this line vertically
        if (point.y > yMin) {
        // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
        // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                return CTLineGetStringIndexForPosition(line, relativePoint);
            }
        }
    }
    return NSNotFound;
}

- (CGFloat)flushFactorForTextAlignment:(NSTextAlignment)textAlignment {
    switch (textAlignment) {
        case NSTextAlignmentCenter:
            return 0.5;

        case NSTextAlignmentRight:
            return 1.0;

        default:
            return 0;
    }
}

@end
