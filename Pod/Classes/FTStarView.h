//
//  FTStarView.h
//  Pods
//
//  Created by Felipe Tumonis on 12/06/15.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    FTStarViewFillEmpty,
    FTStarViewFillHalf,
    FTStarViewFillFull
}
FTStarViewFill;

@interface FTStarView : UIView

- (instancetype)initWithFillMode:(FTStarViewFill)fillMode;

@property (nonatomic) FTStarViewFill fillMode;

@end
