From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC] simple_char: New infrastructure to simplify chardev management
Date: Wed, 25 Mar 2015 17:16:28 -0700
Message-ID: <CALCETrUXgqAY1MzMP80W_YC-zCi3nostJE2sLA+X_U0Xu6hoFw@mail.gmail.com>
References: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Jiri Kosina <jkosina@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

Quick ping: does anyone want to review this?

--Andy

On Tue, Feb 10, 2015 at 3:44 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This isn't adequately tested, and I don't have a demonstration (yet).
> It's here for review for whether it's a good idea in the first place
> and for weather the fully_dynamic mechanism is a good idea.
>
> The current character device interfaces are IMO awful.  There's a
> reservation mechanism (alloc_chrdev_region, etc), a bizarre
> sort-of-hashtable lookup mechanism that character drivers need to
> interact with (cdev_add, etc), and number of lookup stages on open
> with various levels of optimization.  Despite all the code, there's no
> core infrastructure to map from a dev_t back to a kobject, struct
> device, or any other useful device pointer.
>
> This means that lots of drivers need to implement all of this
> themselves.  The drivers don't even all seem to do it right.  For
> example, the UIO code seems to be missing any protection against
> chardev open racing against device removal.
>
> On top of the complexity of writing a chardev driver, the user
> interface is odd.  We have /proc/devices, which nothing should use,
> since it conveys no information about minor numbers, and minors are
> mostly dynamic these days.  Even the major numbers aren't terribly
> useful, since sysfs refers to (major, minor) pairs.
>
> This adds simple helpers simple_char_minor_create and
> simple_char_minor_free to create and destroy chardev minors.  Common
> code handles minor allocation and lookup and provides a simple helper
> to allow (and even mostly require!) users to reference count their
> devices correctly.
>
> Users can either allocation a traditional dynamic major using
> simple_char_major_create, or they can use a global "fully_dynamic"
> major and avoid thinking about major numbers at all.
>
> This currently does not integrate with the driver core at all.
> Users are responsible for plugging the dev_t into their struct
> devices manually.  I couldn't see a clean way to fix this without
> integrating all of this into the driver core.
>
> Thoughts?  I want to use this for the u2f driver, which will either be
> a chardev driver in its own right or use a simple new iso7816 class.
>
> Ideally we could convert a bunch of drivers to use this, at least
> where there are no legacy minor number considerations.
>
> (Note: simple_char users will *not* have their devicename%d indices
> match their minor numbers unless they specifically arrange for this to
> be the case.  For new drivers, this shouldn't be a problem at all.  I
> don't know whether it matters for old drivers.)
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>
>  drivers/base/Makefile       |   2 +-
>  drivers/base/simple_char.c  | 231 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/simple_char.h |  38 ++++++++
>  3 files changed, 270 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/base/simple_char.c
>  create mode 100644 include/linux/simple_char.h
>
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 6922cd6850a2..d3832749f74c 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -4,7 +4,7 @@ obj-y                   := component.o core.o bus.o dd.o syscore.o \
>                            driver.o class.o platform.o \
>                            cpu.o firmware.o init.o map.o devres.o \
>                            attribute_container.o transport_class.o \
> -                          topology.o container.o
> +                          topology.o container.o simple_char.o
>  obj-$(CONFIG_DEVTMPFS) += devtmpfs.o
>  obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
>  obj-y                  += power/
> diff --git a/drivers/base/simple_char.c b/drivers/base/simple_char.c
> new file mode 100644
> index 000000000000..f3205ef9e44b
> --- /dev/null
> +++ b/drivers/base/simple_char.c
> @@ -0,0 +1,231 @@
> +/*
> + * A simple way to create character devices
> + *
> + * Copyright (c) 2015 Andy Lutomirski <luto@amacapital.net>
> + *
> + * Loosely based, somewhat arbitrarily, on the UIO driver, which is one
> + * of many copies of essentially identical boilerplate.
> + *
> + * Licensed under the GPLv2.
> + */
> +
> +#include <linux/simple_char.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/poll.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/mm.h>
> +#include <linux/idr.h>
> +#include <linux/sched.h>
> +#include <linux/string.h>
> +#include <linux/kobject.h>
> +#include <linux/cdev.h>
> +
> +#define MAX_MINORS (1U << MINORBITS)
> +
> +struct simple_char_major {
> +       struct cdev cdev;
> +       unsigned majornum;
> +       struct idr idr;
> +       struct mutex lock;
> +};
> +
> +static struct simple_char_major *fully_dynamic_major;
> +static DEFINE_MUTEX(fully_dynamic_major_lock);
> +
> +static int simple_char_open(struct inode *inode, struct file *filep)
> +{
> +       struct simple_char_major *major =
> +               container_of(inode->i_cdev, struct simple_char_major,
> +                            cdev);
> +       void *private;
> +       const struct simple_char_ops *ops;
> +       int ret = 0;
> +
> +       mutex_lock(&major->lock);
> +
> +       {
> +               /*
> +                * This is a separate block to make the locking entirely
> +                * clear.  The only thing keeping minor alive is major->lock.
> +                * We need to be completely done with the simple_char_minor
> +                * by the time we release the lock.
> +                */
> +               struct simple_char_minor *minor;
> +               minor = idr_find(&major->idr, iminor(inode));
> +               if (!minor || !minor->ops->reference(minor->private)) {
> +                       mutex_unlock(&major->lock);
> +                       return -ENODEV;
> +               }
> +               private = minor->private;
> +               ops = minor->ops;
> +       }
> +
> +       mutex_unlock(&major->lock);
> +
> +       replace_fops(filep, ops->fops);
> +       filep->private_data = private;
> +       if (ops->fops->open)
> +               ret = ops->fops->open(inode, filep);
> +
> +       return ret;
> +}
> +
> +static const struct file_operations simple_char_fops = {
> +       .open = simple_char_open,
> +       .llseek = noop_llseek,
> +};
> +
> +struct simple_char_major *simple_char_major_create(const char *name)
> +{
> +       struct simple_char_major *major = NULL;
> +       dev_t devt;
> +       int ret;
> +
> +       ret = alloc_chrdev_region(&devt, 0, MAX_MINORS, name);
> +       if (ret)
> +               goto out;
> +
> +       ret = -ENOMEM;
> +       major = kmalloc(sizeof(struct simple_char_major), GFP_KERNEL);
> +       if (!major)
> +               goto out_unregister;
> +       cdev_init(&major->cdev, &simple_char_fops);
> +       kobject_set_name(&major->cdev.kobj, "%s", name);
> +
> +       ret = cdev_add(&major->cdev, devt, MAX_MINORS);
> +       if (ret)
> +               goto out_free;
> +
> +       major->majornum = MAJOR(devt);
> +       idr_init(&major->idr);
> +       return major;
> +
> +out_free:
> +       cdev_del(&major->cdev);
> +       kfree(major);
> +out_unregister:
> +       unregister_chrdev_region(devt, MAX_MINORS);
> +out:
> +       return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL(simple_char_major_create);
> +
> +void simple_char_major_free(struct simple_char_major *major)
> +{
> +       BUG_ON(!idr_is_empty(&major->idr));
> +
> +       cdev_del(&major->cdev);
> +       unregister_chrdev_region(MKDEV(major->majornum, 0), MAX_MINORS);
> +       idr_destroy(&major->idr);
> +       kfree(major);
> +}
> +
> +static struct simple_char_major *get_fully_dynamic_major(void)
> +{
> +       struct simple_char_major *major =
> +               smp_load_acquire(&fully_dynamic_major);
> +       if (major)
> +               return major;
> +
> +       mutex_lock(&fully_dynamic_major_lock);
> +
> +       if (fully_dynamic_major) {
> +               major = fully_dynamic_major;
> +               goto out;
> +       }
> +
> +       major = simple_char_major_create("fully_dynamic");
> +       if (!IS_ERR(major))
> +               smp_store_release(&fully_dynamic_major, major);
> +
> +out:
> +       mutex_unlock(&fully_dynamic_major_lock);
> +       return major;
> +
> +}
> +
> +/**
> + * simple_char_minor_create() - create a chardev minor
> + * @major:     Major to use or NULL for a fully dynamic chardev.
> + * @ops:       simple_char_ops to associate with the minor.
> + * @private:   opaque pointer for @ops's use.
> + *
> + * simple_char_minor_create() creates a minor chardev.  For new code,
> + * @major should be NULL; this will create a minor chardev with fully
> + * dynamic major and minor numbers and without a useful name in
> + * /proc/devices.  (All recent user code should be using sysfs
> + * exclusively to map between devices and device numbers.)  For legacy
> + * code, @major can come from simple_char_major_create().
> + *
> + * The chardev will use @ops->fops for its file operations.  Before any
> + * of those operations are called, the struct file's private_data will
> + * be set to @private.
> + *
> + * To simplify reference counting, @ops->reference will be called before
> + * @ops->fops->open.  @ops->reference should take any needed references
> + * and return true if the object being opened still exists, and it
> + * should return false without taking references if the object is dying.
> + * @ops->reference is called with locks held, so it should neither sleep
> + * nor take heavy locks.
> + *
> + * @ops->fops->release (and @ops->fops->open, if it exists and fails)
> + * are responsible for releasing any references takes by @ops->reference.
> + *
> + * The minor must be destroyed by @simple_char_minor_free.  After
> + * @simple_char_minor_free returns, @ops->reference will not be called.
> + */
> +struct simple_char_minor *
> +simple_char_minor_create(struct simple_char_major *major,
> +                        const struct simple_char_ops *ops,
> +                        void *private)
> +{
> +       int ret;
> +       struct simple_char_minor *minor = NULL;
> +
> +       if (!major) {
> +               major = get_fully_dynamic_major();
> +               if (IS_ERR(major))
> +                       return (void *)major;
> +       }
> +
> +       minor = kmalloc(sizeof(struct simple_char_minor), GFP_KERNEL);
> +       if (!minor)
> +               return ERR_PTR(-ENOMEM);
> +
> +       mutex_lock(&major->lock);
> +       ret = idr_alloc(&major->idr, minor, 0, MAX_MINORS, GFP_KERNEL);
> +       if (ret >= 0) {
> +               minor->devt = MKDEV(major->majornum, ret);
> +               ret = 0;
> +       }
> +       /* Warn on ENOSPC?  It's embarrassing if it ever happens. */
> +       mutex_unlock(&major->lock);
> +
> +       if (ret) {
> +               kfree(minor);
> +               return ERR_PTR(ret);
> +       }
> +
> +       minor->major = major;
> +       minor->private = private;
> +       minor->ops = ops;
> +       return minor;
> +}
> +
> +/**
> + * simple_char_minor_free() - Free a simple_char chardev minor
> + * @minor:     the minor to free.
> + *
> + * This frees a chardev minor and prevents that minor's @ops->reference
> + * op from being called in the future.
> + */
> +void simple_char_minor_free(struct simple_char_minor *minor)
> +{
> +       mutex_lock(&minor->major->lock);
> +       idr_remove(&minor->major->idr, MINOR(minor->devt));
> +       mutex_unlock(&minor->major->lock);
> +       kfree(minor);
> +}
> +EXPORT_SYMBOL(simple_char_minor_free);
> diff --git a/include/linux/simple_char.h b/include/linux/simple_char.h
> new file mode 100644
> index 000000000000..8f391e7b50af
> --- /dev/null
> +++ b/include/linux/simple_char.h
> @@ -0,0 +1,38 @@
> +/*
> + * A simple way to create character devices
> + *
> + * Copyright (c) 2015 Andy Lutomirski <luto@amacapital.net>
> + *
> + * Licensed under the GPLv2.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/kobject.h>
> +#include <linux/file.h>
> +
> +struct simple_char_major;
> +
> +struct simple_char_ops {
> +       bool (*reference)(void *private);
> +       const struct file_operations *fops;
> +};
> +
> +struct simple_char_minor {
> +       struct simple_char_major *major;
> +       const struct simple_char_ops *ops;
> +       void *private;
> +       dev_t devt;
> +};
> +
> +extern struct simple_char_minor *
> +simple_char_minor_create(struct simple_char_major *major,
> +                        const struct simple_char_ops *ops,
> +                        void *private);
> +extern void simple_char_minor_free(struct simple_char_minor *minor);
> +
> +extern void simple_char_file_release(struct file *filep, struct kobject *kobj);
> +
> +/* These exist only to support legacy classes that need their own major. */
> +extern struct simple_char_major *simple_char_major_create(const char *name);
> +extern void simple_char_major_free(struct simple_char_major *major);
> +
> --
> 2.1.0
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
