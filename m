From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [RFC PATCH v4 1/3] vfio: platform: add device properties skeleton
 and user API
Date: Thu, 10 Sep 2015 08:35:06 +0200
Message-ID: <CAN9JPjGmN2HrbrbexwvW_goT36HrJC+J2cMTq3JPD0M6nv1PTw@mail.gmail.com>
References: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
 <1441790231-22920-2-git-send-email-b.reynal@virtualopensystems.com>
 <1441831692.20355.540.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0377771796320741144=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1441831692.20355.540.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Linux IOMMU <iommu@lists.linux-foundation.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: linux-api@vger.kernel.org

--===============0377771796320741144==
Content-Type: multipart/alternative; boundary=001a1149d2c6ca0a4a051f5ecc35

--001a1149d2c6ca0a4a051f5ecc35
Content-Type: text/plain; charset=UTF-8

On Wed, Sep 9, 2015 at 10:48 PM, Alex Williamson <alex.williamson@redhat.com
> wrote:

> On Wed, 2015-09-09 at 11:17 +0200, Baptiste Reynal wrote:
> > From: Antonios Motakis <a.motakis@virtualopensystems.com>
> >
> > This patch introduces an API that allows to return device properties (OF
> > or ACPI) of a device bound to the vfio-platform/vfio-amba driver and the
> > skeleton of the implementation for VFIO_PLATFORM. Information about any
> > device node bound by VFIO_PLATFORM should be queried via the introduced
> > ioctl VFIO_DEVICE_GET_DEV_PROPERTY.
> >
> > The user needs to know the name and the data type of the property he is
> > accessing.
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
> >
> > ---
> > v3 -> v4:
> >  - added flags placeholder in vfio_dev_properties
> >  - ioctl returns -E2BIG if the buffer is too small
> >  - details VFIO_DEVICE_GET_DEV_PROPERTY documentation
> > ---
> >  drivers/vfio/platform/Makefile                |  3 +-
> >  drivers/vfio/platform/properties.c            | 77
> +++++++++++++++++++++++++++
> >  drivers/vfio/platform/vfio_platform_common.c  | 35 ++++++++++++
> >  drivers/vfio/platform/vfio_platform_private.h |  7 +++
> >  include/uapi/linux/vfio.h                     | 31 +++++++++++
> >  5 files changed, 152 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/vfio/platform/properties.c
> >
> > diff --git a/drivers/vfio/platform/Makefile
> b/drivers/vfio/platform/Makefile
> > index 9ce8afe..37cf5ed 100644
> > --- a/drivers/vfio/platform/Makefile
> > +++ b/drivers/vfio/platform/Makefile
> > @@ -1,5 +1,6 @@
> >
> > -vfio-platform-y := vfio_platform.o vfio_platform_common.o
> vfio_platform_irq.o
> > +vfio-platform-y := vfio_platform.o vfio_platform_common.o
> vfio_platform_irq.o \
> > +                properties.o
> >
> >  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
> >  obj-$(CONFIG_VFIO_PLATFORM) += reset/
> > diff --git a/drivers/vfio/platform/properties.c
> b/drivers/vfio/platform/properties.c
> > new file mode 100644
> > index 0000000..98754c2
> > --- /dev/null
> > +++ b/drivers/vfio/platform/properties.c
> > @@ -0,0 +1,77 @@
> > +/*
> > + * Copyright (C) 2015 - Virtual Open Systems
> > + * Authors: Antonios Motakis <a.motakis@virtualopensystems.com>
> > + *          Baptiste Reynal <b.reynal@virtualopensystems.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License, version 2, as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/slab.h>
> > +#include <linux/vfio.h>
> > +#include <linux/property.h>
> > +#include "vfio_platform_private.h"
> > +
> > +static int dev_property_get_strings(struct device *dev, uint32_t *flags,
> > +                                 char *name, unsigned *lenp,
> > +                                 void __user *datap, unsigned long
> datasz)
> > +{
> > +     return -EINVAL;
> > +}
> > +
> > +static int dev_property_get_uint(struct device *dev, uint32_t *flags,
> > +                              char *name, uint32_t type, unsigned *lenp,
> > +                              void __user *datap, unsigned long datasz)
> > +{
> > +     return -EINVAL;
> > +}
> > +
> > +int vfio_platform_dev_properties(struct device *dev, uint32_t *flags,
> > +                              uint32_t type, unsigned *lenp,
> > +                              void __user *datap, unsigned long datasz)
> > +{
> > +     char *name;
> > +     long namesz;
> > +     int ret;
> > +
> > +     namesz = strnlen_user(datap, datasz);
> > +     if (!namesz)
> > +             return -EFAULT;
> > +     if (namesz > datasz)
> > +             return -EINVAL;
> > +
> > +     name = kzalloc(namesz, GFP_KERNEL);
>
> What prevents the user from passing an arbitrarily large string here?
>

Nothing, should I put an arbitrary limit ?


>
> > +     if (!name)
> > +             return -ENOMEM;
> > +     if (strncpy_from_user(name, datap, namesz) <= 0) {
> > +             kfree(name);
> > +             return -EFAULT;
> > +     }
> > +
> > +     switch (type) {
> > +     case VFIO_DEV_PROPERTY_TYPE_STRINGS:
> > +             ret = dev_property_get_strings(dev, flags, name, lenp,
> > +                             datap, datasz);
> > +             break;
> > +
> > +     case VFIO_DEV_PROPERTY_TYPE_U64:
> > +     case VFIO_DEV_PROPERTY_TYPE_U32:
> > +     case VFIO_DEV_PROPERTY_TYPE_U16:
> > +     case VFIO_DEV_PROPERTY_TYPE_U8:
> > +             ret = dev_property_get_uint(dev, flags, name, type, lenp,
> > +                                         datap, datasz);
> > +             break;
> > +
> > +     default:
> > +             ret = -EINVAL;
> > +     }
> > +
> > +     kfree(name);
> > +     return ret;
> > +}
> > diff --git a/drivers/vfio/platform/vfio_platform_common.c
> b/drivers/vfio/platform/vfio_platform_common.c
> > index e43efb5..44ba22c 100644
> > --- a/drivers/vfio/platform/vfio_platform_common.c
> > +++ b/drivers/vfio/platform/vfio_platform_common.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/types.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/vfio.h>
> > +#include <linux/property.h>
> >
> >  #include "vfio_platform_private.h"
> >
> > @@ -302,6 +303,34 @@ static long vfio_platform_ioctl(void *device_data,
> >                       return vdev->reset(vdev);
> >               else
> >                       return -EINVAL;
> > +     } else if (cmd == VFIO_DEVICE_GET_DEV_PROPERTY) {
> > +             struct vfio_dev_property info;
> > +             void __user *datap;
> > +             unsigned long datasz;
> > +             int ret;
> > +
> > +             if (!vdev->dev)
> > +                     return -EINVAL;
> > +
> > +             minsz = offsetofend(struct vfio_dev_property, length);
> > +
> > +             if (copy_from_user(&info, (void __user *)arg, minsz))
> > +                     return -EFAULT;
> > +
> > +             if (info.argsz < minsz)
> > +                     return -EINVAL;
> > +
> > +             datap = (void __user *) arg + minsz;
> > +             datasz = info.argsz - minsz;
> > +
> > +             ret = vfio_platform_dev_properties(vdev->dev, &info.flags,
>
> Why the address of flags, I don't see anyone modifying it and there's
> nothing defined in the ioctl description for flags being modified on
> return.  In fact, there are no flags defined yet, it's just a
> future-proofing mechanism of the ioctl, so why propagate it at all right
> now?
>

I tried to use them to retrieve some informations about the property, then
forgot to remove the propagation. Will be removed on next release.


>
> > +                             info.type, &info.length, datap, datasz);
> > +
> > +             if (copy_to_user((void __user *)arg, &info, minsz))
> > +                     ret = -EFAULT;
> > +
> > +             return ret;
> > +
> >       }
> >
> >       return -ENOTTY;
> > @@ -553,6 +582,12 @@ int vfio_platform_probe_common(struct
> vfio_platform_device *vdev,
> >
> >       vfio_platform_get_reset(vdev, dev);
> >
> > +     /* add device properties flag */
> > +     if (device_property_present(dev, "name")) {
> > +             vdev->dev = dev;
>
> It seems precarious to leave ->dev dangling in the else case.  This is a
> future bug waiting to happen.
>

Ok, wil be fixed on next release.


>
> > +             vdev->flags |= VFIO_DEVICE_FLAGS_DEV_PROPERTIES;
> > +     }
> > +
> >       mutex_init(&vdev->igate);
> >
> >       return 0;
> > diff --git a/drivers/vfio/platform/vfio_platform_private.h
> b/drivers/vfio/platform/vfio_platform_private.h
> > index 1c9b3d5..c75b089 100644
> > --- a/drivers/vfio/platform/vfio_platform_private.h
> > +++ b/drivers/vfio/platform/vfio_platform_private.h
> > @@ -56,6 +56,7 @@ struct vfio_platform_device {
> >       u32                             num_irqs;
> >       int                             refcnt;
> >       struct mutex                    igate;
> > +     struct device                   *dev;
> >
> >       /*
> >        * These fields should be filled by the bus specific binder
> > @@ -89,4 +90,10 @@ extern int vfio_platform_set_irqs_ioctl(struct
> vfio_platform_device *vdev,
> >                                       unsigned start, unsigned count,
> >                                       void *data);
> >
> > +/* device properties support in properties.c */
> > +extern int vfio_platform_dev_properties(struct device *dev, uint32_t
> *flags,
> > +                                     uint32_t type, unsigned *lenp,
> > +                                     void __user *datap,
> > +                                     unsigned long datasz);
> > +
> >  #endif /* VFIO_PLATFORM_PRIVATE_H */
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 9fd7b5d..a1a0eaa 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -164,12 +164,43 @@ struct vfio_device_info {
> >  #define VFIO_DEVICE_FLAGS_PCI        (1 << 1)        /* vfio-pci device
> */
> >  #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)  /* vfio-platform device */
> >  #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)     /* vfio-amba device */
> > +#define VFIO_DEVICE_FLAGS_DEV_PROPERTIES (1 << 4) /* Device properties
> */
> >       __u32   num_regions;    /* Max region index + 1 */
> >       __u32   num_irqs;       /* Max IRQ index + 1 */
> >  };
> >  #define VFIO_DEVICE_GET_INFO         _IO(VFIO_TYPE, VFIO_BASE + 7)
> >
> >  /**
> > + * VFIO_DEVICE_GET_DEV_PROPERTY - _IOR(VFIO_TYPE, VFIO_BASE + 17,
> > + *                                           struct vfio_devtree_info)
> > + *
> > + * Retrieve a device property, e.g. from a HW description (device tree
> or ACPI)
> > + * if available.
> > + * Caller will initialize data[] with a single string with the requested
> > + * devicetree property name, and type depending on whether an array of
> strings
> > + * or an array of u32 values is expected. On success, data[] will be
> filled
> > + * with the requested information, either as an array of u32, or with a
> list
> > + * of strings separated by the NULL terminating character.
> > + * Return: 0 on success, -errno on failure.
> > + * Errors:
> > + *   E2BIG: the property is too big to fit in the data[] buffer (the
> required
> > + *          size is then written into the length field).
>
> I don't know which is more correct, but the
> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO uses ENOSPC when the buffer size is
> too small.  If there's no compelling reason to be different, let's use
> it here too.
>

I found E2BIG in others ioctls (KVM_GET_MSR_INDEX_LIST), but let's use
ENOSPC.


>
> > + */
> > +struct vfio_dev_property {
> > +     __u32   argsz;
> > +     __u32   flags;  /* Placeholder for future extension */
> > +     __u32   type;
> > +#define VFIO_DEV_PROPERTY_TYPE_STRINGS       0
> > +#define VFIO_DEV_PROPERTY_TYPE_U8    1
> > +#define VFIO_DEV_PROPERTY_TYPE_U16   2
> > +#define VFIO_DEV_PROPERTY_TYPE_U32   3
> > +#define VFIO_DEV_PROPERTY_TYPE_U64   4
> > +     __u32   length; /* Size of data[] */
> > +     __u8    data[];
> > +};
> > +#define VFIO_DEVICE_GET_DEV_PROPERTY _IO(VFIO_TYPE, VFIO_BASE + 17)
> > +
> > +/**
> >   * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
> >   *                                  struct vfio_region_info)
> >   *
>
>
>
>

--001a1149d2c6ca0a4a051f5ecc35
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Sep 9, 2015 at 10:48 PM, Alex Williamson <span dir=3D"ltr">&lt;=
<a href=3D"mailto:alex.williamson@redhat.com" target=3D"_blank">alex.willia=
mson@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pa=
dding-left:1ex"><div class=3D""><div class=3D"h5">On Wed, 2015-09-09 at 11:=
17 +0200, Baptiste Reynal wrote:<br>
&gt; From: Antonios Motakis &lt;<a href=3D"mailto:a.motakis@virtualopensyst=
ems.com">a.motakis@virtualopensystems.com</a>&gt;<br>
&gt;<br>
&gt; This patch introduces an API that allows to return device properties (=
OF<br>
&gt; or ACPI) of a device bound to the vfio-platform/vfio-amba driver and t=
he<br>
&gt; skeleton of the implementation for VFIO_PLATFORM. Information about an=
y<br>
&gt; device node bound by VFIO_PLATFORM should be queried via the introduce=
d<br>
&gt; ioctl VFIO_DEVICE_GET_DEV_PROPERTY.<br>
&gt;<br>
&gt; The user needs to know the name and the data type of the property he i=
s<br>
&gt; accessing.<br>
&gt;<br>
&gt; Signed-off-by: Antonios Motakis &lt;<a href=3D"mailto:a.motakis@virtua=
lopensystems.com">a.motakis@virtualopensystems.com</a>&gt;<br>
&gt; Signed-off-by: Baptiste Reynal &lt;<a href=3D"mailto:b.reynal@virtualo=
pensystems.com">b.reynal@virtualopensystems.com</a>&gt;<br>
&gt;<br>
&gt; ---<br>
&gt; v3 -&gt; v4:<br>
&gt;=C2=A0 - added flags placeholder in vfio_dev_properties<br>
&gt;=C2=A0 - ioctl returns -E2BIG if the buffer is too small<br>
&gt;=C2=A0 - details VFIO_DEVICE_GET_DEV_PROPERTY documentation<br>
&gt; ---<br>
&gt;=C2=A0 drivers/vfio/platform/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 3 +-<br>
&gt;=C2=A0 drivers/vfio/platform/properties.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 | 77 +++++++++++++++++++++++++++<br>
&gt;=C2=A0 drivers/vfio/platform/vfio_platform_common.c=C2=A0 | 35 ++++++++=
++++<br>
&gt;=C2=A0 drivers/vfio/platform/vfio_platform_private.h |=C2=A0 7 +++<br>
&gt;=C2=A0 include/uapi/linux/vfio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 31 +++++++++++<br>
&gt;=C2=A0 5 files changed, 152 insertions(+), 1 deletion(-)<br>
&gt;=C2=A0 create mode 100644 drivers/vfio/platform/properties.c<br>
&gt;<br>
&gt; diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Ma=
kefile<br>
&gt; index 9ce8afe..37cf5ed 100644<br>
&gt; --- a/drivers/vfio/platform/Makefile<br>
&gt; +++ b/drivers/vfio/platform/Makefile<br>
&gt; @@ -1,5 +1,6 @@<br>
&gt;<br>
&gt; -vfio-platform-y :=3D vfio_platform.o vfio_platform_common.o vfio_plat=
form_irq.o<br>
&gt; +vfio-platform-y :=3D vfio_platform.o vfio_platform_common.o vfio_plat=
form_irq.o \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 properties.o<=
br>
&gt;<br>
&gt;=C2=A0 obj-$(CONFIG_VFIO_PLATFORM) +=3D vfio-platform.o<br>
&gt;=C2=A0 obj-$(CONFIG_VFIO_PLATFORM) +=3D reset/<br>
&gt; diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platfor=
m/properties.c<br>
&gt; new file mode 100644<br>
&gt; index 0000000..98754c2<br>
&gt; --- /dev/null<br>
&gt; +++ b/drivers/vfio/platform/properties.c<br>
&gt; @@ -0,0 +1,77 @@<br>
&gt; +/*<br>
&gt; + * Copyright (C) 2015 - Virtual Open Systems<br>
&gt; + * Authors: Antonios Motakis &lt;<a href=3D"mailto:a.motakis@virtualo=
pensystems.com">a.motakis@virtualopensystems.com</a>&gt;<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Baptiste Reynal &lt;<a href=3D"m=
ailto:b.reynal@virtualopensystems.com">b.reynal@virtualopensystems.com</a>&=
gt;<br>
&gt; + *<br>
&gt; + * This program is free software; you can redistribute it and/or modi=
fy<br>
&gt; + * it under the terms of the GNU General Public License, version 2, a=
s<br>
&gt; + * published by the Free Software Foundation.<br>
&gt; + *<br>
&gt; + * This program is distributed in the hope that it will be useful,<br=
>
&gt; + * but WITHOUT ANY WARRANTY; without even the implied warranty of<br>
&gt; + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0 See the=
<br>
&gt; + * GNU General Public License for more details.<br>
&gt; + */<br>
&gt; +<br>
&gt; +#include &lt;linux/slab.h&gt;<br>
&gt; +#include &lt;linux/vfio.h&gt;<br>
&gt; +#include &lt;linux/property.h&gt;<br>
&gt; +#include &quot;vfio_platform_private.h&quot;<br>
&gt; +<br>
&gt; +static int dev_property_get_strings(struct device *dev, uint32_t *fla=
gs,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *name, unsigned *lenp=
,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void __user *datap, unsign=
ed long datasz)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static int dev_property_get_uint(struct device *dev, uint32_t *flags,=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char *name, uint32_t type, unsigned *le=
np,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void __user *datap, unsigned long datas=
z)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +}<br>
&gt; +<br>
&gt; +int vfio_platform_dev_properties(struct device *dev, uint32_t *flags,=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uint32_t type, unsigned *lenp,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void __user *datap, unsigned long datas=
z)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *name;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0long namesz;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0namesz =3D strnlen_user(datap, datasz);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!namesz)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EFAULT;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (namesz &gt; datasz)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0name =3D kzalloc(namesz, GFP_KERNEL);<br>
<br>
</div></div>What prevents the user from passing an arbitrarily large string=
 here?<br></blockquote><div><br></div><div>Nothing, should I put an arbitra=
ry limit ?<br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddin=
g-left:1ex">
<div><div class=3D"h5"><br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!name)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (strncpy_from_user(name, datap, namesz) &lt;=
=3D 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(name);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EFAULT;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0switch (type) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_STRINGS:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D dev_property_=
get_strings(dev, flags, name, lenp,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0datap, datasz);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_U64:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_U32:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_U16:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_U8:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D dev_property_=
get_uint(dev, flags, name, type, lenp,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0datap, datasz);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0default:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0kfree(name);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt; +}<br>
&gt; diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vf=
io/platform/vfio_platform_common.c<br>
&gt; index e43efb5..44ba22c 100644<br>
&gt; --- a/drivers/vfio/platform/vfio_platform_common.c<br>
&gt; +++ b/drivers/vfio/platform/vfio_platform_common.c<br>
&gt; @@ -20,6 +20,7 @@<br>
&gt;=C2=A0 #include &lt;linux/types.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/uaccess.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/vfio.h&gt;<br>
&gt; +#include &lt;linux/property.h&gt;<br>
&gt;<br>
&gt;=C2=A0 #include &quot;vfio_platform_private.h&quot;<br>
&gt;<br>
&gt; @@ -302,6 +303,34 @@ static long vfio_platform_ioctl(void *device_data=
,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return vdev-&gt;reset(vdev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else if (cmd =3D=3D VFIO_DEVICE_GET_DEV_PROPERT=
Y) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct vfio_dev_prope=
rty info;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void __user *datap;<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long datasz;=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!vdev-&gt;dev)<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0minsz =3D offsetofend=
(struct vfio_dev_property, length);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (copy_from_user(&a=
mp;info, (void __user *)arg, minsz))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -EFAULT;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (info.argsz &lt; m=
insz)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0datap =3D (void __use=
r *) arg + minsz;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0datasz =3D info.argsz=
 - minsz;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D vfio_platform=
_dev_properties(vdev-&gt;dev, &amp;info.flags,<br>
<br>
</div></div>Why the address of flags, I don&#39;t see anyone modifying it a=
nd there&#39;s<br>
nothing defined in the ioctl description for flags being modified on<br>
return.=C2=A0 In fact, there are no flags defined yet, it&#39;s just a<br>
future-proofing mechanism of the ioctl, so why propagate it at all right<br=
>
now?<br></blockquote><div><br></div><div>I tried to use them to retrieve so=
me informations about the property, then forgot to remove the propagation. =
Will be removed on next release.<br>=C2=A0<br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex">
<span class=3D""><br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0info.type, &amp;info.length, datap, data=
sz);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (copy_to_user((voi=
d __user *)arg, &amp;info, minsz))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ret =3D -EFAULT;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOTTY;<br>
&gt; @@ -553,6 +582,12 @@ int vfio_platform_probe_common(struct vfio_platfo=
rm_device *vdev,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0vfio_platform_get_reset(vdev, dev);<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* add device properties flag */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (device_property_present(dev, &quot;name&quot;=
)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vdev-&gt;dev =3D dev;=
<br>
<br>
</span>It seems precarious to leave -&gt;dev dangling in the else case.=C2=
=A0 This is a<br>
future bug waiting to happen.<br></blockquote><div><br></div><div>Ok, wil b=
e fixed on next release.<br>=C2=A0<br></div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex">
<div><div class=3D"h5"><br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vdev-&gt;flags |=3D V=
FIO_DEVICE_FLAGS_DEV_PROPERTIES;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_init(&amp;vdev-&gt;igate);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/v=
fio/platform/vfio_platform_private.h<br>
&gt; index 1c9b3d5..c75b089 100644<br>
&gt; --- a/drivers/vfio/platform/vfio_platform_private.h<br>
&gt; +++ b/drivers/vfio/platform/vfio_platform_private.h<br>
&gt; @@ -56,6 +56,7 @@ struct vfio_platform_device {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0num_irqs;<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0refcnt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct mutex=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 igate;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct device=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*dev;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * These fields should be filled by the bus =
specific binder<br>
&gt; @@ -89,4 +90,10 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio=
_platform_device *vdev,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsign=
ed start, unsigned count,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void *=
data);<br>
&gt;<br>
&gt; +/* device properties support in properties.c */<br>
&gt; +extern int vfio_platform_dev_properties(struct device *dev, uint32_t =
*flags,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t typ=
e, unsigned *lenp,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void __user =
*datap,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned lon=
g datasz);<br>
&gt; +<br>
&gt;=C2=A0 #endif /* VFIO_PLATFORM_PRIVATE_H */<br>
&gt; diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h<br>
&gt; index 9fd7b5d..a1a0eaa 100644<br>
&gt; --- a/include/uapi/linux/vfio.h<br>
&gt; +++ b/include/uapi/linux/vfio.h<br>
&gt; @@ -164,12 +164,43 @@ struct vfio_device_info {<br>
&gt;=C2=A0 #define VFIO_DEVICE_FLAGS_PCI=C2=A0 =C2=A0 =C2=A0 =C2=A0 (1 &lt;=
&lt; 1)=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* vfio-pci device */<br>
&gt;=C2=A0 #define VFIO_DEVICE_FLAGS_PLATFORM (1 &lt;&lt; 2)=C2=A0 /* vfio-=
platform device */<br>
&gt;=C2=A0 #define VFIO_DEVICE_FLAGS_AMBA=C2=A0 (1 &lt;&lt; 3)=C2=A0 =C2=A0=
 =C2=A0/* vfio-amba device */<br>
&gt; +#define VFIO_DEVICE_FLAGS_DEV_PROPERTIES (1 &lt;&lt; 4) /* Device pro=
perties */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0__u32=C2=A0 =C2=A0num_regions;=C2=A0 =C2=A0 =
/* Max region index + 1 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0__u32=C2=A0 =C2=A0num_irqs;=C2=A0 =C2=A0 =C2=
=A0 =C2=A0/* Max IRQ index + 1 */<br>
&gt;=C2=A0 };<br>
&gt;=C2=A0 #define VFIO_DEVICE_GET_INFO=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0_I=
O(VFIO_TYPE, VFIO_BASE + 7)<br>
&gt;<br>
&gt;=C2=A0 /**<br>
&gt; + * VFIO_DEVICE_GET_DEV_PROPERTY - _IOR(VFIO_TYPE, VFIO_BASE + 17,<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct vfio_devtree_info)<br>
&gt; + *<br>
&gt; + * Retrieve a device property, e.g. from a HW description (device tre=
e or ACPI)<br>
&gt; + * if available.<br>
&gt; + * Caller will initialize data[] with a single string with the reques=
ted<br>
&gt; + * devicetree property name, and type depending on whether an array o=
f strings<br>
&gt; + * or an array of u32 values is expected. On success, data[] will be =
filled<br>
&gt; + * with the requested information, either as an array of u32, or with=
 a list<br>
&gt; + * of strings separated by the NULL terminating character.<br>
&gt; + * Return: 0 on success, -errno on failure.<br>
&gt; + * Errors:<br>
&gt; + *=C2=A0 =C2=A0E2BIG: the property is too big to fit in the data[] bu=
ffer (the required<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size is then written into the le=
ngth field).<br>
<br>
</div></div>I don&#39;t know which is more correct, but the<br>
VFIO_DEVICE_GET_PCI_HOT_RESET_INFO uses ENOSPC when the buffer size is<br>
too small.=C2=A0 If there&#39;s no compelling reason to be different, let&#=
39;s use<br>
it here too.<br></blockquote><div><br></div><div>I found E2BIG in others io=
ctls (KVM_GET_MSR_INDEX_LIST), but let&#39;s use ENOSPC.<br>=C2=A0<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left:1px solid rgb(204,204,204);padding-left:1ex">
<div class=3D""><div class=3D"h5"><br>
&gt; + */<br>
&gt; +struct vfio_dev_property {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__u32=C2=A0 =C2=A0argsz;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__u32=C2=A0 =C2=A0flags;=C2=A0 /* Placeholder for=
 future extension */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__u32=C2=A0 =C2=A0type;<br>
&gt; +#define VFIO_DEV_PROPERTY_TYPE_STRINGS=C2=A0 =C2=A0 =C2=A0 =C2=A00<br=
>
&gt; +#define VFIO_DEV_PROPERTY_TYPE_U8=C2=A0 =C2=A0 1<br>
&gt; +#define VFIO_DEV_PROPERTY_TYPE_U16=C2=A0 =C2=A02<br>
&gt; +#define VFIO_DEV_PROPERTY_TYPE_U32=C2=A0 =C2=A03<br>
&gt; +#define VFIO_DEV_PROPERTY_TYPE_U64=C2=A0 =C2=A04<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__u32=C2=A0 =C2=A0length; /* Size of data[] */<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0__u8=C2=A0 =C2=A0 data[];<br>
&gt; +};<br>
&gt; +#define VFIO_DEVICE_GET_DEV_PROPERTY _IO(VFIO_TYPE, VFIO_BASE + 17)<b=
r>
&gt; +<br>
&gt; +/**<br>
&gt;=C2=A0 =C2=A0* VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE=
 + 8,<br>
&gt;=C2=A0 =C2=A0*=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct vfio_=
region_info)<br>
&gt;=C2=A0 =C2=A0*<br>
<br>
<br>
<br>
</div></div></blockquote></div><br></div></div>

--001a1149d2c6ca0a4a051f5ecc35--

--===============0377771796320741144==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0377771796320741144==--
