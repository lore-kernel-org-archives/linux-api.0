From: Sodagudi Prasad <psodagud@codeaurora.org>
Subject: opaque types instead of union epoll_data
Date: Tue, 07 Mar 2017 04:31:19 -0800
Message-ID: <c06a9ceff1f2c8919ca81120de69f172@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
List-Id: linux-api@vger.kernel.org

Hi All,

uapi structs epoll_data are more opaque than user space expects. kernel 
have defined as __u64 instead of the union epoll_data.
Because of this libc have redefined struct epoll_event with union data 
member.

https://android.googlesource.com/platform/bionic.git/+/master/libc/include/sys/epoll.h
typedef union epoll_data {
   void* ptr;
   int fd;
   uint32_t u32;
   uint64_t u64;
} epoll_data_t;
struct epoll_event {
   uint32_t events;
   epoll_data_t data;
}

Kernel UAPI header defined as "include/uapi/linux/eventpoll.h"
struct epoll_event {
         __u32 events;
         __u64 data;  =====>opaque type instead of union epoll_data
} EPOLL_PACKED;


Because of this we are landing into some issues as we copy kernel 
headers. Will it be going to be addressed?

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
Linux Foundation Collaborative Project
