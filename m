From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFCv3 0/5] enable migration of driver pages
Date: Tue, 7 Jul 2015 17:07:46 -0700
Message-ID: <20150707170746.1b91ba0d07382cbc9ba3db92@linux-foundation.org>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com>
	<20150707153701.bfcde75108d1fb8aaedc8134@linux-foundation.org>
	<559C68B3.3010105@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559C68B3.3010105-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, gunho.lee-Hm3cg6mZ9cc@public.gmane.org, Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 08 Jul 2015 09:02:59 +0900 Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:

> 
> 
> 2015-07-08 ______ 7:37___ Andrew Morton ___(___) ___ ___:
> > On Tue,  7 Jul 2015 13:36:20 +0900 Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:
> >
> >> From: Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>
> >>
> >> Hello,
> >>
> >> This series try to enable migration of non-LRU pages, such as driver's page.
> >>
> >> My ARM-based platform occured severe fragmentation problem after long-term
> >> (several days) test. Sometimes even order-3 page allocation failed. It has
> >> memory size 512MB ~ 1024MB. 30% ~ 40% memory is consumed for graphic processing
> >> and 20~30 memory is reserved for zram.
> >>
> >> I found that many pages of GPU driver and zram are non-movable pages. So I
> >> reported Minchan Kim, the maintainer of zram, and he made the internal
> >> compaction logic of zram. And I made the internal compaction of GPU driver.
> >>
> >> They reduced some fragmentation but they are not enough effective.
> >> They are activated by its own interface, /sys, so they are not cooperative
> >> with kernel compaction. If there is too much fragmentation and kernel starts
> >> to compaction, zram and GPU driver cannot work with the kernel compaction.
> >>
> >> ...
> >>
> >> This patch set is tested:
> >> - turn on Ubuntu 14.04 with 1G memory on qemu.
> >> - do kernel building
> >> - after several seconds check more than 512MB is used with free command
> >> - command "balloon 512" in qemu monitor
> >> - check hundreds MB of pages are migrated
> >
> > OK, but what happens if the balloon driver is not used to force
> > compaction?  Does your test machine successfully compact pages on
> > demand, so those order-3 allocations now succeed?
> 
> If any driver that has many pages like the balloon driver is forced to compact,
> the system can get free high-order pages.
> 
> I have to show how this patch work with a driver existing in the kernel source,
> for kernel developers' undestanding. So I selected the balloon driver
> because it has already compaction and working with kernel compaction.
> I can show how driver pages is compacted with lru-pages together.
> 
> Actually balloon driver is not best example to show how this patch compacts pages.
> The balloon driver compaction is decreasing page consumtion, for instance 1024MB -> 512MB.
> I think it is not compaction precisely. It frees pages.
> Of course there will be many high-order pages after 512MB is freed.

Can the various in-kernel GPU drivers benefit from this?  If so, wiring
up one or more of those would be helpful?
