From: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Mon, 2 Oct 2017 11:07:48 -0700
Message-ID: <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506518409-16887-3-git-send-email-benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/27/2017 06:20 AM, Benjamin Gaignard wrote:
> Instead a getting only one common device "/dev/ion" for
> all the heaps this patch allow to create one device
> entry ("/dev/ionX") per heap.
> Getting an entry per heap could allow to set security rules
> per heap and global ones for all heaps.
> 
> Allocation requests will be only allowed if the mask_id
> match with device minor.
> Query request could be done on any of the devices.
>
Thinking about this a bit more, I'm not 100% sure if this
will allow the security rules we want. Heap ids are assigned
dynamically and therefore so will the /dev/ionX designation.
>From my understanding, security rules like selinux need to
be fully specified at boot time so I'm not sure how you would
be able to write rules to differentiate between /dev/ionX and
/dev/ionY without knowing the values at boottime.

So I think we need a different way to match the heap ids to
get the security we want unless my understanding of security
policies is wrong and we can dynamically specify permissions.

Thanks,
Laura
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> version 5:
> - create a configuration flag to keep legacy Ion misc device
> 
> version 4:
> - add a configuration flag to switch between legacy Ion misc device
>   and one device per heap version.
> 
> version 3:
> - change ion_device_add_heap prototype to return a possible error.
> 
> version 2:
> - simplify ioctl check like propose by Dan
> - make sure that we don't register more than ION_DEV_MAX heaps.
> 
>  drivers/staging/android/TODO            |  1 -
>  drivers/staging/android/ion/Kconfig     |  7 +++++++
>  drivers/staging/android/ion/ion-ioctl.c | 18 ++++++++++++++++--
>  drivers/staging/android/ion/ion.c       | 31 ++++++++++++++++++++++++++++++-
>  drivers/staging/android/ion/ion.h       | 15 +++++++++++++--
>  5 files changed, 66 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/android/TODO b/drivers/staging/android/TODO
> index 5f14247..d770ffa 100644
> --- a/drivers/staging/android/TODO
> +++ b/drivers/staging/android/TODO
> @@ -9,7 +9,6 @@ TODO:
>  ion/
>   - Add dt-bindings for remaining heaps (chunk and carveout heaps). This would
>     involve putting appropriate bindings in a memory node for Ion to find.
> - - Split /dev/ion up into multiple nodes (e.g. /dev/ion/heap0)
>   - Better test framework (integration with VGEM was suggested)
>  
>  Please send patches to Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> and Cc:
> diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
> index a517b2d..cb4666e 100644
> --- a/drivers/staging/android/ion/Kconfig
> +++ b/drivers/staging/android/ion/Kconfig
> @@ -10,6 +10,13 @@ menuconfig ION
>  	  If you're not using Android its probably safe to
>  	  say N here.
>  
> +config ION_LEGACY_DEVICE_API
> +	bool "Keep using Ion legacy misc device API"
> +	depends on ION
> +	help
> +	  Choose this option to keep using Ion legacy misc device API
> +	  i.e. /dev/ion
> +
>  config ION_SYSTEM_HEAP
>  	bool "Ion system heap"
>  	depends on ION
> diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
> index e26b786..bb5c77b 100644
> --- a/drivers/staging/android/ion/ion-ioctl.c
> +++ b/drivers/staging/android/ion/ion-ioctl.c
> @@ -25,7 +25,8 @@ union ion_ioctl_arg {
>  	struct ion_heap_query query;
>  };
>  
> -static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
> +static int validate_ioctl_arg(struct file *filp,
> +			      unsigned int cmd, union ion_ioctl_arg *arg)
>  {
>  	switch (cmd) {
>  	case ION_IOC_HEAP_QUERY:
> @@ -34,6 +35,19 @@ static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
>  		    arg->query.reserved2 )
>  			return -EINVAL;
>  		break;
> +
> +	case ION_IOC_ALLOC:
> +	{
> +		int mask = 1 << iminor(filp->f_inode);
> +
> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
> +		if (imajor(filp->f_inode) == MISC_MAJOR)
> +			return 0;
> +#endif
> +		if (!(arg->allocation.heap_id_mask & mask))
> +			return -EINVAL;
> +		break;
> +	}
>  	default:
>  		break;
>  	}
> @@ -69,7 +83,7 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
>  		return -EFAULT;
>  
> -	ret = validate_ioctl_arg(cmd, &data);
> +	ret = validate_ioctl_arg(filp, cmd, &data);
>  	if (WARN_ON_ONCE(ret))
>  		return ret;
>  
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 93e2c90..092b24c 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -40,6 +40,8 @@
>  
>  #include "ion.h"
>  
> +#define ION_DEV_MAX 32
> +
>  static struct ion_device *internal_dev;
>  static int heap_id;
>  
> @@ -537,15 +539,28 @@ static int debug_shrink_get(void *data, u64 *val)
>  DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
>  			debug_shrink_set, "%llu\n");
>  
> -void ion_device_add_heap(struct ion_heap *heap)
> +int ion_device_add_heap(struct ion_heap *heap)
>  {
>  	struct dentry *debug_file;
>  	struct ion_device *dev = internal_dev;
> +	int ret = 0;
>  
>  	if (!heap->ops->allocate || !heap->ops->free)
>  		pr_err("%s: can not add heap with invalid ops struct.\n",
>  		       __func__);
>  
> +	if (heap_id >= ION_DEV_MAX)
> +		return -EBUSY;
> +
> +	heap->ddev.devt = MKDEV(MAJOR(dev->devt), heap_id);
> +	dev_set_name(&heap->ddev, "ion%d", heap_id);
> +	device_initialize(&heap->ddev);
> +	cdev_init(&heap->chrdev, &ion_fops);
> +	heap->chrdev.owner = THIS_MODULE;
> +	ret = cdev_device_add(&heap->chrdev, &heap->ddev);
> +	if (ret < 0)
> +		return ret;
> +
>  	spin_lock_init(&heap->free_lock);
>  	heap->free_list_size = 0;
>  
> @@ -583,6 +598,8 @@ void ion_device_add_heap(struct ion_heap *heap)
>  
>  	dev->heap_cnt++;
>  	up_write(&dev->lock);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(ion_device_add_heap);
>  
> @@ -595,6 +612,7 @@ static int ion_device_create(void)
>  	if (!idev)
>  		return -ENOMEM;
>  
> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
>  	idev->dev.minor = MISC_DYNAMIC_MINOR;
>  	idev->dev.name = "ion";
>  	idev->dev.fops = &ion_fops;
> @@ -605,6 +623,17 @@ static int ion_device_create(void)
>  		kfree(idev);
>  		return ret;
>  	}
> +#endif
> +
> +	ret = alloc_chrdev_region(&idev->devt, 0, ION_DEV_MAX, "ion");
> +	if (ret) {
> +		pr_err("ion: unable to allocate device\n");
> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
> +		misc_deregister(&idev->dev);
> +#endif
> +		kfree(idev);
> +		return ret;
> +	}
>  
>  	idev->debug_root = debugfs_create_dir("ion", NULL);
>  	if (!idev->debug_root) {
> diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
> index 621e5f7..2b00ccb 100644
> --- a/drivers/staging/android/ion/ion.h
> +++ b/drivers/staging/android/ion/ion.h
> @@ -17,16 +17,19 @@
>  #ifndef _ION_H
>  #define _ION_H
>  
> +#include <linux/cdev.h>
>  #include <linux/device.h>
>  #include <linux/dma-direction.h>
>  #include <linux/kref.h>
> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
> +#include <linux/miscdevice.h>
> +#endif
>  #include <linux/mm_types.h>
>  #include <linux/mutex.h>
>  #include <linux/rbtree.h>
>  #include <linux/sched.h>
>  #include <linux/shrinker.h>
>  #include <linux/types.h>
> -#include <linux/miscdevice.h>
>  
>  #include "../uapi/ion.h"
>  
> @@ -91,12 +94,16 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
>  /**
>   * struct ion_device - the metadata of the ion device node
>   * @dev:		the actual misc device
> + * @devt:		Ion device
>   * @buffers:		an rb tree of all the existing buffers
>   * @buffer_lock:	lock protecting the tree of buffers
>   * @lock:		rwsem protecting the tree of heaps and clients
>   */
>  struct ion_device {
> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
>  	struct miscdevice dev;
> +#endif
> +	dev_t devt;
>  	struct rb_root buffers;
>  	struct mutex buffer_lock;
>  	struct rw_semaphore lock;
> @@ -152,6 +159,8 @@ struct ion_heap_ops {
>   * struct ion_heap - represents a heap in the system
>   * @node:		rb node to put the heap on the device's tree of heaps
>   * @dev:		back pointer to the ion_device
> + * @ddev:		device structure
> + * @chrdev:		associated character device
>   * @type:		type of heap
>   * @ops:		ops struct as above
>   * @flags:		flags
> @@ -176,6 +185,8 @@ struct ion_heap_ops {
>  struct ion_heap {
>  	struct plist_node node;
>  	struct ion_device *dev;
> +	struct device ddev;
> +	struct cdev chrdev;
>  	enum ion_heap_type type;
>  	struct ion_heap_ops *ops;
>  	unsigned long flags;
> @@ -212,7 +223,7 @@ bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer);
>   * ion_device_add_heap - adds a heap to the ion device
>   * @heap:		the heap to add
>   */
> -void ion_device_add_heap(struct ion_heap *heap);
> +int ion_device_add_heap(struct ion_heap *heap);
>  
>  /**
>   * some helpers for common operations on buffers using the sg_table
> 
