From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 08/11] usb: Add USB subsystem notifications [ver #7]
Date: Wed, 04 Sep 2019 16:17:46 +0100
Message-ID: <1501.1567610266@warthog.procyon.org.uk>
References: <Pine.LNX.4.44L0.1909031316130.1859-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1909031316130.1859-100000@iolanthe.rowland.org>
Content-ID: <1500.1567610266.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: dhowells@redhat.com, Guenter Roeck <linux@roeck-us.net>, viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> wrote:

> > > Unfortunately, I don't know how to fix it and don't have much time to
> > > investigate it right now - and it's something that can be added back later.
> > 
> > The cause of your problem is quite simple:
> > 
> >  static int usbdev_notify(struct notifier_block *self,
> >  			       unsigned long action, void *dev)
> >  {
> >  	switch (action) {
> >  	case USB_DEVICE_ADD:
> > +		post_usb_device_notification(dev, NOTIFY_USB_DEVICE_ADD, 0);
> >  		break;
> >  	case USB_DEVICE_REMOVE:
> > +		post_usb_device_notification(dev, NOTIFY_USB_DEVICE_REMOVE, 0);
> > +		usbdev_remove(dev);
> > +		break;
> > +	case USB_BUS_ADD:
> > +		post_usb_bus_notification(dev, NOTIFY_USB_BUS_ADD, 0);
> > +		break;
> > +	case USB_BUS_REMOVE:
> > +		post_usb_bus_notification(dev, NOTIFY_USB_BUS_REMOVE, 0);
> >  		usbdev_remove(dev);
> >  		break;
> >  	}
> > 
> > The original code had usbdev_remove(dev) under the USB_DEVICE_REMOVE
> > case.  The patch mistakenly moves it, putting it under the
> ------------------------------^^^^^
> 
> Sorry, I should have said "duplicates" it.

Ah, thanks.  I'd already removed the USB bus notifications, so I'll leave them
out for now.

David
