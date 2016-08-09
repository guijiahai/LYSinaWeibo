//
//  dispath_common.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/26.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __BLOCKS__

void dispatch_async_inChild(dispatch_block_t block);
void dispatch_async_inMain(dispatch_block_t block);

#endif