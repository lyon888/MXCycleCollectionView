//
//  MXCycleItem.m
//  InBookClub
//
//  Created by 广东众网合一网络科技有限公司 on 16/11/12.
//  Copyright © 2016年 iOSlyon. All rights reserved.
//

#import "MXCycleItem.h"

#define Key_Link @"link"
#define Key_Pic @"pic"

@implementation MXCycleItem
//MJCodingImplementation

//解码的方法，作用就是对保存在NSCoder对象中编过码的数据进行解码，在一一的赋值给当前类的属性
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        //这里的获得的解码过后的对象，用当前的属性保存，要使用self.
        self.link = [decoder decodeObjectForKey:Key_Link];
        self.pic = [decoder decodeObjectForKey:Key_Pic];
    }
    return self;
}
//编码的方法，作用就是对当前类的属性进行一一编码
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //对属性进行编码
    [encoder encodeObject:_link forKey:Key_Link];
    [encoder encodeObject:_pic forKey:Key_Pic];
}

@end
