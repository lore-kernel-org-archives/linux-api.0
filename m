From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: Re: [RFC simple allocator v2 1/2] Create Simple Allocator module
Date: Tue, 14 Feb 2017 21:30:56 +0200
Message-ID: <4441232.4RNTQKa4zP@avalon>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org> <1486997106-23277-2-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486997106-23277-2-git-send-email-benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Benjamin,

Thank you for the patch. I've CC'ed the linux-api mailing list.

On Monday 13 Feb 2017 15:45:05 Benjamin Gaignard wrote:
> This is the core of simple allocator module.
> It aim to offert one common ioctl to allocate specific memory.
>=20
> version 2:
> - rebased on 4.10-rc7
>=20
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/simple-allocator.txt              |  81 +++++++++++
>  drivers/Kconfig                                 |   2 +
>  drivers/Makefile                                |   1 +
>  drivers/simpleallocator/Kconfig                 |  10 ++
>  drivers/simpleallocator/Makefile                |   1 +
>  drivers/simpleallocator/simple-allocator-priv.h |  33 +++++
>  drivers/simpleallocator/simple-allocator.c      | 180 ++++++++++++++=
+++++++
>  include/uapi/linux/simple-allocator.h           |  35 +++++
>  8 files changed, 343 insertions(+)
>  create mode 100644 Documentation/simple-allocator.txt
>  create mode 100644 drivers/simpleallocator/Kconfig
>  create mode 100644 drivers/simpleallocator/Makefile
>  create mode 100644 drivers/simpleallocator/simple-allocator-priv.h
>  create mode 100644 drivers/simpleallocator/simple-allocator.c
>  create mode 100644 include/uapi/linux/simple-allocator.h
>=20
> diff --git a/Documentation/simple-allocator.txt
> b/Documentation/simple-allocator.txt new file mode 100644
> index 0000000..89ba883
> --- /dev/null
> +++ b/Documentation/simple-allocator.txt
> @@ -0,0 +1,81 @@
> +Simple Allocator Framework

There's nothing simple in buffer allocation, otherwise we would have so=
lved=20
the problem a long time ago. Let's not use a misleading name.

> +Simple Allocator offer a single ioctl SA_IOC_ALLOC to allocate buffe=
rs
> +on dedicated memory regions and export them as a dmabuf file descrip=
tor.
> +Using dmabuf file descriptor allow to share this memory between proc=
esses
> +and/or import it into other frameworks like v4l2 or drm/kms (prime).=

> +When userland wants to free the memory only a call to close() in nee=
ded
> +so it could done even without knowing that buffer has been allocated=
 by
> +simple allocator ioctl.
> +
> +Each memory regions will be seen as a filein /dev/.
> +For example CMA regions will exposed has /dev/cmaX.

Why do you need multiple devices ? Furthermore, given how central this =
API=20
will become, I believe it needs very strict review, and would be a cand=
idate=20
for a syscall.

Without diving into details yet, there are a few particular points I'm=20=

concerned about.

- What is the scope of this API ? What problems do you want to solve, p=
lan to=20
solve in the future, and consider as out of scope ?

- How should we handle permissions and resource limits ? Is file-based=20=

permission on a device node a good model ? How do we prevent or at leas=
t=20
mitigate memory-related DoS ?

- How should such a central allocator API interact with containers and=20=

virtualization in general ?

- What model do we want to expose to applications to select a memory ty=
pe ?=20
You still haven't convinced me that we should expose memory pools expli=
citly=20
to application (=E0 la ION), and I believe a usage/constraint model wou=
ld be=20
better.

> +Implementing a simple allocator
> +-------------------------------
> +
> +Simple Allocator provide helpers functions to register/unregister an=

> +allocator:
> +- simple_allocator_register(struct sa_device *sadev)
> +  Register simple_allocator_device using sa_device structure where n=
ame,
> +  owner and allocate fields must be set.
> +
> +- simple_allocator_unregister(struct sa_device *sadev)
> +  Unregister a simple allocator device.
> +
> +Using Simple Allocator /dev interface example
> +---------------------------------------------
> +
> +This example of code allocate a buffer on the first CMA region (/dev=
/cma0)
> +before mmap and close it.
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +
> +#include "simple-allocator.h"
> +
> +#define LENGTH 1024*16
> +
> +void main (void)
> +{
> +=09struct simple_allocate_data data;
> +=09int fd =3D open("/dev/cma0", O_RDWR, 0);
> +=09int ret;
> +=09void *mem;
> +
> +=09if (fd < 0) {
> +=09=09printf("Can't open /dev/cma0\n");
> +=09=09return;
> +=09}
> +
> +=09memset(&data, 0, sizeof(data));
> +
> +=09data.length =3D LENGTH;
> +=09data.flags =3D O_RDWR | O_CLOEXEC;
> +
> +=09ret =3D ioctl(fd, SA_IOC_ALLOC, &data);
> +=09if (ret) {
> +=09=09printf("Buffer allocation failed\n");
> +=09=09goto end;
> +=09}
> +
> +=09mem =3D mmap(0, LENGTH, PROT_READ | PROT_WRITE, MAP_SHARED, data.=
fd, 0);
> +=09if (mem =3D=3D MAP_FAILED) {
> +=09=09printf("mmap failed\n");
> +=09}
> +
> +=09memset(mem, 0xFF, LENGTH);
> +=09munmap(mem, LENGTH);
> +
> +=09printf("test simple allocator CMA OK\n");
> +end:
> +=09close(fd);
> +}
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index e1e2066..a6d8828 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -202,4 +202,6 @@ source "drivers/hwtracing/intel_th/Kconfig"
>=20
>  source "drivers/fpga/Kconfig"
>=20
> +source "drivers/simpleallocator/Kconfig"
> +
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 060026a..5081eb8 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -173,3 +173,4 @@ obj-$(CONFIG_STM)=09=09+=3D hwtracing/stm/
>  obj-$(CONFIG_ANDROID)=09=09+=3D android/
>  obj-$(CONFIG_NVMEM)=09=09+=3D nvmem/
>  obj-$(CONFIG_FPGA)=09=09+=3D fpga/
> +obj-$(CONFIG_SIMPLE_ALLOCATOR) =09+=3D simpleallocator/
> diff --git a/drivers/simpleallocator/Kconfig
> b/drivers/simpleallocator/Kconfig new file mode 100644
> index 0000000..c6fc2e3
> --- /dev/null
> +++ b/drivers/simpleallocator/Kconfig
> @@ -0,0 +1,10 @@
> +menu "Simple Allocator"
> +
> +config SIMPLE_ALLOCATOR
> +=09tristate "Simple Alllocator Framework"
> +=09select DMA_SHARED_BUFFER
> +=09---help---
> +=09   The Simple Allocator Framework adds an API to allocate and sha=
re
> +=09   memory in userland.
> +
> +endmenu
> diff --git a/drivers/simpleallocator/Makefile
> b/drivers/simpleallocator/Makefile new file mode 100644
> index 0000000..e27c6ad
> --- /dev/null
> +++ b/drivers/simpleallocator/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_SIMPLE_ALLOCATOR) +=3D simple-allocator.o
> diff --git a/drivers/simpleallocator/simple-allocator-priv.h
> b/drivers/simpleallocator/simple-allocator-priv.h new file mode 10064=
4
> index 0000000..33f5a33
> --- /dev/null
> +++ b/drivers/simpleallocator/simple-allocator-priv.h
> @@ -0,0 +1,33 @@
> +/*
> + * Copyright (C) Linaro 2016
> + *
> + * Author: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> + *
> + * License terms:  GNU General Public License (GPL)
> + */
> +
> +#ifndef _SIMPLE_ALLOCATOR_PRIV_H_
> +#define _SIMPLE_ALLOCATOR_PRIV_H_
> +
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +#include <linux/dma-buf.h>
> +
> +/**
> + * struct sa_device - simple allocator device
> + * @owner: module owner, must be set to THIS_MODULE
> + * @name: name of the allocator
> + * @allocate: callabck for memory allocation
> + */
> +struct sa_device {
> +=09struct device=09dev;
> +=09struct cdev=09chrdev;
> +=09struct module=09*owner;
> +=09const char=09*name;
> +=09struct dma_buf *(*allocate)(struct sa_device *, u64 length, u32=20=

flags);
> +};
> +
> +int simple_allocator_register(struct sa_device *sadev);
> +void simple_allocator_unregister(struct sa_device *sadev);
> +
> +#endif
> diff --git a/drivers/simpleallocator/simple-allocator.c
> b/drivers/simpleallocator/simple-allocator.c new file mode 100644
> index 0000000..d89ccbf
> --- /dev/null
> +++ b/drivers/simpleallocator/simple-allocator.c
> @@ -0,0 +1,180 @@
> +/*
> + * Copyright (C) Linaro 2016
> + *
> + * Author: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> + *
> + * License terms:  GNU General Public License (GPL)
> + */
> +
> +#include <linux/module.h>
> +#include <linux/simple-allocator.h>
> +#include <linux/uaccess.h>
> +
> +#include "simple-allocator-priv.h"
> +
> +#define SA_MAJOR=09222
> +#define SA_NUM_DEVICES=09256
> +#define SA_NAME=09=09"simple_allocator"
> +
> +static int sa_minor;
> +
> +static struct class sa_class =3D {
> +=09.name =3D SA_NAME,
> +};
> +
> +static long sa_ioctl(struct file *filp, unsigned int cmd, unsigned l=
ong
> arg) +{
> +=09struct sa_device *sadev =3D filp->private_data;
> +=09int ret =3D -ENODEV;
> +
> +=09switch (cmd) {
> +=09case SA_IOC_ALLOC:
> +=09{
> +=09=09struct simple_allocate_data data;
> +=09=09struct dma_buf *dmabuf;
> +
> +=09=09if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))=

> +=09=09=09return -EFAULT;
> +
> +=09=09if (data.version !=3D 0)
> +=09=09=09return -EINVAL;
> +
> +=09=09dmabuf =3D sadev->allocate(sadev, data.length, data.flags);
> +=09=09if (!dmabuf)
> +=09=09=09return -EINVAL;
> +
> +=09=09data.fd =3D dma_buf_fd(dmabuf, data.flags);
> +=09=09if (data.fd < 0) {
> +=09=09=09dma_buf_put(dmabuf);
> +=09=09=09return -EINVAL;
> +=09=09}
> +
> +=09=09data.length =3D dmabuf->size;
> +
> +=09=09if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd))) {=

> +=09=09=09dma_buf_put(dmabuf);
> +=09=09=09return -EFAULT;
> +=09=09}
> +
> +=09=09return 0;
> +=09}
> +=09}
> +=09return ret;
> +}
> +
> +static int sa_open(struct inode *inode, struct file *filp)
> +{
> +=09struct sa_device *sadev =3D container_of(inode->i_cdev,
> +=09=09=09=09=09       struct sa_device, chrdev);
> +
> +=09if (!sadev)
> +=09=09return -ENODEV;
> +
> +=09get_device(&sadev->dev);
> +=09filp->private_data =3D sadev;
> +=09return 0;
> +}
> +
> +static int sa_release(struct inode *inode, struct file *filp)
> +{
> +=09struct sa_device *sadev =3D container_of(inode->i_cdev,
> +=09=09=09=09=09       struct sa_device, chrdev);
> +
> +=09if (!sadev)
> +=09=09return -ENODEV;
> +
> +=09put_device(&sadev->dev);
> +=09return 0;
> +}
> +
> +static const struct file_operations sa_fops =3D {
> +=09.owner =3D THIS_MODULE,
> +=09.open =3D sa_open,
> +=09.release =3D sa_release,
> +=09.unlocked_ioctl =3D sa_ioctl,
> +};
> +
> +/**
> + * simple_allocator_register - register a simple allocator
> + * @sadev: simple allocator structure to be registered
> + *
> + * Return 0 if allocator has been regsitered, either a negative valu=
e.
> + */
> +int simple_allocator_register(struct sa_device *sadev)
> +{
> +=09int ret;
> +
> +=09if (!sadev->name || !sadev->allocate)
> +=09=09return -EINVAL;
> +
> +=09cdev_init(&sadev->chrdev, &sa_fops);
> +=09sadev->chrdev.owner =3D sadev->owner;
> +
> +=09ret =3D cdev_add(&sadev->chrdev, MKDEV(SA_MAJOR, sa_minor), 1);
> +=09if (ret < 0)
> +=09=09return ret;
> +
> +=09sadev->dev.class =3D &sa_class;
> +=09sadev->dev.devt =3D MKDEV(SA_MAJOR, sa_minor);
> +=09dev_set_name(&sadev->dev, "%s%d", sadev->name, sa_minor);
> +=09ret =3D device_register(&sadev->dev);
> +=09if (ret < 0)
> +=09=09goto cleanup;
> +
> +=09sa_minor++;
> +=09return 0;
> +
> +cleanup:
> +=09cdev_del(&sadev->chrdev);
> +=09return ret;
> +}
> +EXPORT_SYMBOL_GPL(simple_allocator_register);
> +
> +/**
> + * simple_allocator_unregister - unregister a simple allocator
> + * @sadev: simple allocator device to be unregistered
> + */
> +void simple_allocator_unregister(struct sa_device *sadev)
> +{
> +=09if (!sadev)
> +=09=09return;
> +
> +=09cdev_del(&sadev->chrdev);
> +=09device_del(&sadev->dev);
> +=09put_device(&sadev->dev);
> +}
> +EXPORT_SYMBOL_GPL(simple_allocator_unregister);
> +
> +static int __init sa_init(void)
> +{
> +=09dev_t dev =3D MKDEV(SA_MAJOR, 0);
> +=09int ret;
> +
> +=09ret =3D register_chrdev_region(dev, SA_NUM_DEVICES, SA_NAME);
> +=09if (ret < 0)
> +=09=09return ret;
> +
> +=09ret =3D class_register(&sa_class);
> +=09if (ret < 0) {
> +=09=09unregister_chrdev_region(dev, SA_NUM_DEVICES);
> +=09=09return -EIO;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static void __exit sa_exit(void)
> +{
> +=09dev_t dev =3D MKDEV(SA_MAJOR, 0);
> +
> +=09class_unregister(&sa_class);
> +=09unregister_chrdev_region(dev, SA_NUM_DEVICES);
> +}
> +
> +subsys_initcall(sa_init);
> +module_exit(sa_exit);
> +
> +MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>");
> +MODULE_DESCRIPTION("Simple allocator");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_CHARDEV_MAJOR(SA_MAJOR);
> diff --git a/include/uapi/linux/simple-allocator.h
> b/include/uapi/linux/simple-allocator.h new file mode 100644
> index 0000000..5520a85
> --- /dev/null
> +++ b/include/uapi/linux/simple-allocator.h
> @@ -0,0 +1,35 @@
> +/*
> + * Copyright (C) Linaro 2016
> + *
> + * Author: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> + *
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef _SIMPLE_ALLOCATOR_H_
> +#define _SIMPLE_ALLOCATOR_H_
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct simple_allocate_data - allocation parameters
> + * @version:=09structure version (must be set to 0)
> + * @length:=09size of the requested buffer
> + * @flags:=09mode flags for the file like O_RDWR or O_CLOEXEC
> + * @fd:=09=09returned file descriptor
> + */
> +struct simple_allocate_data {
> +=09__u64 version;
> +=09__u64 length;
> +=09__u32 flags;
> +=09__u32 reserved1;
> +=09__s32 fd;
> +=09__u32 reserved2;
> +};
> +
> +#define SA_IOC_MAGIC 'S'
> +
> +#define SA_IOC_ALLOC _IOWR(SA_IOC_MAGIC, 0, struct simple_allocate_d=
ata)
> +
> +#endif

--=20
Regards,

Laurent Pinchart
