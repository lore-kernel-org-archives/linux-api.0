From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: RE: [PATCH 08/11] usb: Add USB subsystem notifications [ver #7]
Date: Wed, 4 Sep 2019 01:53:01 +0000
Message-ID: <TYAPR01MB45441054C3956CCA7BBD80CBD8B80@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
 <156717350329.2204.7056537095039252263.stgit@warthog.procyon.org.uk>
 <TYAPR01MB4544829484474FC61E850F32D8B90@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <20190903093720.GD12325@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190903093720.GD12325@kroah.com>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, "raven@themaw.net" <raven@themaw.net>, Christian Brauner <christian@brauner.io>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Greg,

> From: Greg Kroah-Hartman, Sent: Tuesday, September 3, 2019 6:37 PM
<snip>
> > > +void post_usb_bus_notification(const struct usb_bus *ubus,
> >
> > This function's argument is struct usb_bus *, but ...
> >
> > > +			       enum usb_notification_type subtype, u32 error)
> > > +{
> > > +	post_usb_notification(ubus->bus_name, subtype, error);
> > > +}
> > > +#endif
> > > +
> > >  static int usbdev_notify(struct notifier_block *self,
> > >  			       unsigned long action, void *dev)
> > >  {
> > >  	switch (action) {
> > >  	case USB_DEVICE_ADD:
> > > +		post_usb_device_notification(dev, NOTIFY_USB_DEVICE_ADD, 0);
> > >  		break;
> > >  	case USB_DEVICE_REMOVE:
> > > +		post_usb_device_notification(dev, NOTIFY_USB_DEVICE_REMOVE, 0);
> > > +		usbdev_remove(dev);
> > > +		break;
> > > +	case USB_BUS_ADD:
> > > +		post_usb_bus_notification(dev, NOTIFY_USB_BUS_ADD, 0);
> > > +		break;
> > > +	case USB_BUS_REMOVE:
> > > +		post_usb_bus_notification(dev, NOTIFY_USB_BUS_REMOVE, 0);
> > >  		usbdev_remove(dev);
> >
> > this function calls usbdev_remove() with incorrect argument if the acti=
on
> > is USB_BUS_REMOVE. So, this seems to cause the following issue [1] on
> > my environment (R-Car H3 / r8a7795 on next-20190902) [2]. However, I ha=
ve
> > no idea how to fix the issue, so I report this issue at the first step.
>=20
> As a few of us just discussed this on IRC, these bus notifiers should
> probably be dropped as these are the incorrect structure type as you
> found out.  Thanks for the report.

Thank you for the discussion. I got it.

Best regards,
Yoshihiro Shimoda

> greg k-h
