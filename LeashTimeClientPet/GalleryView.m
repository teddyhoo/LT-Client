//
//  GalleryView.m
//  LeashTimeClientPet
//
//  Created by Ted Hooban on 6/16/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryView.h"


@interface GalleryView() {
    
    
}

@property (nonatomic,strong) NSMutableArray *dataFields;
@property (nonatomic,copy) NSString *captionForCurrentImage;
@property (nonatomic,strong) UIImageView *currentImageFrame;
@property (nonatomic,strong) UIImageView *favoriteIcon;
@property (nonatomic,strong) UILabel *captionLabel;


@end


@implementation GalleryView


-(id)initWithFrame:(CGRect)frame andData:(NSString *)imageName andCaption:(NSString *)captionText {
    
    _currentImageFrame  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-60, frame.size.height -330)];
    [_currentImageFrame setImage:[UIImage imageNamed:imageName]];
    
    _captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _currentImageFrame.frame.size.height - 10, _currentImageFrame.frame.size.width, 40)];
    [_captionLabel setText:captionText];
    [_captionLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Regular" size:18]];
    [_captionLabel setTextColor:[UIColor blackColor]];
    [_currentImageFrame addSubview:_captionLabel];
    
    self = [self initWithFrame:frame];
    return self;
    
}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self baseInit];
        
        self.userInteractionEnabled  = YES;
        
    }
    
    return self;
}

-(void)baseInit {

    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 140, self.frame.size.width - 40, self.frame.size.height - 260)];
    [backImage setImage:[UIImage imageNamed:@"photo-frame-290x354"]];
    backImage.alpha = 0.9;
    [backImage addSubview:_currentImageFrame];
    [self addSubview:backImage];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    
    
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInView:self];
    
}



@end
