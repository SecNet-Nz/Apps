//
//  GradientNode.h
//  Interface 
//
//  Generated by Interface 2
//  http://lesscode.co.nz/interface
//

#import <Foundation/Foundation.h>


@interface GradientNode : NSObject {
    NSNumber *location;
    UIColor *color;
}

@property (nonatomic, copy) NSNumber *location;
@property (nonatomic, retain) UIColor *color;

+ (GradientNode *)nodeWithLocation:(NSNumber *)location color:(UIColor *)color;

@end
