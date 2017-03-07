From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: opaque types instead of union epoll_data
Date: Tue, 7 Mar 2017 18:59:31 +0100
Message-ID: <20170307175931.GA31000@kroah.com>
References: <c06a9ceff1f2c8919ca81120de69f172@codeaurora.org>
 <7b758a91-db08-3745-d08d-a09d00effb90@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7b758a91-db08-3745-d08d-a09d00effb90@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: Sodagudi Prasad <psodagud@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 07, 2017 at 09:33:57AM -0500, Carlos O'Donell wrote:
> On 03/07/2017 07:31 AM, Sodagudi Prasad wrote:
> > uapi structs epoll_data are more opaque than user space expects.
> > kernel have defined as __u64 instead of the union epoll_data. Because
> > of this libc have redefined struct epoll_event with union data
> > member.
> 
> We do the same in glibc.
> 
> > https://android.googlesource.com/platform/bionic.git/+/master/libc/include/sys/epoll.h
> > typedef union epoll_data {
> >   void* ptr;
> >   int fd;
> >   uint32_t u32;
> >   uint64_t u64;
> > } epoll_data_t;
> > struct epoll_event {
> >   uint32_t events;
> >   epoll_data_t data;
> > }
> > 
> > Kernel UAPI header defined as "include/uapi/linux/eventpoll.h"
> > struct epoll_event {
> >         __u32 events;
> >         __u64 data;  =====>opaque type instead of union epoll_data
> > } EPOLL_PACKED;
> > 
> > 
> > Because of this we are landing into some issues as we copy kernel
> > headers. Will it be going to be addressed?
> 
> What issues are you having? 
> 
> Exactly what problems are you running in to? 
> 
> Using all of the UAPI headers directly is not a workable
> solution, there is a lot of definition and cleanup work to do there.
> Some of the headers are immediately useful, but others, as you note
> require quite a bit of work to become useful.
> 
> The underlying issue of a mismatch between userspace expectations
> and UAPI definitions will get addressed when someone, maybe you, 
> works diligently to enhance the kernel UAPI headers to be generally 
> useful to userspace.
> 
> I don't know anyone else who is working on this problem. Though I
> have a vested interested in it as a glibc maintainer, since it would
> be nice to avoid duplicate headers where possible between the kernel
> and userspace.

I've been working with the bionic developers to try to help clean up
some of these things.  Yes, epoll is messy here as you all have pointed
out, and I'll be glad to review any patches that people submit for this.
I need to get some spare time (hah!) to work through some of the issues
that the bionic developers have already pointed out to me...

thanks,

greg k-h
