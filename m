From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3] usb: devio: Add ioctl to disallow detaching kernel
 USB drivers.
Date: Wed, 3 Feb 2016 19:46:43 -0800
Message-ID: <20160204034643.GA17786@kroah.com>
References: <1453420476-26125-1-git-send-email-emilio.lopez@collabora.co.uk>
 <1454556057-18956-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454556057-18956-1-git-send-email-emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bjorn-yOkvZcmFvRU@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 04, 2016 at 12:20:57AM -0300, Emilio L=F3pez wrote:
> From: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>=20
> The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntaril=
y
> relinquish the ability to issue other ioctls that may interfere with
> other processes and drivers that have claimed an interface on the
> device.
>=20
> Signed-off-by: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Emilio L=F3pez <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
>=20
> ---
>=20
> Changes in v3:
> - Switch ioctl to use a __u32 given the iface qty is capped at 32
> - Reword comments as requested by Alan
> - Allow callers to shrink the allowed interfaces mask

No documentation?  Proof it works?  Test scripts?

This isn't a trivial feature to add, how do we know it is correct?

thanks,

greg k-h
