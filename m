From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH v2] usb: devio: Add ioctl to disallow detaching kernel
 USB drivers.
Date: Fri, 22 Jan 2016 11:10:43 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1601221101490.1626-100000@iolanthe.rowland.org>
References: <1453420476-26125-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453420476-26125-1-git-send-email-emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 21 Jan 2016, Emilio L=C3=B3pez wrote:

> From: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>=20
> The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntaril=
y
> relinquish the ability to issue other ioctls that may interfere with
> other processes and drivers that have claimed an interface on the
> device.
>=20
> Signed-off-by: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Emilio L=C3=B3pez <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>


>  static int proc_resetdevice(struct usb_dev_state *ps)
>  {
> +	struct usb_host_config *actconfig =3D ps->dev->actconfig;
> +	struct usb_interface *interface;
> +	int i, number;
> +
> +	/* Don't touch the device if any interfaces are claimed. It
> +	 * could interfere with other drivers' operations and this
> +	 * process has dropped its privileges to do such things.
> +	 */

This comment should be rephrased.  It should say something like:
"Don't allow if the process has dropped its privilege to do such
things and any of the interfaces are claimed."

You also might consider allowing the reset if the interfaces are
claimed only by the current process (or more precisely, by ps).

> +static int proc_drop_privileges(struct usb_dev_state *ps, void __use=
r *arg)
> +{
> +	struct usbdevfs_drop_privs data;
> +
> +	if (copy_from_user(&data, arg, sizeof(data)))
> +		return -EFAULT;
> +
> +	/* This is a one way operation. Once privileges were dropped,
> +	 * you cannot do it again (Otherwise unprivileged processes
> +	 * would be able to change their allowed interfaces mask)
> +	 */

If you're going to keep a mask of claimable interfaces then there's no
reason this has to be a one-time operation.  Processes should always be
allowed to shrink the mask, just not to grow it.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
