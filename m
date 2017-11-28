From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 28 Nov 2017 14:32:17 +0100
Message-ID: <20171128133217.GA29995@kroah.com>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: devel@driverdev.osuosl.org, linux-api@vger.kernel.org, arve@android.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, riandrews@android.com, broonie@kernel.org, sumit.semwal@linaro.org, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org

On Mon, Nov 06, 2017 at 04:59:45PM +0100, Benjamin Gaignard wrote:
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
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  drivers/staging/android/TODO            |  1 -
>  drivers/staging/android/ion/Kconfig     |  7 ++++
>  drivers/staging/android/ion/ion-ioctl.c | 18 ++++++++--
>  drivers/staging/android/ion/ion.c       | 62 +++++++++++++++++++++++++++++----
>  drivers/staging/android/ion/ion.h       | 15 ++++++--
>  5 files changed, 91 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/android/TODO b/drivers/staging/android/TODO
> index 687e0ea..8a11931 100644
> --- a/drivers/staging/android/TODO
> +++ b/drivers/staging/android/TODO
> @@ -8,7 +8,6 @@ TODO:
>  ion/
>   - Add dt-bindings for remaining heaps (chunk and carveout heaps). This would
>     involve putting appropriate bindings in a memory node for Ion to find.
> - - Split /dev/ion up into multiple nodes (e.g. /dev/ion/heap0)
>   - Better test framework (integration with VGEM was suggested)
>  
>  Please send patches to Greg Kroah-Hartman <greg@kroah.com> and Cc:
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

You want to default to Y here, so when you do 'make oldconfig' nothing
breaks, right?

> +	help
> +	  Choose this option to keep using Ion legacy misc device API
> +	  i.e. /dev/ion

You need more text here to describe the trade offs.  Why would I not
want to keep doing this?  What does turning this off get me?  What does
keeping it on keep me from doing?

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

Why return 0?  Because it is already allocated?

Some comments here as to exactly what you are doing would be nice.

> +#endif
> +		if (!(arg->allocation.heap_id_mask & mask))

This doesn't allocate anthing, just check to see if it is?

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
> index fda9756..2c2568b 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -40,6 +40,9 @@
>  
>  #include "ion.h"
>  
> +#define ION_DEV_MAX 32

Why 32?  Where did that number come from?

> +#define ION_NAME "ion"
> +
>  static struct ion_device *internal_dev;
>  static int heap_id;
>  
> @@ -535,15 +538,38 @@ static int debug_shrink_get(void *data, u64 *val)
>  DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
>  			debug_shrink_set, "%llu\n");
>  
> -void ion_device_add_heap(struct ion_heap *heap)
> +static struct device ion_bus = {
> +	.init_name = ION_NAME,
> +};

Oh look, a struct device on the stack.  Watch bad things happen :(

This is a dynamic device, make it dynamic, or else you had better know
exactly what you are doing...

> +
> +static struct bus_type ion_bus_type = {
> +	.name = ION_NAME,
> +};
> +
> +int ion_device_add_heap(struct ion_heap *heap)
>  {
>  	struct dentry *debug_file;
>  	struct ion_device *dev = internal_dev;
> +	int ret = 0;

Why set this to 0?

>  
>  	if (!heap->ops->allocate || !heap->ops->free)
>  		pr_err("%s: can not add heap with invalid ops struct.\n",
>  		       __func__);
>  
> +	if (heap_id >= ION_DEV_MAX)
> +		return -EBUSY;

Busy for an invalid value?

> +
> +	heap->ddev.parent = &ion_bus;
> +	heap->ddev.bus = &ion_bus_type;
> +	heap->ddev.devt = MKDEV(MAJOR(internal_dev->devt), heap_id);
> +	dev_set_name(&heap->ddev, ION_NAME"%d", heap_id);
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
> @@ -581,6 +607,8 @@ void ion_device_add_heap(struct ion_heap *heap)
>  
>  	dev->heap_cnt++;
>  	up_write(&dev->lock);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(ion_device_add_heap);
>  
> @@ -593,8 +621,9 @@ static int ion_device_create(void)
>  	if (!idev)
>  		return -ENOMEM;
>  
> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
>  	idev->dev.minor = MISC_DYNAMIC_MINOR;
> -	idev->dev.name = "ion";
> +	idev->dev.name = ION_NAME;
>  	idev->dev.fops = &ion_fops;
>  	idev->dev.parent = NULL;
>  	ret = misc_register(&idev->dev);
> @@ -603,19 +632,38 @@ static int ion_device_create(void)
>  		kfree(idev);
>  		return ret;
>  	}
> +#endif
>  
> -	idev->debug_root = debugfs_create_dir("ion", NULL);
> -	if (!idev->debug_root) {
> +	ret = device_register(&ion_bus);

You call device_register for something you are calling a bus???  Are you
_sure_ about this?

What exactly are you creating in sysfs here?  You are throwing around
"raw" devices, which is almost never what you ever want to do.
Especially for some random char driver.


> +	if (ret)
> +		goto clean_misc;
> +
> +	ret = bus_register(&ion_bus_type);
> +	if (ret)
> +		goto clean_device;
> +
> +	ret = alloc_chrdev_region(&idev->devt, 0, ION_DEV_MAX, ION_NAME);
> +	if (ret)
> +		goto clean_device;
> +
> +	idev->debug_root = debugfs_create_dir(ION_NAME, NULL);
> +	if (!idev->debug_root)

Why do you care about this?  (hint, never care about any debugfs
call...)

>  		pr_err("ion: failed to create debugfs root directory.\n");
> -		goto debugfs_done;
> -	}
>  
> -debugfs_done:
>  	idev->buffers = RB_ROOT;
>  	mutex_init(&idev->buffer_lock);
>  	init_rwsem(&idev->lock);
>  	plist_head_init(&idev->heaps);
>  	internal_dev = idev;
>  	return 0;
> +
> +clean_device:
> +	device_unregister(&ion_bus);
> +clean_misc:
> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
> +	misc_deregister(&idev->dev);
> +#endif
> +	kfree(idev);
> +	return ret;
>  }
>  subsys_initcall(ion_device_create);
> diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
> index f5f9cd6..4869e96 100644
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

Why do you need a #ifdef here?

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
> @@ -92,12 +95,16 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
>  /**
>   * struct ion_device - the metadata of the ion device node
>   * @dev:		the actual misc device
> + * @devt:		Ion device

devt?  That's not a "device", it's a dev_t, which means something else,
right?

>   * @buffers:		an rb tree of all the existing buffers
>   * @buffer_lock:	lock protecting the tree of buffers
>   * @lock:		rwsem protecting the tree of heaps and clients
>   */
>  struct ion_device {
> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
>  	struct miscdevice dev;
> +#endif

Why use #ifdef?

> +	dev_t devt;
>  	struct rb_root buffers;
>  	struct mutex buffer_lock;
>  	struct rw_semaphore lock;
> @@ -153,6 +160,8 @@ struct ion_heap_ops {
>   * struct ion_heap - represents a heap in the system
>   * @node:		rb node to put the heap on the device's tree of heaps
>   * @dev:		back pointer to the ion_device
> + * @ddev:		device structure

How many different reference counted objects do you now have in this
structure?  And what exactly is the lifetime rules involved in them?

Hint, you never tried removing any of these from the system, otherwise
you would have seen the kernel warnings...

Step back here, what exactly do you want to do?  What do you expect
sysfs to look like?  What do you want /dev/ to look like?

Where is the documentation for the new sysfs files and the new ioctl
call you added?  What did you do to test this out?  Where are the AOSP
patches to use this?  Happen to have a VTS test for it?

This needs a lot more work, if for no other reason than the integration
into the driver model is totally wrong and will blow up into tiny
pieces...

thanks,

greg k-h
