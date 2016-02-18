From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH v4] usb: devio: Add ioctl to disallow detaching kernel
 USB drivers.
Date: Thu, 18 Feb 2016 13:44:46 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1602181342370.1280-100000@iolanthe.rowland.org>
References: <1455500516-21590-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455500516-21590-1-git-send-email-emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, 14 Feb 2016, Emilio L=C3=B3pez wrote:

> From: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>=20
> The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntaril=
y
> relinquish the ability to issue other ioctls that may interfere with
> other processes and drivers that have claimed an interface on the
> device.
>=20
> This commit also includes a simple utility to be able to test the
> ioctl, located at Documentation/usb/usbdevfs-drop-permissions.c
>=20
> Example (with qemu-kvm's input device):
>=20
>     $ lsusb
>     ...
>     Bus 001 Device 002: ID 0627:0001 Adomax Technology Co., Ltd
>=20
>     $ usb-devices
>     ...
>     C:  #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D100mA
>     I:  If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D0=
2 Driver=3Dusbhid
>=20
>     $ sudo ./usbdevfs-drop-permissions /dev/bus/usb/001/002
>     OK: privileges dropped!
>     Available options:
>     [0] Exit now
>     [1] Reset device. Should fail if device is in use
>     [2] Claim 4 interfaces. Should succeed where not in use
>     [3] Narrow interface permission mask
>     Which option shall I run?: 1
>     ERROR: USBDEVFS_RESET failed! (1 - Operation not permitted)
>     Which test shall I run next?: 2
>     ERROR claiming if 0 (1 - Operation not permitted)
>     ERROR claiming if 1 (1 - Operation not permitted)
>     ERROR claiming if 2 (1 - Operation not permitted)
>     ERROR claiming if 3 (1 - Operation not permitted)
>     Which test shall I run next?: 0
>=20
> After unbinding usbhid:
>=20
>     $ usb-devices
>     ...
>     I:  If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D0=
2 Driver=3D(none)
>=20
>     $ sudo ./usbdevfs-drop-permissions /dev/bus/usb/001/002
>     ...
>     Which option shall I run?: 2
>     OK: claimed if 0
>     ERROR claiming if 1 (1 - Operation not permitted)
>     ERROR claiming if 2 (1 - Operation not permitted)
>     ERROR claiming if 3 (1 - Operation not permitted)
>     Which test shall I run next?: 1
>     OK: USBDEVFS_RESET succeeded
>     Which test shall I run next?: 0
>=20
> After unbinding usbhid and restricting the mask:
>=20
>     $ sudo ./usbdevfs-drop-permissions /dev/bus/usb/001/002
>     ...
>     Which option shall I run?: 3
>     Insert new mask: 0
>     OK: privileges dropped!
>     Which test shall I run next?: 2
>     ERROR claiming if 0 (1 - Operation not permitted)
>     ERROR claiming if 1 (1 - Operation not permitted)
>     ERROR claiming if 2 (1 - Operation not permitted)
>     ERROR claiming if 3 (1 - Operation not permitted)
>=20
> Signed-off-by: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Emilio L=C3=B3pez <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>

Acked-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
