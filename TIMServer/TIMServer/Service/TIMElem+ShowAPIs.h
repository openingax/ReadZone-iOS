//
//  TIMElem+ShowAPIs.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import "TSIMMsg.h"

@class TSIMMsg;

@interface TIMElem (ShowAPIs)

// TSIMMsg中只有一个Elem的时候有效，
- (Class)showCellClassOf:(TSIMMsg *)msg;

// 消息在width下显示的size
- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg;

@end

@interface TIMTextElem (ShowAPIs)

@end

@interface TIMImageElem (ShowAPIs)

// 只存已发送或接收成功的
- (CGSize)getThumbShowSizeInMsg:(TSIMMsg *)msg;

@end

@interface TIMFileElem (ShowAPIs)

@end

@interface TIMSoundElem (ShowAPIs)


@end

@interface TIMFaceElem (ShowAPIs)

@end

@interface TIMLocationElem (ShowAPIs)

@end

@interface TIMGroupTipsElem (ShowAPIs)


@end

@interface TIMUGCElem (ShowAPIs)

@end

@interface TIMCustomElem (ShowAPIs)

@end


@interface TIMGroupSystemElem (ShowAPIs)



@end

