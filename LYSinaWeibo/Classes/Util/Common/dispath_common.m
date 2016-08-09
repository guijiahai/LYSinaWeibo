//
//  dispath_common.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/26.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "dispath_common.h"

#if __BLOCKS__

void dispatch_async_inChild(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void dispatch_async_inMain(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}

#endif