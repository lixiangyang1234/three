//
//  CommenHelper.m
//  ThreeMan
//
//  Created by tianj on 15/4/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CommenHelper.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>

@implementation CommenHelper


+ (double)avaibleMemory
{
//    int mib[6];
//    mib[0] = CTL_HW;
//    mib[1] = HW_PAGESIZE;
//    
//    int pagesize;
//    size_t length;
//    length = sizeof(pagesize);
//    if (sysctl(mib, 2, &pagesize, &length,NULL, 0)<0) {
//        fprintf(stderr, "getting page size");
//    }
//    
//    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
//    
//    vm_statistics_data_t vmstat;
//    
//    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count)) {
//        fprintf (stderr, "Failed to get VM statistics.");
//    }
//    
//    task_basic_info_64_data_t info;
//    unsigned size = sizeof (info);
//    task_info (mach_task_self (), TASK_BASIC_INFO_64, (task_info_t) &info, &size);
//    
//    double unit = 1024 * 1024*1024;
//    double total = (vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count) * pagesize / unit;
//    double wired = vmstat.wire_count * pagesize / unit;
//    double active = vmstat.active_count * pagesize / unit;
//    double inactive = vmstat.inactive_count * pagesize / unit;
//    double free = vmstat.free_count * pagesize / unit;
//    double resident = info.resident_size / unit;
//    
//    return free;
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}


@end
