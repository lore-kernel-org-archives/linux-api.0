From: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC simple allocator v2 1/2] Create Simple Allocator module
Date: Wed, 15 Feb 2017 09:41:54 +0100
Message-ID: <CA+M3ks6pj6OKxy_CBkQW1JCGcmsSvcAU17YdSChLCt0Hq3pibw@mail.gmail.com>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
 <1486997106-23277-2-git-send-email-benjamin.gaignard@linaro.org> <4441232.4RNTQKa4zP@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4441232.4RNTQKa4zP@avalon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: Linaro Kernel Mailman List <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2017-02-14 20:30 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonboard.=
com>:
> Hi Benjamin,
>
> Thank you for the patch. I've CC'ed the linux-api mailing list.
>
> On Monday 13 Feb 2017 15:45:05 Benjamin Gaignard wrote:
>> This is the core of simple allocator module.
>> It aim to offert one common ioctl to allocate specific memory.
>>
>> version 2:
>> - rebased on 4.10-rc7
>>
>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  Documentation/simple-allocator.txt              |  81 +++++++++++
>>  drivers/Kconfig                                 |   2 +
>>  drivers/Makefile                                |   1 +
>>  drivers/simpleallocator/Kconfig                 |  10 ++
>>  drivers/simpleallocator/Makefile                |   1 +
>>  drivers/simpleallocator/simple-allocator-priv.h |  33 +++++
>>  drivers/simpleallocator/simple-allocator.c      | 180 +++++++++++++++++=
++++
>>  include/uapi/linux/simple-allocator.h           |  35 +++++
>>  8 files changed, 343 insertions(+)
>>  create mode 100644 Documentation/simple-allocator.txt
>>  create mode 100644 drivers/simpleallocator/Kconfig
>>  create mode 100644 drivers/simpleallocator/Makefile
>>  create mode 100644 drivers/simpleallocator/simple-allocator-priv.h
>>  create mode 100644 drivers/simpleallocator/simple-allocator.c
>>  create mode 100644 include/uapi/linux/simple-allocator.h
>>
>> diff --git a/Documentation/simple-allocator.txt
>> b/Documentation/simple-allocator.txt new file mode 100644
>> index 0000000..89ba883
>> --- /dev/null
>> +++ b/Documentation/simple-allocator.txt
>> @@ -0,0 +1,81 @@
>> +Simple Allocator Framework
>
> There's nothing simple in buffer allocation, otherwise we would have solv=
ed
> the problem a long time ago. Let's not use a misleading name.

Simple was not about the problem, it was about the using only one ioctl.
Anyway a better name is needed: "Limited allocation API", "Basic
allocator framework" ?
suggestions are welcomes

>
>> +Simple Allocator offer a single ioctl SA_IOC_ALLOC to allocate buffers
>> +on dedicated memory regions and export them as a dmabuf file descriptor=
.
>> +Using dmabuf file descriptor allow to share this memory between process=
es
>> +and/or import it into other frameworks like v4l2 or drm/kms (prime).
>> +When userland wants to free the memory only a call to close() in needed
>> +so it could done even without knowing that buffer has been allocated by
>> +simple allocator ioctl.
>> +
>> +Each memory regions will be seen as a filein /dev/.
>> +For example CMA regions will exposed has /dev/cmaX.
>
> Why do you need multiple devices ? Furthermore, given how central this AP=
I
> will become, I believe it needs very strict review, and would be a candid=
ate
> for a syscall.

I believe that having a device per memory regions is simple than have havin=
g,
like ION, heaps which request to add masks (or heap ids) to select them.
My goal here is not to have a a central device /dev/simple_allocator
where allcoations
are dispatched over heaps but only a common ioctl to make userland life eas=
ier.
Maybe I should regroup all the device under the same directory: /dev/simple=
/ ?

>
> Without diving into details yet, there are a few particular points I'm
> concerned about.
>
> - What is the scope of this API ? What problems do you want to solve, pla=
n to
> solve in the future, and consider as out of scope ?

My problem is to be able to allocate a buffer in contiguous memory
(CMA) when using
a software decoder and Weston. This will save the copy between decoder
and display
because display only accepted contiguous memory.
Wayland dmabuf protocol can't allocate buffers so I need an other way
to get access to CMA.
I also other use cases where I need to allocate memory in special
memory region for secure
purpose.

For those both cases I need an API to allocate memory from userland so
I decided to
propose a common ioctl which may be used for even more memory regions.

>
> - How should we handle permissions and resource limits ? Is file-based
> permission on a device node a good model ? How do we prevent or at least
> mitigate memory-related DoS ?

Since each memory region will be represented by a device we could set per
device permissions for example with SELinux policy.

>
> - How should such a central allocator API interact with containers and
> virtualization in general ?

I'm not expert enough in container and virtualization but I know they could=
 have
access to some files/directories to store data so I guess it will
possible for them
to call (for example) /dev/cma0  to allocate memory

> - What model do we want to expose to applications to select a memory type=
 ?
> You still haven't convinced me that we should expose memory pools explici=
tly
> to application (=C3=A0 la ION), and I believe a usage/constraint model wo=
uld be
> better.

Memory type selection should be solved by something more smarter than my co=
de.
My goal here is only to provided a common way to perform allocations.
If  "Unix Device Memory Allocator" project manage to define a way to expose
memory constraint I plan to add one ioctl to let it know the
capabilities of each memory region.
I hope that what I'm proposing could become a backend for "Unix Device
Memory Allocator".

>
>> +Implementing a simple allocator
>> +-------------------------------
>> +
>> +Simple Allocator provide helpers functions to register/unregister an
>> +allocator:
>> +- simple_allocator_register(struct sa_device *sadev)
>> +  Register simple_allocator_device using sa_device structure where name=
,
>> +  owner and allocate fields must be set.
>> +
>> +- simple_allocator_unregister(struct sa_device *sadev)
>> +  Unregister a simple allocator device.
>> +
>> +Using Simple Allocator /dev interface example
>> +---------------------------------------------
>> +
>> +This example of code allocate a buffer on the first CMA region (/dev/cm=
a0)
>> +before mmap and close it.
>> +
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <sys/ioctl.h>
>> +#include <sys/mman.h>
>> +#include <sys/stat.h>
>> +#include <sys/types.h>
>> +
>> +#include "simple-allocator.h"
>> +
>> +#define LENGTH 1024*16
>> +
>> +void main (void)
>> +{
>> +     struct simple_allocate_data data;
>> +     int fd =3D open("/dev/cma0", O_RDWR, 0);
>> +     int ret;
>> +     void *mem;
>> +
>> +     if (fd < 0) {
>> +             printf("Can't open /dev/cma0\n");
>> +             return;
>> +     }
>> +
>> +     memset(&data, 0, sizeof(data));
>> +
>> +     data.length =3D LENGTH;
>> +     data.flags =3D O_RDWR | O_CLOEXEC;
>> +
>> +     ret =3D ioctl(fd, SA_IOC_ALLOC, &data);
>> +     if (ret) {
>> +             printf("Buffer allocation failed\n");
>> +             goto end;
>> +     }
>> +
>> +     mem =3D mmap(0, LENGTH, PROT_READ | PROT_WRITE, MAP_SHARED, data.f=
d, 0);
>> +     if (mem =3D=3D MAP_FAILED) {
>> +             printf("mmap failed\n");
>> +     }
>> +
>> +     memset(mem, 0xFF, LENGTH);
>> +     munmap(mem, LENGTH);
>> +
>> +     printf("test simple allocator CMA OK\n");
>> +end:
>> +     close(fd);
>> +}
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index e1e2066..a6d8828 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -202,4 +202,6 @@ source "drivers/hwtracing/intel_th/Kconfig"
>>
>>  source "drivers/fpga/Kconfig"
>>
>> +source "drivers/simpleallocator/Kconfig"
>> +
>>  endmenu
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 060026a..5081eb8 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -173,3 +173,4 @@ obj-$(CONFIG_STM)         +=3D hwtracing/stm/
>>  obj-$(CONFIG_ANDROID)                +=3D android/
>>  obj-$(CONFIG_NVMEM)          +=3D nvmem/
>>  obj-$(CONFIG_FPGA)           +=3D fpga/
>> +obj-$(CONFIG_SIMPLE_ALLOCATOR)       +=3D simpleallocator/
>> diff --git a/drivers/simpleallocator/Kconfig
>> b/drivers/simpleallocator/Kconfig new file mode 100644
>> index 0000000..c6fc2e3
>> --- /dev/null
>> +++ b/drivers/simpleallocator/Kconfig
>> @@ -0,0 +1,10 @@
>> +menu "Simple Allocator"
>> +
>> +config SIMPLE_ALLOCATOR
>> +     tristate "Simple Alllocator Framework"
>> +     select DMA_SHARED_BUFFER
>> +     ---help---
>> +        The Simple Allocator Framework adds an API to allocate and shar=
e
>> +        memory in userland.
>> +
>> +endmenu
>> diff --git a/drivers/simpleallocator/Makefile
>> b/drivers/simpleallocator/Makefile new file mode 100644
>> index 0000000..e27c6ad
>> --- /dev/null
>> +++ b/drivers/simpleallocator/Makefile
>> @@ -0,0 +1 @@
>> +obj-$(CONFIG_SIMPLE_ALLOCATOR) +=3D simple-allocator.o
>> diff --git a/drivers/simpleallocator/simple-allocator-priv.h
>> b/drivers/simpleallocator/simple-allocator-priv.h new file mode 100644
>> index 0000000..33f5a33
>> --- /dev/null
>> +++ b/drivers/simpleallocator/simple-allocator-priv.h
>> @@ -0,0 +1,33 @@
>> +/*
>> + * Copyright (C) Linaro 2016
>> + *
>> + * Author: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + *
>> + * License terms:  GNU General Public License (GPL)
>> + */
>> +
>> +#ifndef _SIMPLE_ALLOCATOR_PRIV_H_
>> +#define _SIMPLE_ALLOCATOR_PRIV_H_
>> +
>> +#include <linux/cdev.h>
>> +#include <linux/device.h>
>> +#include <linux/dma-buf.h>
>> +
>> +/**
>> + * struct sa_device - simple allocator device
>> + * @owner: module owner, must be set to THIS_MODULE
>> + * @name: name of the allocator
>> + * @allocate: callabck for memory allocation
>> + */
>> +struct sa_device {
>> +     struct device   dev;
>> +     struct cdev     chrdev;
>> +     struct module   *owner;
>> +     const char      *name;
>> +     struct dma_buf *(*allocate)(struct sa_device *, u64 length, u32
> flags);
>> +};
>> +
>> +int simple_allocator_register(struct sa_device *sadev);
>> +void simple_allocator_unregister(struct sa_device *sadev);
>> +
>> +#endif
>> diff --git a/drivers/simpleallocator/simple-allocator.c
>> b/drivers/simpleallocator/simple-allocator.c new file mode 100644
>> index 0000000..d89ccbf
>> --- /dev/null
>> +++ b/drivers/simpleallocator/simple-allocator.c
>> @@ -0,0 +1,180 @@
>> +/*
>> + * Copyright (C) Linaro 2016
>> + *
>> + * Author: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + *
>> + * License terms:  GNU General Public License (GPL)
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/simple-allocator.h>
>> +#include <linux/uaccess.h>
>> +
>> +#include "simple-allocator-priv.h"
>> +
>> +#define SA_MAJOR     222
>> +#define SA_NUM_DEVICES       256
>> +#define SA_NAME              "simple_allocator"
>> +
>> +static int sa_minor;
>> +
>> +static struct class sa_class =3D {
>> +     .name =3D SA_NAME,
>> +};
>> +
>> +static long sa_ioctl(struct file *filp, unsigned int cmd, unsigned long
>> arg) +{
>> +     struct sa_device *sadev =3D filp->private_data;
>> +     int ret =3D -ENODEV;
>> +
>> +     switch (cmd) {
>> +     case SA_IOC_ALLOC:
>> +     {
>> +             struct simple_allocate_data data;
>> +             struct dma_buf *dmabuf;
>> +
>> +             if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cm=
d)))
>> +                     return -EFAULT;
>> +
>> +             if (data.version !=3D 0)
>> +                     return -EINVAL;
>> +
>> +             dmabuf =3D sadev->allocate(sadev, data.length, data.flags)=
;
>> +             if (!dmabuf)
>> +                     return -EINVAL;
>> +
>> +             data.fd =3D dma_buf_fd(dmabuf, data.flags);
>> +             if (data.fd < 0) {
>> +                     dma_buf_put(dmabuf);
>> +                     return -EINVAL;
>> +             }
>> +
>> +             data.length =3D dmabuf->size;
>> +
>> +             if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd)=
)) {
>> +                     dma_buf_put(dmabuf);
>> +                     return -EFAULT;
>> +             }
>> +
>> +             return 0;
>> +     }
>> +     }
>> +     return ret;
>> +}
>> +
>> +static int sa_open(struct inode *inode, struct file *filp)
>> +{
>> +     struct sa_device *sadev =3D container_of(inode->i_cdev,
>> +                                            struct sa_device, chrdev);
>> +
>> +     if (!sadev)
>> +             return -ENODEV;
>> +
>> +     get_device(&sadev->dev);
>> +     filp->private_data =3D sadev;
>> +     return 0;
>> +}
>> +
>> +static int sa_release(struct inode *inode, struct file *filp)
>> +{
>> +     struct sa_device *sadev =3D container_of(inode->i_cdev,
>> +                                            struct sa_device, chrdev);
>> +
>> +     if (!sadev)
>> +             return -ENODEV;
>> +
>> +     put_device(&sadev->dev);
>> +     return 0;
>> +}
>> +
>> +static const struct file_operations sa_fops =3D {
>> +     .owner =3D THIS_MODULE,
>> +     .open =3D sa_open,
>> +     .release =3D sa_release,
>> +     .unlocked_ioctl =3D sa_ioctl,
>> +};
>> +
>> +/**
>> + * simple_allocator_register - register a simple allocator
>> + * @sadev: simple allocator structure to be registered
>> + *
>> + * Return 0 if allocator has been regsitered, either a negative value.
>> + */
>> +int simple_allocator_register(struct sa_device *sadev)
>> +{
>> +     int ret;
>> +
>> +     if (!sadev->name || !sadev->allocate)
>> +             return -EINVAL;
>> +
>> +     cdev_init(&sadev->chrdev, &sa_fops);
>> +     sadev->chrdev.owner =3D sadev->owner;
>> +
>> +     ret =3D cdev_add(&sadev->chrdev, MKDEV(SA_MAJOR, sa_minor), 1);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     sadev->dev.class =3D &sa_class;
>> +     sadev->dev.devt =3D MKDEV(SA_MAJOR, sa_minor);
>> +     dev_set_name(&sadev->dev, "%s%d", sadev->name, sa_minor);
>> +     ret =3D device_register(&sadev->dev);
>> +     if (ret < 0)
>> +             goto cleanup;
>> +
>> +     sa_minor++;
>> +     return 0;
>> +
>> +cleanup:
>> +     cdev_del(&sadev->chrdev);
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(simple_allocator_register);
>> +
>> +/**
>> + * simple_allocator_unregister - unregister a simple allocator
>> + * @sadev: simple allocator device to be unregistered
>> + */
>> +void simple_allocator_unregister(struct sa_device *sadev)
>> +{
>> +     if (!sadev)
>> +             return;
>> +
>> +     cdev_del(&sadev->chrdev);
>> +     device_del(&sadev->dev);
>> +     put_device(&sadev->dev);
>> +}
>> +EXPORT_SYMBOL_GPL(simple_allocator_unregister);
>> +
>> +static int __init sa_init(void)
>> +{
>> +     dev_t dev =3D MKDEV(SA_MAJOR, 0);
>> +     int ret;
>> +
>> +     ret =3D register_chrdev_region(dev, SA_NUM_DEVICES, SA_NAME);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     ret =3D class_register(&sa_class);
>> +     if (ret < 0) {
>> +             unregister_chrdev_region(dev, SA_NUM_DEVICES);
>> +             return -EIO;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void __exit sa_exit(void)
>> +{
>> +     dev_t dev =3D MKDEV(SA_MAJOR, 0);
>> +
>> +     class_unregister(&sa_class);
>> +     unregister_chrdev_region(dev, SA_NUM_DEVICES);
>> +}
>> +
>> +subsys_initcall(sa_init);
>> +module_exit(sa_exit);
>> +
>> +MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>");
>> +MODULE_DESCRIPTION("Simple allocator");
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS_CHARDEV_MAJOR(SA_MAJOR);
>> diff --git a/include/uapi/linux/simple-allocator.h
>> b/include/uapi/linux/simple-allocator.h new file mode 100644
>> index 0000000..5520a85
>> --- /dev/null
>> +++ b/include/uapi/linux/simple-allocator.h
>> @@ -0,0 +1,35 @@
>> +/*
>> + * Copyright (C) Linaro 2016
>> + *
>> + * Author: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + *
>> + * License terms:  GNU General Public License (GPL), version 2
>> + */
>> +
>> +#ifndef _SIMPLE_ALLOCATOR_H_
>> +#define _SIMPLE_ALLOCATOR_H_
>> +
>> +#include <linux/ioctl.h>
>> +#include <linux/types.h>
>> +
>> +/**
>> + * struct simple_allocate_data - allocation parameters
>> + * @version: structure version (must be set to 0)
>> + * @length:  size of the requested buffer
>> + * @flags:   mode flags for the file like O_RDWR or O_CLOEXEC
>> + * @fd:              returned file descriptor
>> + */
>> +struct simple_allocate_data {
>> +     __u64 version;
>> +     __u64 length;
>> +     __u32 flags;
>> +     __u32 reserved1;
>> +     __s32 fd;
>> +     __u32 reserved2;
>> +};
>> +
>> +#define SA_IOC_MAGIC 'S'
>> +
>> +#define SA_IOC_ALLOC _IOWR(SA_IOC_MAGIC, 0, struct simple_allocate_data=
)
>> +
>> +#endif
>
> --
> Regards,
>
> Laurent Pinchart
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
