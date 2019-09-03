From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 08/11] usb: Add USB subsystem notifications [ver #7]
Date: Tue, 3 Sep 2019 05:51:29 -0700
Message-ID: <20190903125129.GA18838@roeck-us.net>
References: <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
 <156717350329.2204.7056537095039252263.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156717350329.2204.7056537095039252263.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Aug 30, 2019 at 02:58:23PM +0100, David Howells wrote:
> Add a USB subsystem notification mechanism whereby notifications about
> hardware events such as device connection, disconnection, reset and I/O
> errors, can be reported to a monitoring process asynchronously.
> 
> Firstly, an event queue needs to be created:
> 
> 	fd = open("/dev/event_queue", O_RDWR);
> 	ioctl(fd, IOC_WATCH_QUEUE_SET_SIZE, page_size << n);
> 
> then a notification can be set up to report USB notifications via that
> queue:
> 
> 	struct watch_notification_filter filter = {
> 		.nr_filters = 1,
> 		.filters = {
> 			[0] = {
> 				.type = WATCH_TYPE_USB_NOTIFY,
> 				.subtype_filter[0] = UINT_MAX;
> 			},
> 		},
> 	};
> 	ioctl(fd, IOC_WATCH_QUEUE_SET_FILTER, &filter);
> 	notify_devices(fd, 12);
> 
> After that, records will be placed into the queue when events occur on a
> USB device or bus.  Records are of the following format:
> 
> 	struct usb_notification {
> 		struct watch_notification watch;
> 		__u32	error;
> 		__u32	reserved;
> 		__u8	name_len;
> 		__u8	name[0];
> 	} *n;
> 
> Where:
> 
> 	n->watch.type will be WATCH_TYPE_USB_NOTIFY
> 
> 	n->watch.subtype will be the type of notification, such as
> 	NOTIFY_USB_DEVICE_ADD.
> 
> 	n->watch.info & WATCH_INFO_LENGTH will indicate the length of the
> 	record.
> 
> 	n->watch.info & WATCH_INFO_ID will be the second argument to
> 	device_notify(), shifted.
> 
> 	n->error and n->reserved are intended to convey information such as
> 	error codes, but are currently not used
> 
> 	n->name_len and n->name convey the USB device name as an
> 	unterminated string.  This may be truncated - it is currently
> 	limited to a maximum 63 chars.
> 
> Note that it is permissible for event records to be of variable length -
> or, at least, the length may be dependent on the subtype.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: linux-usb@vger.kernel.org
> ---
> 
>  Documentation/watch_queue.rst    |    9 ++++++
>  drivers/usb/core/Kconfig         |    9 ++++++
>  drivers/usb/core/devio.c         |   56 ++++++++++++++++++++++++++++++++++++++
>  drivers/usb/core/hub.c           |    4 +++
>  include/linux/usb.h              |   18 ++++++++++++
>  include/uapi/linux/watch_queue.h |   30 ++++++++++++++++++++
>  6 files changed, 125 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/watch_queue.rst b/Documentation/watch_queue.rst
> index 5cc9c6924727..4087a8e670a8 100644
> --- a/Documentation/watch_queue.rst
> +++ b/Documentation/watch_queue.rst
> @@ -11,6 +11,8 @@ receive notifications from the kernel.  This can be used in conjunction with::
>  
>      * Block layer event notifications
>  
> +    * USB subsystem event notifications
> +
>  
>  The notifications buffers can be enabled by:
>  
> @@ -315,6 +317,13 @@ Any particular buffer can be fed from multiple sources.  Sources include:
>      or temporary link loss.  Watches of this type are set on the global device
>      watch list.
>  
> +  * WATCH_TYPE_USB_NOTIFY
> +
> +    Notifications of this type indicate USB subsystem events, such as
> +    attachment, removal, reset and I/O errors.  Separate events are generated
> +    for buses and devices.  Watchpoints of this type are set on the global
> +    device watch list.
> +
>  
>  Event Filtering
>  ===============
> diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
> index ecaacc8ed311..57e7b649e48b 100644
> --- a/drivers/usb/core/Kconfig
> +++ b/drivers/usb/core/Kconfig
> @@ -102,3 +102,12 @@ config USB_AUTOSUSPEND_DELAY
>  	  The default value Linux has always had is 2 seconds.  Change
>  	  this value if you want a different delay and cannot modify
>  	  the command line or module parameter.
> +
> +config USB_NOTIFICATIONS
> +	bool "Provide USB hardware event notifications"
> +	depends on USB && DEVICE_NOTIFICATIONS
> +	help
> +	  This option provides support for getting hardware event notifications
> +	  on USB devices and interfaces.  This makes use of the
> +	  /dev/watch_queue misc device to handle the notification buffer.
> +	  device_notify(2) is used to set/remove watches.
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 9063ede411ae..b8572e4d6a1b 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -41,6 +41,7 @@
>  #include <linux/dma-mapping.h>
>  #include <asm/byteorder.h>
>  #include <linux/moduleparam.h>
> +#include <linux/watch_queue.h>
>  
>  #include "usb.h"
>  
> @@ -2660,13 +2661,68 @@ static void usbdev_remove(struct usb_device *udev)
>  	}
>  }
>  
> +#ifdef CONFIG_USB_NOTIFICATIONS
> +static noinline void post_usb_notification(const char *devname,
> +					   enum usb_notification_type subtype,
> +					   u32 error)
> +{
> +	unsigned int gran = WATCH_LENGTH_GRANULARITY;
> +	unsigned int name_len, n_len;
> +	u64 id = 0; /* Might want to put a dev# here. */
> +
> +	struct {
> +		struct usb_notification n;
> +		char more_name[USB_NOTIFICATION_MAX_NAME_LEN -
> +			       (sizeof(struct usb_notification) -
> +				offsetof(struct usb_notification, name))];
> +	} n;
> +
> +	name_len = strlen(devname);
> +	name_len = min_t(size_t, name_len, USB_NOTIFICATION_MAX_NAME_LEN);
> +	n_len = round_up(offsetof(struct usb_notification, name) + name_len,
> +			 gran) / gran;
> +
> +	memset(&n, 0, sizeof(n));
> +	memcpy(n.n.name, devname, n_len);
> +
> +	n.n.watch.type		= WATCH_TYPE_USB_NOTIFY;
> +	n.n.watch.subtype	= subtype;
> +	n.n.watch.info		= n_len;
> +	n.n.error		= error;
> +	n.n.name_len		= name_len;
> +
> +	post_device_notification(&n.n.watch, id);
> +}
> +
> +void post_usb_device_notification(const struct usb_device *udev,
> +				  enum usb_notification_type subtype, u32 error)
> +{
> +	post_usb_notification(dev_name(&udev->dev), subtype, error);
> +}
> +
> +void post_usb_bus_notification(const struct usb_bus *ubus,
> +			       enum usb_notification_type subtype, u32 error)
> +{
> +	post_usb_notification(ubus->bus_name, subtype, error);
> +}
> +#endif
> +
>  static int usbdev_notify(struct notifier_block *self,
>  			       unsigned long action, void *dev)
>  {
>  	switch (action) {
>  	case USB_DEVICE_ADD:
> +		post_usb_device_notification(dev, NOTIFY_USB_DEVICE_ADD, 0);
>  		break;
>  	case USB_DEVICE_REMOVE:
> +		post_usb_device_notification(dev, NOTIFY_USB_DEVICE_REMOVE, 0);
> +		usbdev_remove(dev);
> +		break;
> +	case USB_BUS_ADD:
> +		post_usb_bus_notification(dev, NOTIFY_USB_BUS_ADD, 0);
> +		break;
> +	case USB_BUS_REMOVE:
> +		post_usb_bus_notification(dev, NOTIFY_USB_BUS_REMOVE, 0);
>  		usbdev_remove(dev);

This added call to usbdev_remove() results in a crash when running
the qemu "tosa" emulation. Removing the call fixes the problem.

Guenter
