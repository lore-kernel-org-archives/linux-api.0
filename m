From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 8/9] usb: Add USB subsystem notifications [ver #5]
Date: Wed, 3 Jul 2019 19:07:38 +0200
Message-ID: <20190703170738.GA24672@kroah.com>
References: <156173690158.15137.3985163001079120218.stgit@warthog.procyon.org.uk>
 <156173698939.15137.11150923486478934112.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156173698939.15137.11150923486478934112.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 28, 2019 at 04:49:49PM +0100, David Howells wrote:
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
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: linux-usb@vger.kernel.org

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
