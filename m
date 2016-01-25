From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH v2] usb: devio: Add ioctl to disallow detaching kernel
 USB drivers.
Date: Mon, 25 Jan 2016 10:46:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1601251040340.1849-100000@iolanthe.rowland.org>
References: <8737tln08x.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8737tln08x.fsf-lbf33ChDnrE/G1V5fR+Y7Q@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn-yOkvZcmFvRU@public.gmane.org>
Cc: Emilio =?utf-8?Q?L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 25 Jan 2016, Bj=C3=B8rn Mork wrote:

> Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> writes:
> > On Mon, 25 Jan 2016, Bj=C3=B8rn Mork wrote:
> >
> >> I don't feel much like an expert here, but I can certainly make up=
 an
> >> opinion anyway :)
> >>=20
> >> Since 64bits kernels allow usb devio with interface numbers up to =
63, I
> >> guess you need __u64 to avoid limiting the range?  Limiting will c=
reate
> >> all sorts of followup problems, so it's definitely easiest to just=
 go
> >> with __u64.
> >
> > But the Linux USB stack only allows up to 32 interfaces (see
> > include/linux/usb.h):
> >
> > /* this maximum is arbitrary */
> > #define USB_MAXINTERFACES	32
>=20
>=20
> Ah, I totally missed that.  Thanks
>=20
>=20
> > So there's no point using a 64-bit value.
> >
> > On the other hand, this value is supposed to be the same size as=20
> > ps->ifclaimed, which is used as an argument to clear_bit(), set_bit=
(),=20
> > and test_bit().  Those routines require unsigned long.
>=20
> Maybe the input to these should be clamped to USB_MAXINTERFACES?

If you want.  Right now it's clamped to 8 * sizeof(ps->ifclaimed),
which ought to be good enough.

Oh yes, there's one other thing to notice.  The value passed to these
routines is an interface number (as opposed to an index).  According to
the USB spec, interfaces are supposed to be numbered sequentially
starting from 0, but there may be some devices that mess this up.  So
it's possible we'll see an interface number which is larger than the
number of interfaces!  :-)

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
