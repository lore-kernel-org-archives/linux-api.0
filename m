From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3] usb: devio: Add ioctl to disallow detaching kernel
 USB drivers.
Date: Thu, 4 Feb 2016 11:27:57 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1602041122340.1515-100000@iolanthe.rowland.org>
References: <1454556057-18956-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454556057-18956-1-git-send-email-emilio.lopez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez@collabora.co.uk>
Cc: gregkh@linuxfoundation.org, kborer@gmail.com, bjorn@mork.no, reillyg@chromium.org, keescook@chromium.org, linux-api@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jorgelo@chromium.org, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org

On Thu, 4 Feb 2016, Emilio L=C3=B3pez wrote:

> From: Reilly Grant <reillyg@chromium.org>
>=20
> The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntaril=
y
> relinquish the ability to issue other ioctls that may interfere with
> other processes and drivers that have claimed an interface on the
> device.
>=20
> Signed-off-by: Reilly Grant <reillyg@chromium.org>
> Signed-off-by: Emilio L=C3=B3pez <emilio.lopez@collabora.co.uk>
>=20
> ---
>=20
> Changes in v3:
> - Switch ioctl to use a __u32 given the iface qty is capped at 32
> - Reword comments as requested by Alan
> - Allow callers to shrink the allowed interfaces mask

> @@ -624,6 +626,10 @@ static int claimintf(struct usb_dev_state *ps, u=
nsigned int ifnum)
>  	if (test_bit(ifnum, &ps->ifclaimed))
>  		return 0;
> =20
> +	if (ps->privileges_dropped
> +	 && !test_bit(ifnum, &ps->interface_allowed_mask))

Continuation lines in this file are indented by 2 tab stops, not 1=20
space.

> @@ -1198,6 +1202,27 @@ static int proc_connectinfo(struct usb_dev_sta=
te *ps, void __user *arg)
> =20
>  static int proc_resetdevice(struct usb_dev_state *ps)
>  {
> +	struct usb_host_config *actconfig =3D ps->dev->actconfig;
> +	struct usb_interface *interface;
> +	int i, number;
> +
> +	/* Don't allow a device reset if the process has dropped the
> +	 * privilege to do such things and any of the interfaces are
> +	 * currently claimed.
> +	 */
> +	if (ps->privileges_dropped && actconfig) {
> +		for (i =3D 0; i < actconfig->desc.bNumInterfaces; ++i) {
> +			interface =3D actconfig->interface[i];
> +			number =3D interface->cur_altsetting->desc.bInterfaceNumber;
> +			if (usb_interface_claimed(interface)) {

The test should be:

			if (usb_interface_claimed(interface) &&
					!test_bit(number, &ps->ifclaimed)) {

We don't want to prevent people from resetting a device merely because=20
they have claimed an interface.  Only if someone else has claimed one.

> +				dev_warn(&ps->dev->dev,
> +					"usbfs: interface %d claimed by %s while '%s' resets device\n",
> +					number,	interface->dev.driver->name, current->comm);
> +				return -EACCES;
> +			}
> +		}
> +	}
> +
>  	return usb_reset_device(ps->dev);
>  }

Also, it wouldn't hurt to change proc_get_capabilities() and
include/uapi/linux/usbdevicefs.h to add a USBDEVFS_CAP_DROP_PRIVILEGES
bit.

Alan Stern
