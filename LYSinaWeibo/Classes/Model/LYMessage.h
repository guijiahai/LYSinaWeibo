//
//  LYMessage.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYMessage : NSObject

/**
 text, position, voice, image
 */
@property (nonatomic, strong) NSString *type;

/**
 消息的接受者
 */
@property (nonatomic, strong) NSNumber *receiver_id;

/**
 消息的发送者
 */
@property (nonatomic, strong) NSNumber *sender_id;

@property (nonatomic, strong) NSString *created_at;

/**
 text : 私信内容
 position : 原位置私信内容，没有时用默认文案“发送了一个位置”
 */
@property (nonatomic, strong) NSString *text;

/**
 text : 消息内容，纯文本私信或留言为空
 position : 消息内容 - longitude : 经度, latitude : 纬度
 voice : vfid 发送者通过此id读取语音, tovfid 接受者通过此id读取语音
 image : vfid 发送者通过此id读取图片, tovfid 接受者通过此id读取图片
 */
@property (nonatomic, strong) NSString *data;

@end
