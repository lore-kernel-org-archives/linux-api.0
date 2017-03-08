From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: opaque types instead of union epoll_data
Date: Wed, 8 Mar 2017 19:01:35 +0100
Message-ID: <20170308180135.GA10747@kroah.com>
References: <c06a9ceff1f2c8919ca81120de69f172@codeaurora.org>
 <7b758a91-db08-3745-d08d-a09d00effb90@redhat.com>
 <20170307175931.GA31000@kroah.com>
 <ba7d0715-b59a-6596-9ec0-435999cd0e76@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ba7d0715-b59a-6596-9ec0-435999cd0e76-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sodagudi Prasad <psodagud-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 08, 2017 at 12:34:07PM -0500, Carlos O'Donell wrote:
> On 03/07/2017 12:59 PM, Greg KH wrote:
> > On Tue, Mar 07, 2017 at 09:33:57AM -0500, Carlos O'Donell wrote:
> >> I don't know anyone else who is working on this problem. Though I
> >> have a vested interested in it as a glibc maintainer, since it would
> >> be nice to avoid duplicate headers where possible between the kernel
> >> and userspace.
> > 
> > I've been working with the bionic developers to try to help clean up
> > some of these things.  Yes, epoll is messy here as you all have pointed
> > out, and I'll be glad to review any patches that people submit for this.
> > I need to get some spare time (hah!) to work through some of the issues
> > that the bionic developers have already pointed out to me...
> 
> Sounds awesome. Please keep linux-api in the loop so the other libc
> maintainers can follow along. From a glibc perspective I'm interested,
> but also busy (see the other thread about libc-compat.h which has
> immediate impact on header coordination).

Ah, I forgot to cc: linux-api on my last epoll header file change, I'll
go do that now before I commit it to my tree for 4.12...

thanks,

greg k-h
