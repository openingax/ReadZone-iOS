//
//  TIMElem+ShowAPIs.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TIMElem+ShowAPIs.h"
#import "TSChatTableViewCell.h"
#import "TSChatTimeTipTableViewCell.h"
#import "TSIMAdapter.h"
#import "PathHeaders.h"

@implementation TIMElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg
{
    return [TSChatBaseTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg
{
    return CGSizeMake(width, 32);
}

@end

@implementation TIMTextElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg
{
    return [TSChatTextTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg
{
    CGSize size = [self.text textSizeIn:CGSizeMake(width, HUGE_VAL) font:[packMsg textFont]];
    
    
    if (size.height < kIMAMsgMinHeigth) {
        size.height = kIMAMsgMinHeigth;
    }
    return size;
}

@end


@implementation TIMImageElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg {
    return [TSChatImageTableViewCell class];
}

- (CGSize)getThumbShowSizeInMsg:(TSIMMsg *)packMsg;
{
    NSInteger tw = [packMsg integerForKey:kIMAMSG_Image_ThumbWidth];
    NSInteger th = [packMsg integerForKey:kIMAMSG_Image_ThumbHeight];
    
    if (tw == 0 || th == 0)
    {
        BOOL succ = NO;
        for (TIMImage *timImage in self.imageList)
        {
//            if (timImage.type == TIM_IMAGE_TYPE_THUMB)
            if (timImage.type == TIM_IMAGE_TYPE_LARGE)
            {
                // 解析大小
                CGFloat scale = 1;
                scale = MIN(kChatPicThumbMaxHeight/timImage.height, kChatPicThumbMaxWidth/timImage.width);
                tw = (NSInteger)(timImage.width * scale + 1);
                th =  (NSInteger)(timImage.height * scale + 1);
                
                [packMsg addInteger:tw forKey:kIMAMSG_Image_ThumbWidth];
                [packMsg addInteger:th forKey:kIMAMSG_Image_ThumbHeight];
                succ = YES;
                break;
            }
        }
    }
    
    return CGSizeMake(tw, th);
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg
{
    NSInteger tw = [packMsg integerForKey:kIMAMSG_Image_ThumbWidth];
    NSInteger th = [packMsg integerForKey:kIMAMSG_Image_ThumbHeight];
    
    if (tw ==0 || th ==0)
    {
        BOOL succ = NO;
        for (TIMImage *timImage in self.imageList)
        {
//            if (timImage.type == TIM_IMAGE_TYPE_THUMB)
            if (timImage.type == TIM_IMAGE_TYPE_LARGE)
            {
                // 解析大小
                CGFloat scale = 1;
                scale = MIN(kChatPicThumbMaxHeight/timImage.height, kChatPicThumbMaxWidth/timImage.width);
                tw = (NSInteger)(timImage.width * scale + 1);
                th =  (NSInteger)(timImage.height * scale + 1);
                
                [packMsg addInteger:tw forKey:kIMAMSG_Image_ThumbWidth];
                [packMsg addInteger:th forKey:kIMAMSG_Image_ThumbHeight];
                succ = YES;
                break;
            }
        }
        
        if (!succ)
        {
            NSString *filePath = self.path;
            NSInteger thumbWidth = kChatPicThumbMaxWidth;
            NSInteger thumbHeight = kChatPicThumbMaxHeight;
            if (![NSString isEmpty:filePath])
            {
                // NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f_Size_%d_%d", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate], (int)picThumbWidth, (int)picThumbHeight];
                // 检查本地是否存储了
                BOOL exist = [PathUtility isExistFile:filePath];
                if (exist)
                {
                    // 获取原图
                    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
                    // TODO：是否能过加载的图片再算
                    CGFloat scale = 1;
                    scale = MIN(kChatPicThumbMaxHeight/image.size.height, kChatPicThumbMaxWidth/image.size.width);
                    
                    CGFloat picHeight = image.size.height;
                    CGFloat picWidth = image.size.width;
                    thumbWidth = (NSInteger)(picHeight * scale + 1);
                    thumbHeight = (NSInteger)(picWidth * scale + 1);
                    
                    tw = thumbWidth;
                    th = thumbWidth;
                    
                    [packMsg addInteger:thumbHeight forKey:kIMAMSG_Image_ThumbHeight];
                    [packMsg addInteger:thumbWidth forKey:kIMAMSG_Image_ThumbWidth];
                }
                else
                {
                    DebugLog(@"程序异常退出，导致本地缓存图片不存在");
                }
            }
            else
            {
                DebugLog(@"理论不可达区域");
            }
        }
    }
    
    
    
    if (tw > width)
    {
        th = (NSInteger)(th * width/tw);
        tw = width;
    }
    
    if (th == 0 || tw == 0) {
        th = 87;
        tw = 58;
    }
    
    return CGSizeMake(tw, th);
}

@end


@implementation TIMSoundElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg {
    return [TSChatSoundTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg {
    NSInteger minWidth = 70;
    NSInteger uni = (width - minWidth) / 60;
    
    NSInteger w = minWidth + self.second * uni;
    if (w > width) {
        w = width;
    }
    return CGSizeMake(w, kIMAMsgMinHeigth);
}

@end


@implementation TIMUGCElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg {
    return [TSChatVideoTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg {
    return CGSizeMake(150, 100);
}

@end

@implementation TIMVideoElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg {
    return [TSChatVideoTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg {
    return CGSizeMake(150, 100);
}

@end

@implementation TIMCustomElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg {
    if (msg.type == TSIMMsgTypeTimeTip) {
        return [TSChatTimeTipTableViewCell class];
    } else if (msg.type == TSIMMsgTypeSaftyTip) {
        return [TSChatSaftyTipTableViewCell class];
    } else if (msg.type == TSIMMsgTypeRevokedTip) {
        return [TSRevokedTipTableViewCell class];
    } else {
        return [super showCellClassOf:msg];
    }
}

@end

