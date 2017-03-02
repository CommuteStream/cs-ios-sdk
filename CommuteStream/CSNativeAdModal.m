//
//  CSNativeAdModal.m
//  CommuteStream
//
//  Created by David Rogers on 2/22/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import "CSNativeAdModal.h"
#import "CommuteStream.h"

@implementation CSNativeAdModal{
    UIImageView *heroImage;
    UILabel *transitHeaderLabel;
    UILabel *transitSubheaderLabel;
    
    UILabel *adTitleLabel;
    UILabel *adDescriptionLabel;
    UILabel *adUrlLabel;
    UIImageView *adIconImage;
    UIView *adInfoView;
    
}

-(id)init
{
    self = [super init];
    if(self){
        
       
        
    }
    return self;
}

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        
    }
    
    return self;
}

-  (id)initWithFrame:(CGRect)aRect andStop:(NSDictionary *)stopObject
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        
        [self setFrame:aRect];
        [self setBackgroundColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0]];
        [self setAlpha:0.0];
        
        CGRect tempFrame = [self frame];
        tempFrame.origin.x = (self.frame.origin.x - self.frame.size.width/2);
        [self setFrame:tempFrame];
        
        transitHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.0, 12.0, self.frame.size.width - 50.0, 16.0)];
        [transitHeaderLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        transitHeaderLabel.text = [[stopObject objectForKey: @"transit_data"] objectForKey:@"transit_data_header_text"];
        
        transitSubheaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.0, 30.0, self.frame.size.width - 50.0, 14.0)];
        [transitSubheaderLabel setFont:[UIFont systemFontOfSize:12.0]];
        [transitSubheaderLabel setTextColor:[UIColor darkGrayColor]];
        transitSubheaderLabel.text = [[stopObject objectForKey: @"transit_data"] objectForKey:@"transit_data_subheader_text"];

        CGFloat heroImageYPos = transitSubheaderLabel.frame.origin.y + transitSubheaderLabel.frame.size.height + 8.0;
        CGFloat heroWidth = self.frame.size.width - 10;
        CGFloat heroHeight = heroWidth * 0.564;
        
        heroImage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0,heroImageYPos, heroWidth , heroHeight)];
        [heroImage setContentMode:UIViewContentModeScaleAspectFit];
        [heroImage setBackgroundColor:[UIColor blackColor]];
        
        CGFloat adInfoYPos = heroImage.frame.origin.y + heroImage.frame.size.height;
        
        adInfoView = [[UIView alloc] initWithFrame:CGRectMake(5.0, adInfoYPos, self.frame.size.width - 10.0, 50.0)];
        
        [adInfoView setBackgroundColor:[UIColor whiteColor]];
        
        adIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 30.0, 30.0)];
        [adIconImage setContentMode:UIViewContentModeScaleAspectFit];
        [adIconImage setImage:[UIImage imageNamed:[[stopObject objectForKey:@"icon"] objectForKey:@"icon_name"]]];
        
        
        
        adTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44.0, 7.0, adInfoView.frame.size.width - 50.0, 14.0)];
        [adTitleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        adTitleLabel.text = [[stopObject objectForKey: @"ad_info"] objectForKey:@"title"];
        
        
        adDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(44.0, 21.0, self.frame.size.width - 50.0, 14.0)];
        [adDescriptionLabel setFont:[UIFont systemFontOfSize:10.0]];
        [adDescriptionLabel setTextColor:[UIColor darkGrayColor]];
        adDescriptionLabel.text = [[stopObject objectForKey: @"ad_info"] objectForKey:@"description"];
        
        adUrlLabel = [[UILabel alloc] initWithFrame:CGRectMake(44.0, 33.0, self.frame.size.width - 50.0, 14.0)];
        [adUrlLabel setFont:[UIFont systemFontOfSize:8.0]];
        [adUrlLabel setTextColor:[UIColor lightGrayColor]];
        adUrlLabel.text = [[stopObject objectForKey: @"ad_info"] objectForKey:@"company_url"];
        
        
        
        
        [self addSubview:transitHeaderLabel];
        [self addSubview:transitSubheaderLabel];
        [self addSubview:heroImage];
        
        [adInfoView addSubview:adIconImage];
        [adInfoView addSubview:adTitleLabel];
        [adInfoView addSubview:adDescriptionLabel];
        [adInfoView addSubview:adUrlLabel];
        [self addSubview:adInfoView];
        
        NSMutableArray *actionArray = [stopObject objectForKey:@"actions"];
        
        CGFloat actionButtonsYPos = adInfoView.frame.origin.y + adInfoView.frame.size.height;
        
        CGFloat frameHeight = 0.0;
        
        for(NSDictionary *item in actionArray){
            NSLog(@"Item in Array = %@", item);
            
            UIColor *buttonColor;
            
            if([[item objectForKey:@"type"] isEqualToString:@"redeem"]){
                buttonColor = [UIColor colorWithRed:0.14 green:0.65 blue:0.20 alpha:1.0];
            }else if([[item objectForKey:@"type"] isEqualToString:@"navigate"]){
                buttonColor = [UIColor colorWithRed:0.08 green:0.40 blue:0.70 alpha:1.0];
            }else{
               buttonColor = [UIColor colorWithRed:0.14 green:0.65 blue:0.20 alpha:1.0];
            }
            
            UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0, actionButtonsYPos + 5.0, self.frame.size.width - 10.0, 50.0)];
            
            UILabel *buttonTitle = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 6.0, actionButton.frame.size.width - 10.0, 26)];
            [buttonTitle setTextAlignment:NSTextAlignmentCenter];
            buttonTitle.text = [item objectForKey:@"title"];
            [buttonTitle setTextColor:[UIColor whiteColor]];
            buttonTitle.font = [UIFont systemFontOfSize:23];
            [actionButton addSubview:buttonTitle];
            
            UILabel *buttonSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 28.0, actionButton.frame.size.width - 10.0, 20)];
            [buttonSubtitle setTextAlignment:NSTextAlignmentCenter];
            buttonSubtitle.text = [item objectForKey:@"subtitle"];
            [buttonSubtitle setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6]];
            buttonSubtitle.font = [UIFont systemFontOfSize:9];
            [actionButton addSubview:buttonSubtitle];
            
            [actionButton setBackgroundColor: buttonColor];
            [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [self addSubview:actionButton];
            
            frameHeight = actionButton.frame.origin.y + actionButton.frame.size.height + 5;
            
        }
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frameHeight);
        
        
        [heroImage setImage: [UIImage imageNamed:[[stopObject objectForKey: @"hero_image"] objectForKey:@"hero_image_name"]]];
        
        NSLog(@"Stop received stop ID %@", stopObject);
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
