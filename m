From: Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] enable migration of driver pages
Date: Mon, 13 Jul 2015 10:20:14 -0400
Message-ID: <20150713142013.GA4025@t510.redhat.com>
References: <1436776519-17337-1-git-send-email-gioh.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1436776519-17337-1-git-send-email-gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 13, 2015 at 05:35:15PM +0900, Gioh Kim wrote:
> From: Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>
> 
> Hello,
> 
> This series try to enable migration of non-LRU pages, such as driver's page.
> 
> My ARM-based platform occured severe fragmentation problem after long-term
> (several days) test. Sometimes even order-3 page allocation failed. It has
> memory size 512MB ~ 1024MB. 30% ~ 40% memory is consumed for graphic processing
> and 20~30 memory is reserved for zram.
> 
> I found that many pages of GPU driver and zram are non-movable pages. So I
> reported Minchan Kim, the maintainer of zram, and he made the internal 
> compaction logic of zram. And I made the internal compaction of GPU driver.
> 
> They reduced some fragmentation but they are not enough effective.
> They are activated by its own interface, /sys, so they are not cooperative
> with kernel compaction. If there is too much fragmentation and kernel starts
> to compaction, zram and GPU driver cannot work with the kernel compaction.
> 
> So I thought there needs a interface to combine driver and kernel compaction.
> This patch adds a generic isolate/migrate/putback callbacks for page
> address-space and a new interface to create anon-inode to manage
> address_space_operation. The zram and GPU, and any other modules can create
> anon_inode and register its own migration method. The kernel compaction can
> call the registered migration when it does compaction.
> 
> My GPU driver source is not in-kernel driver so that I apply the interface
> into balloon driver. The balloon driver is already merged
> into the kernel compaction as a corner-case. This patch have the balloon
> driver migration be called by the generic interface.
> 
> 
> This patch set combines 4 patches.
> 
> 1. patch 1/4: get inode from anon_inodes
> This patch adds new interface to create inode from anon_inodes.
> 
> 2. patch 2/4: framework to isolate/migrate/putback page
> Add isolatepage, putbackpage into address_space_operations
> and wrapper function to call them.
> 
> 3. patch 3/4: apply the framework into balloon driver
> The balloon driver is applied into the framework. It gets a inode
> from anon_inodes and register operations in the inode.
> The kernel compaction calls generic interfaces, not balloon
> driver interfaces. 
> Any other drivers can register operations via inode like this
> to migrate it's pages.
> 
> 4. patch 4/4: remove direct calling of migration of driver pages
> Non-lru pages are also migrated with lru pages by move_to_new_page().
> 
> This patch set is tested:
> - turn on Ubuntu 14.04 with 1G memory on qemu.
> - do kernel building
> - after several seconds check more than 512MB is used with free command
> - command "balloon 512" in qemu monitor
> - check hundreds MB of pages are migrated
> 
> My thanks to Konstantin Khlebnikov for his reviews of the RFC patch set.
> Most of the changes were based on his feedback.
> 
> This patch-set is based on v4.1
> 
> 
> Gioh Kim (4):
>   fs/anon_inodes: new interface to create new inode
>   mm/compaction: enable mobile-page migration
>   mm/balloon: apply mobile page migratable into balloon
>   mm: remove direct calling of migration
> 
>  drivers/virtio/virtio_balloon.c        |  3 ++
>  fs/anon_inodes.c                       |  6 +++
>  fs/proc/page.c                         |  3 ++
>  include/linux/anon_inodes.h            |  1 +
>  include/linux/balloon_compaction.h     | 15 +++++--
>  include/linux/compaction.h             | 80 ++++++++++++++++++++++++++++++++++
>  include/linux/fs.h                     |  2 +
>  include/linux/page-flags.h             | 19 ++++++++
>  include/uapi/linux/kernel-page-flags.h |  1 +
>  mm/balloon_compaction.c                | 72 ++++++++++--------------------
>  mm/compaction.c                        |  8 ++--
>  mm/migrate.c                           | 24 +++-------
>  12 files changed, 160 insertions(+), 74 deletions(-)
> 
> -- 
> 2.1.4
> 
Acked-by: Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
