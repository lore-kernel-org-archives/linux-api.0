From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: opaque types instead of union epoll_data
Date: Tue, 7 Mar 2017 09:33:57 -0500
Message-ID: <7b758a91-db08-3745-d08d-a09d00effb90@redhat.com>
References: <c06a9ceff1f2c8919ca81120de69f172@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c06a9ceff1f2c8919ca81120de69f172-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sodagudi Prasad <psodagud-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/07/2017 07:31 AM, Sodagudi Prasad wrote:
> uapi structs epoll_data are more opaque than user space expects.
> kernel have defined as __u64 instead of the union epoll_data. Because
> of this libc have redefined struct epoll_event with union data
> member.

We do the same in glibc.

> https://android.googlesource.com/platform/bionic.git/+/master/libc/include/sys/epoll.h
> typedef union epoll_data {
>   void* ptr;
>   int fd;
>   uint32_t u32;
>   uint64_t u64;
> } epoll_data_t;
> struct epoll_event {
>   uint32_t events;
>   epoll_data_t data;
> }
> 
> Kernel UAPI header defined as "include/uapi/linux/eventpoll.h"
> struct epoll_event {
>         __u32 events;
>         __u64 data;  =====>opaque type instead of union epoll_data
> } EPOLL_PACKED;
> 
> 
> Because of this we are landing into some issues as we copy kernel
> headers. Will it be going to be addressed?

What issues are you having? 

Exactly what problems are you running in to? 

Using all of the UAPI headers directly is not a workable
solution, there is a lot of definition and cleanup work to do there.
Some of the headers are immediately useful, but others, as you note
require quite a bit of work to become useful.

The underlying issue of a mismatch between userspace expectations
and UAPI definitions will get addressed when someone, maybe you, 
works diligently to enhance the kernel UAPI headers to be generally 
useful to userspace.

I don't know anyone else who is working on this problem. Though I
have a vested interested in it as a glibc maintainer, since it would
be nice to avoid duplicate headers where possible between the kernel
and userspace.

-- 
Cheers,
Carlos.
