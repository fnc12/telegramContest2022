#import "MyTableView.h"

static NSInteger setContentOffsetCount = 0;

@implementation MyTableView

- (void)setContentOffset:(CGPoint)contentOffset {
//    CGPoint oldContentOffset = self.contentOffset;
    [super setContentOffset:contentOffset];
    if (32 == setContentOffsetCount) {
        int i = 0;
        ++i;
    }
    NSLog(@"%ld) setContentOffset %@", setContentOffsetCount, NSStringFromCGPoint(contentOffset));
    ++setContentOffsetCount;
}

@end
