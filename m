From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 22/22] fpga: intel: afu: add FPGA_PORT_DMA_MAP/UNMAP
 ioctls support
Date: Tue, 1 Aug 2017 15:21:56 +0800
Message-ID: <20170801072156.GA26227@hao-dev>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-23-git-send-email-hao.wu@intel.com>
 <CANk1AXQ0kKnDOWo_BLA_r3P_rsmiZ1LQCVWqXtmXYmkUnzDtog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXQ0kKnDOWo_BLA_r3P_rsmiZ1LQCVWqXtmXYmkUnzDtog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 31, 2017 at 04:41:26PM -0500, Alan Tull wrote:
> On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Hi Alan

Thanks a lot for the code review. :)

> 
> Hi Hao,
> 
> Please run checkpatch.pl --strict on this.

Sure, thanks for the suggestion, will run this on all the patches and
fix the items reported.

> 
> Could you add some kernel-doc function comments here to help the new
> user (or reviewer) get a better handle on what this code is doing?

Do make sense to me, sure, will add kernel-doc style function comments.

> 
> A few mostly minor comments below.
> 
> > DMA memory regions are required for Accelerated Function Unit (AFU) usage.
> > These two ioctls allow user space applications to map user memory regions
> > for dma, and unmap them after use. Iova is returned from driver to user
> > space application via FPGA_PORT_DMA_MAP ioctl. Application needs to unmap
> > it after use, otherwise, driver will unmap them in device file release
> > operation.
> >
> > All the mapped regions are managed via a rb tree.
> 
> Please note that each afu has its own rb tree (this comment sounds
> like there's one rb tree for all) to keep track of its DMA regions.

Yes, each afu has its own rb tree to manage the DMA regions, as each afu
could be assigned to a separated virtual machine.

I will improve the description above to avoid confusing things.

> 
> >
> > Ioctl interfaces:
> > * FPGA_PORT_DMA_MAP
> >   Do the dma mapping per user_addr and length which provided by user.
> >   Return iova in provided struct afu_port_dma_map.
> >
> > * FPGA_PORT_DMA_UNMAP
> >   Unmap the dma region per iova provided by user.
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > v2: moved the code to drivers/fpga folder as suggested by Alan Tull.
> >     switched to GPLv2 license.
> >     fixed kbuild warnings.
> > ---
> >  drivers/fpga/Makefile               |   3 +-
> >  drivers/fpga/intel-afu-dma-region.c | 372 ++++++++++++++++++++++++++++++++++++
> >  drivers/fpga/intel-afu-main.c       |  61 +++++-
> >  drivers/fpga/intel-afu.h            |  18 ++
> >  include/uapi/linux/intel-fpga.h     |  37 ++++
> >  5 files changed, 489 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/fpga/intel-afu-dma-region.c
> >
> > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> > index 45c0538..339d1f3 100644
> > --- a/drivers/fpga/Makefile
> > +++ b/drivers/fpga/Makefile
> > @@ -38,4 +38,5 @@ obj-$(CONFIG_INTEL_FPGA_AFU)          += intel-fpga-afu.o
> >
> >  intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
> >  intel-fpga-fme-objs := intel-fme-main.o intel-fme-pr.o
> > -intel-fpga-afu-objs := intel-afu-main.o intel-afu-region.o
> > +intel-fpga-afu-objs := intel-afu-main.o intel-afu-region.o \
> > +                      intel-afu-dma-region.o
> > diff --git a/drivers/fpga/intel-afu-dma-region.c b/drivers/fpga/intel-afu-dma-region.c
> > new file mode 100644
> > index 0000000..982a9b5
> > --- /dev/null
> > +++ b/drivers/fpga/intel-afu-dma-region.c
> > @@ -0,0 +1,372 @@
> > +/*
> > + * Driver for Intel FPGA Accelerated Function Unit (AFU) DMA Region Management
> > + *
> > + * Copyright (C) 2017 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > + *   Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > + *
> > + * This work is licensed under the terms of the GNU GPL version 2. See
> > + * the COPYING file in the top-level directory.
> > + */
> > +
> > +#include <linux/sched/signal.h>
> > +#include <linux/uaccess.h>
> > +
> > +#include "intel-afu.h"
> > +
> > +static void put_all_pages(struct page **pages, int npages)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < npages; i++)
> > +               if (pages[i] != NULL)
> > +                       put_page(pages[i]);
> > +}
> > +
> > +void afu_dma_region_init(struct feature_platform_data *pdata)
> > +{
> > +       struct fpga_afu *afu = fpga_pdata_get_private(pdata);
> > +
> > +       afu->dma_regions = RB_ROOT;
> > +}
> > +
> > +static long afu_dma_adjust_locked_vm(struct device *dev, long npages, bool incr)
> > +{
> > +       unsigned long locked, lock_limit;
> > +       int ret = 0;
> > +
> > +       /* the task is exiting. */
> > +       if (!current->mm)
> > +               return 0;
> > +
> > +       down_write(&current->mm->mmap_sem);
> > +
> > +       if (incr) {
> > +               locked = current->mm->locked_vm + npages;
> > +               lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > +
> > +               if (locked > lock_limit && !capable(CAP_IPC_LOCK))
> > +                       ret = -ENOMEM;
> > +               else
> > +                       current->mm->locked_vm += npages;
> > +       } else {
> > +
> 
> Don't need to skip a line here.

Sorry, will fix this in next version.

> 
> > +               if (WARN_ON_ONCE(npages > current->mm->locked_vm))
> > +                       npages = current->mm->locked_vm;
> > +               current->mm->locked_vm -= npages;
> > +       }
> > +
> > +       dev_dbg(dev, "[%d] RLIMIT_MEMLOCK %c%ld %ld/%ld%s\n", current->pid,
> > +                               incr ? '+' : '-',
> > +                               npages << PAGE_SHIFT,
> > +                               current->mm->locked_vm << PAGE_SHIFT,
> > +                               rlimit(RLIMIT_MEMLOCK),
> > +                               ret ? "- execeeded" : "");
> > +
> > +       up_write(&current->mm->mmap_sem);
> > +
> > +       return ret;
> > +}
> > +
> > +static long afu_dma_pin_pages(struct feature_platform_data *pdata,
> > +                               struct fpga_afu_dma_region *region)
> 
> Conventionally, return type is usually int in kernel functions that
> return 0 or error code.

The ioctl function has long return value, so I made these functions to have
the long return value too.

I could update the code to change it to int for sure, I think no impact to
any functionality. : )

> 
> > +{
> > +       long npages = region->length >> PAGE_SHIFT;
> > +       struct device *dev = &pdata->dev->dev;
> > +       long ret, pinned;
> > +
> > +       ret = afu_dma_adjust_locked_vm(dev, npages, true);
> > +       if (ret)
> > +               return ret;
> > +
> > +       region->pages = kcalloc(npages, sizeof(struct page *), GFP_KERNEL);
> > +       if (!region->pages) {
> > +               afu_dma_adjust_locked_vm(dev, npages, false);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       pinned = get_user_pages_fast(region->user_addr, npages, 1,
> > +                                       region->pages);
> > +       if (pinned < 0) {
> > +               ret = pinned;
> 
> This return value gets all the way to be returned by the ioctl and
> isn't used for its value as the number that actually got pinned by the
> caller.

Yes, user application doesn't care how many pages are pinned, it only needs
to know the dma mapping request result for given memory region.

So if get_user_pages_fast returns error code, or only pins a page number which
is smaller than expected, then return error code to userspace application. If
it works as expected, then return 0.

Will put them into function comment in next version.

> 
> > +               goto err_put_pages;
> > +       } else if (pinned != npages) {
> > +               ret = -EFAULT;
> > +               goto err;
> > +       }
> > +
> > +       dev_dbg(dev, "%ld pages pinned\n", pinned);
> > +
> > +       return 0;
> > +
> > +err_put_pages:
> > +       put_all_pages(region->pages, pinned);
> > +err:
> > +       kfree(region->pages);
> > +       afu_dma_adjust_locked_vm(dev, npages, false);
> > +       return ret;
> > +}
> > +
> > +static void afu_dma_unpin_pages(struct feature_platform_data *pdata,
> > +                               struct fpga_afu_dma_region *region)
> > +{
> > +       long npages = region->length >> PAGE_SHIFT;
> > +       struct device *dev = &pdata->dev->dev;
> > +
> > +       put_all_pages(region->pages, npages);
> > +       kfree(region->pages);
> > +       afu_dma_adjust_locked_vm(dev, npages, false);
> > +
> > +       dev_dbg(dev, "%ld pages unpinned\n", npages);
> > +}
> > +
> > +static bool afu_dma_check_continuous_pages(struct fpga_afu_dma_region *region)
> > +{
> > +       int npages = region->length >> PAGE_SHIFT;
> > +       int i;
> > +
> > +       for (i = 0; i < npages - 1; i++)
> > +               if (page_to_pfn(region->pages[i]) + 1 !=
> > +                                       page_to_pfn(region->pages[i+1]))
> > +                       return false;
> > +
> > +       return true;
> > +}
> > +
> > +static bool dma_region_check_iova(struct fpga_afu_dma_region *region,
> > +                                 u64 iova, u64 size)
> 
> This function checks that the area defined by iova and size is fully
> contained in the region, right?  A comment would help.

Yes , will add comment for this function. 

> > +{
> > +       if (!size && region->iova != iova)
> > +               return false;
> > +
> > +       return (region->iova <= iova) &&
> > +               (region->length + region->iova >= iova + size);
> > +}
> > +
> > +/* Need to be called with pdata->lock held */
> > +static int afu_dma_region_add(struct feature_platform_data *pdata,
> > +                                       struct fpga_afu_dma_region *region)
> > +{
> > +       struct fpga_afu *afu = fpga_pdata_get_private(pdata);
> > +       struct rb_node **new, *parent = NULL;
> > +
> > +       dev_dbg(&pdata->dev->dev, "add region (iova = %llx)\n",
> > +                                       (unsigned long long)region->iova);
> > +
> > +       new = &(afu->dma_regions.rb_node);
> > +
> > +       while (*new) {
> > +               struct fpga_afu_dma_region *this;
> > +
> > +               this = container_of(*new, struct fpga_afu_dma_region, node);
> > +
> > +               parent = *new;
> > +
> > +               if (dma_region_check_iova(this, region->iova, region->length))
> > +                       return -EEXIST;
> > +
> > +               if (region->iova < this->iova)
> > +                       new = &((*new)->rb_left);
> > +               else if (region->iova > this->iova)
> > +                       new = &((*new)->rb_right);
> > +               else
> > +                       return -EEXIST;
> > +       }
> > +
> > +       rb_link_node(&region->node, parent, new);
> > +       rb_insert_color(&region->node, &afu->dma_regions);
> > +
> > +       return 0;
> > +}
> > +
> > +/* Need to be called with pdata->lock held */
> > +static void afu_dma_region_remove(struct feature_platform_data *pdata,
> > +                                       struct fpga_afu_dma_region *region)
> > +{
> > +       struct fpga_afu *afu;
> > +
> > +       dev_dbg(&pdata->dev->dev, "del region (iova = %llx)\n",
> > +                                       (unsigned long long)region->iova);
> > +
> > +       afu = fpga_pdata_get_private(pdata);
> > +       rb_erase(&region->node, &afu->dma_regions);
> > +}
> > +
> > +/* Need to be called with pdata->lock held */
> > +void afu_dma_region_destroy(struct feature_platform_data *pdata)
> > +{
> > +       struct fpga_afu *afu = fpga_pdata_get_private(pdata);
> > +       struct rb_node *node = rb_first(&afu->dma_regions);
> > +       struct fpga_afu_dma_region *region;
> > +
> > +       while (node) {
> > +               region = container_of(node, struct fpga_afu_dma_region, node);
> > +
> > +               dev_dbg(&pdata->dev->dev, "del region (iova = %llx)\n",
> > +                                       (unsigned long long)region->iova);
> > +
> > +               rb_erase(node, &afu->dma_regions);
> > +
> > +               if (region->iova)
> > +                       dma_unmap_page(fpga_pdata_to_pcidev(pdata),
> > +                                       region->iova, region->length,
> > +                                       DMA_BIDIRECTIONAL);
> > +
> > +               if (region->pages)
> > +                       afu_dma_unpin_pages(pdata, region);
> > +
> > +               node = rb_next(node);
> > +               kfree(region);
> > +       }
> > +}
> > +
> > +/*
> > + * It finds the dma region from the rbtree based on @iova and @size:
> > + * - if @size == 0, it finds the dma region which starts from @iova
> > + * - otherwise, it finds the dma region which fully contains
> > + *   [@iova, @iova+size)
> > + * If nothing is matched returns NULL.
> > + *
> > + * Need to be called with pdata->lock held.
> > + */
> > +struct fpga_afu_dma_region *
> > +afu_dma_region_find(struct feature_platform_data *pdata, u64 iova, u64 size)
> > +{
> > +       struct fpga_afu *afu = fpga_pdata_get_private(pdata);
> > +       struct rb_node *node = afu->dma_regions.rb_node;
> > +       struct device *dev = &pdata->dev->dev;
> > +
> > +       while (node) {
> > +               struct fpga_afu_dma_region *region;
> > +
> > +               region = container_of(node, struct fpga_afu_dma_region, node);
> > +
> > +               if (dma_region_check_iova(region, iova, size)) {
> > +                       dev_dbg(dev, "find region (iova = %llx)\n",
> > +                               (unsigned long long)region->iova);
> > +                       return region;
> > +               }
> > +
> > +               if (iova < region->iova)
> > +                       node = node->rb_left;
> > +               else if (iova > region->iova)
> > +                       node = node->rb_right;
> > +               else
> > +                       /* the iova region is not fully covered. */
> > +                       break;
> > +       }
> > +
> > +       dev_dbg(dev, "region with iova %llx and size %llx is not found\n",
> > +               (unsigned long long)iova, (unsigned long long)size);
> > +       return NULL;
> > +}
> > +
> > +static struct fpga_afu_dma_region *
> > +afu_dma_region_find_iova(struct feature_platform_data *pdata, u64 iova)
> > +{
> > +       return afu_dma_region_find(pdata, iova, 0);
> > +}
> > +
> > +long afu_dma_map_region(struct feature_platform_data *pdata,
> > +                      u64 user_addr, u64 length, u64 *iova)
> > +{
> > +       struct fpga_afu_dma_region *region;
> > +       int ret;
> > +
> > +       /*
> > +        * Check Inputs, only accept page-aligned user memory region with
> > +        * valid length.
> > +        */
> > +       if (!PAGE_ALIGNED(user_addr) || !PAGE_ALIGNED(length) || !length)
> > +               return -EINVAL;
> > +
> > +       /* Check overflow */
> > +       if (user_addr + length < user_addr)
> > +               return -EINVAL;
> > +
> > +       if (!access_ok(VERIFY_WRITE, (void __user *)(unsigned long)user_addr,
> > +                      length))
> > +               return -EINVAL;
> > +
> > +       region = kzalloc(sizeof(*region), GFP_KERNEL);
> > +       if (!region)
> > +               return -ENOMEM;
> > +
> > +       region->user_addr = user_addr;
> > +       region->length = length;
> > +
> > +       /* Pin the user memory region */
> > +       ret = afu_dma_pin_pages(pdata, region);
> > +       if (ret) {
> > +               dev_err(&pdata->dev->dev, "fail to pin memory region\n");
> > +               goto free_region;
> > +       }
> > +
> > +       /* Only accept continuous pages, return error if no */
> > +       if (!afu_dma_check_continuous_pages(region)) {
> > +               dev_err(&pdata->dev->dev, "pages are not continuous\n");
> > +               ret = -EINVAL;
> > +               goto unpin_pages;
> > +       }
> > +
> > +       /* As pages are continuous then start to do DMA mapping */
> > +       region->iova = dma_map_page(fpga_pdata_to_pcidev(pdata),
> > +                                   region->pages[0], 0,
> > +                                   region->length,
> > +                                   DMA_BIDIRECTIONAL);
> > +       if (dma_mapping_error(&pdata->dev->dev, region->iova)) {
> > +               dev_err(&pdata->dev->dev, "fail to map dma mapping\n");
> > +               ret = -EFAULT;
> > +               goto unpin_pages;
> > +       }
> > +
> > +       *iova = region->iova;
> > +
> > +       mutex_lock(&pdata->lock);
> > +       ret = afu_dma_region_add(pdata, region);
> > +       mutex_unlock(&pdata->lock);
> > +       if (ret) {
> > +               dev_err(&pdata->dev->dev, "fail to add dma region\n");
> > +               goto unmap_dma;
> > +       }
> > +
> > +       return 0;
> > +
> > +unmap_dma:
> > +       dma_unmap_page(fpga_pdata_to_pcidev(pdata),
> > +                      region->iova, region->length, DMA_BIDIRECTIONAL);
> > +unpin_pages:
> > +       afu_dma_unpin_pages(pdata, region);
> > +free_region:
> > +       kfree(region);
> > +       return ret;
> > +}
> > +
> > +long afu_dma_unmap_region(struct feature_platform_data *pdata, u64 iova)
> > +{
> > +       struct fpga_afu_dma_region *region;
> > +
> > +       mutex_lock(&pdata->lock);
> > +       region = afu_dma_region_find_iova(pdata, iova);
> > +       if (!region) {
> > +               mutex_unlock(&pdata->lock);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (region->in_use) {
> > +               mutex_unlock(&pdata->lock);
> > +               return -EBUSY;
> > +       }
> > +
> > +       afu_dma_region_remove(pdata, region);
> > +       mutex_unlock(&pdata->lock);
> > +
> > +       dma_unmap_page(fpga_pdata_to_pcidev(pdata),
> > +                      region->iova, region->length, DMA_BIDIRECTIONAL);
> > +       afu_dma_unpin_pages(pdata, region);
> > +       kfree(region);
> > +
> > +       return 0;
> > +}
> > diff --git a/drivers/fpga/intel-afu-main.c b/drivers/fpga/intel-afu-main.c
> > index 8c7aa70..d9f1ebf 100644
> > --- a/drivers/fpga/intel-afu-main.c
> > +++ b/drivers/fpga/intel-afu-main.c
> > @@ -175,7 +175,11 @@ static int afu_release(struct inode *inode, struct file *filp)
> >
> >         dev_dbg(&pdev->dev, "Device File Release\n");
> >
> > -       fpga_port_reset(pdev);
> > +       mutex_lock(&pdata->lock);
> > +       __fpga_port_reset(pdev);
> > +       afu_dma_region_destroy(pdata);
> > +       mutex_unlock(&pdata->lock);
> > +
> >         feature_dev_use_end(pdata);
> >         return 0;
> >  }
> > @@ -245,6 +249,55 @@ static long afu_ioctl_check_extension(struct feature_platform_data *pdata,
> >         return 0;
> >  }
> >
> > +static long
> > +afu_ioctl_dma_map(struct feature_platform_data *pdata, void __user *arg)
> > +{
> > +       struct fpga_port_dma_map map;
> > +       unsigned long minsz;
> > +       long ret;
> > +
> > +       minsz = offsetofend(struct fpga_port_dma_map, iova);
> > +
> > +       if (copy_from_user(&map, arg, minsz))
> 
> Why are you using offsetofend() instead of sizeof(map)?  Is this
> struct going to expand beyond iova?  Also below in one place.

Yes, we just want to make these ioctls extendable.

Actually this is following the same style as vfio. Here is one reference
case in vfio[1]. Define some new flags and introduce new members in newer
version API data structure, and new version driver still works with the
applications using old version API data structure. : )

And other ioctls in intel fpga device drivers are using the same style too.

[1] http://marc.info/?l=linux-kernel&m=143348624325058&w=2

> > +               return -EFAULT;
> > +
> > +       if (map.argsz < minsz || map.flags)
> > +               return -EINVAL;
> > +
> > +       ret = afu_dma_map_region(pdata, map.user_addr, map.length, &map.iova);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (copy_to_user(arg, &map, sizeof(map))) {
> > +               afu_dma_unmap_region(pdata, map.iova);
> > +               return -EFAULT;
> > +       }
> > +
> > +       dev_dbg(&pdata->dev->dev, "dma map: ua=%llx, len=%llx, iova=%llx\n",
> > +                               (unsigned long long)map.user_addr,
> > +                               (unsigned long long)map.length,
> > +                               (unsigned long long)map.iova);
> > +
> > +       return 0;
> > +}
> > +
> > +static long
> > +afu_ioctl_dma_unmap(struct feature_platform_data *pdata, void __user *arg)
> > +{
> > +       struct fpga_port_dma_unmap unmap;
> > +       unsigned long minsz;
> > +
> > +       minsz = offsetofend(struct fpga_port_dma_unmap, iova);
> 
> Here as well.

Same as above.

Thanks
Hao
 
> 
> > +
> > +       if (copy_from_user(&unmap, arg, minsz))
> > +               return -EFAULT;
> > +
> > +       if (unmap.argsz < minsz || unmap.flags)
> > +               return -EINVAL;
> > +
> > +       return afu_dma_unmap_region(pdata, unmap.iova);
> > +}
> > +
> >  static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  {
> >         struct platform_device *pdev = filp->private_data;
> > @@ -263,6 +316,10 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >                 return afu_ioctl_get_info(pdata, (void __user *)arg);
> >         case FPGA_PORT_GET_REGION_INFO:
> >                 return afu_ioctl_get_region_info(pdata, (void __user *)arg);
> > +       case FPGA_PORT_DMA_MAP:
> > +               return afu_ioctl_dma_map(pdata, (void __user *)arg);
> > +       case FPGA_PORT_DMA_UNMAP:
> > +               return afu_ioctl_dma_unmap(pdata, (void __user *)arg);
> >         default:
> >                 /*
> >                  * Let sub-feature's ioctl function to handle the cmd
> > @@ -337,6 +394,7 @@ static int afu_dev_init(struct platform_device *pdev)
> >         mutex_lock(&pdata->lock);
> >         fpga_pdata_set_private(pdata, afu);
> >         afu_region_init(pdata);
> > +       afu_dma_region_init(pdata);
> >         mutex_unlock(&pdata->lock);
> >         return 0;
> >  }
> > @@ -349,6 +407,7 @@ static int afu_dev_destroy(struct platform_device *pdev)
> >         mutex_lock(&pdata->lock);
> >         afu = fpga_pdata_get_private(pdata);
> >         afu_region_destroy(pdata);
> > +       afu_dma_region_destroy(pdata);
> >         fpga_pdata_set_private(pdata, NULL);
> >         mutex_unlock(&pdata->lock);
> >
> > diff --git a/drivers/fpga/intel-afu.h b/drivers/fpga/intel-afu.h
> > index 3417780d..23f7e24 100644
> > --- a/drivers/fpga/intel-afu.h
> > +++ b/drivers/fpga/intel-afu.h
> > @@ -30,11 +30,21 @@ struct fpga_afu_region {
> >         struct list_head node;
> >  };
> >
> > +struct fpga_afu_dma_region {
> > +       u64 user_addr;
> > +       u64 length;
> > +       u64 iova;
> > +       struct page **pages;
> > +       struct rb_node node;
> > +       bool in_use;
> > +};
> > +
> >  struct fpga_afu {
> >         u64 region_cur_offset;
> >         int num_regions;
> >         u8 num_umsgs;
> >         struct list_head regions;
> > +       struct rb_root dma_regions;
> >
> >         struct feature_platform_data *pdata;
> >  };
> > @@ -49,4 +59,12 @@ int afu_get_region_by_offset(struct feature_platform_data *pdata,
> >                             u64 offset, u64 size,
> >                             struct fpga_afu_region *pregion);
> >
> > +void afu_dma_region_init(struct feature_platform_data *pdata);
> > +void afu_dma_region_destroy(struct feature_platform_data *pdata);
> > +long afu_dma_map_region(struct feature_platform_data *pdata,
> > +                      u64 user_addr, u64 length, u64 *iova);
> > +long afu_dma_unmap_region(struct feature_platform_data *pdata, u64 iova);
> > +struct fpga_afu_dma_region *afu_dma_region_find(
> > +               struct feature_platform_data *pdata, u64 iova, u64 size);
> > +
> >  #endif
> > diff --git a/include/uapi/linux/intel-fpga.h b/include/uapi/linux/intel-fpga.h
> > index a2ad332..b97ea02 100644
> > --- a/include/uapi/linux/intel-fpga.h
> > +++ b/include/uapi/linux/intel-fpga.h
> > @@ -111,6 +111,43 @@ struct fpga_port_region_info {
> >
> >  #define FPGA_PORT_GET_REGION_INFO      _IO(FPGA_MAGIC, PORT_BASE + 2)
> >
> > +/**
> > + * FPGA_PORT_DMA_MAP - _IOWR(FPGA_MAGIC, PORT_BASE + 3,
> > + *                                             struct fpga_port_dma_map)
> > + *
> > + * Map the dma memory per user_addr and length which are provided by caller.
> > + * Driver fills the iova in provided struct afu_port_dma_map.
> > + * This interface only accepts page-size aligned user memory for dma mapping.
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +struct fpga_port_dma_map {
> > +       /* Input */
> > +       __u32 argsz;            /* Structure length */
> > +       __u32 flags;            /* Zero for now */
> > +       __u64 user_addr;        /* Process virtual address */
> > +       __u64 length;           /* Length of mapping (bytes)*/
> > +       /* Output */
> > +       __u64 iova;             /* IO virtual address */
> > +};
> > +
> > +#define FPGA_PORT_DMA_MAP      _IO(FPGA_MAGIC, PORT_BASE + 3)
> > +
> > +/**
> > + * FPGA_PORT_DMA_UNMAP - _IOW(FPGA_MAGIC, PORT_BASE + 4,
> > + *                                             struct fpga_port_dma_unmap)
> > + *
> > + * Unmap the dma memory per iova provided by caller.
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +struct fpga_port_dma_unmap {
> > +       /* Input */
> > +       __u32 argsz;            /* Structure length */
> > +       __u32 flags;            /* Zero for now */
> > +       __u64 iova;             /* IO virtual address */
> > +};
> > +
> > +#define FPGA_PORT_DMA_UNMAP    _IO(FPGA_MAGIC, PORT_BASE + 4)
> > +
> >  /* IOCTLs for FME file descriptor */
> >
> >  /**
> > --
> > 1.8.3.1
> >
