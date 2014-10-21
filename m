From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 02/18] vfio: platform: probe to devices on the
	platform bus
Date: Tue, 21 Oct 2014 10:17:49 -0600
Message-ID: <1413908269.4202.135.camel@ul30vt.home>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
	<1413205825-6370-3-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1413205825-6370-3-git-send-email-a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, will.deacon-5wv7dgnIgG8@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
> Driver to bind to Linux platform devices, and callbacks to discover their
> resources to be used by the main VFIO PLATFORM code.
> 
> Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
> ---
>  drivers/vfio/platform/vfio_platform.c | 107 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h             |   1 +
>  2 files changed, 108 insertions(+)
>  create mode 100644 drivers/vfio/platform/vfio_platform.c
> 
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> new file mode 100644
> index 0000000..baeb7da
> --- /dev/null
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -0,0 +1,107 @@
> +/*
> + * Copyright (C) 2013 - Virtual Open Systems
> + * Author: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/interrupt.h>
> +#include <linux/iommu.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/irq.h>
> +
> +#include "vfio_platform_private.h"
> +
> +#define DRIVER_VERSION  "0.8"
> +#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>"
> +#define DRIVER_DESC     "VFIO for platform devices - User Level meta-driver"
> +
> +/* probing devices from the linux platform bus */
> +
> +static struct resource *get_platform_resource(struct vfio_platform_device *vdev,
> +						int num)
> +{
> +	struct platform_device *dev = (struct platform_device *) vdev->opaque;
> +	int i;
> +
> +	for (i = 0; i < dev->num_resources; i++) {
> +		struct resource *r = &dev->resource[i];
> +
> +		if (resource_type(r) & (IORESOURCE_MEM|IORESOURCE_IO)) {
> +			num--;
> +
> +			if (!num)
> +				return r;

Has this been tested?  What happens when we call this with num = 0?

> +		}
> +	}
> +	return NULL;
> +}
> +
> +static int get_platform_irq(struct vfio_platform_device *vdev, int i)
> +{
> +	struct platform_device *pdev = (struct platform_device *) vdev->opaque;
> +
> +	return platform_get_irq(pdev, i);
> +}
> +
> +
> +static int vfio_platform_probe(struct platform_device *pdev)
> +{
> +	struct vfio_platform_device *vdev;
> +	int ret;
> +
> +	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> +	if (!vdev)
> +		return -ENOMEM;
> +
> +	vdev->opaque = (void *) pdev;
> +	vdev->name = pdev->name;
> +	vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
> +	vdev->get_resource = get_platform_resource;
> +	vdev->get_irq = get_platform_irq;
> +
> +	ret = vfio_platform_probe_common(vdev, &pdev->dev);
> +	if (ret)
> +		kfree(vdev);
> +
> +	return ret;
> +}
> +
> +static int vfio_platform_remove(struct platform_device *pdev)
> +{
> +	return vfio_platform_remove_common(&pdev->dev);
> +}
> +
> +static struct platform_driver vfio_platform_driver = {
> +	.probe		= vfio_platform_probe,
> +	.remove		= vfio_platform_remove,
> +	.driver	= {
> +		.name	= "vfio-platform",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(vfio_platform_driver);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 111b5e8..aca6d3e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -158,6 +158,7 @@ struct vfio_device_info {
>  	__u32	flags;
>  #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
>  #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
> +#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  };
