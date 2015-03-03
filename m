From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] Drivers: hv: kvp: convert userspace/kernel
 communication to using char device
Date: Tue, 3 Mar 2015 20:47:07 +0100
Message-ID: <20150303194707.GG25123@potion.brq.redhat.com>
References: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
 <1425053665-635-2-git-send-email-vkuznets@redhat.com>
 <20150227202715.GF2034@potion.brq.redhat.com>
 <87pp8qif00.fsf@vitty.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87pp8qif00.fsf-hpI3/L/TUU23oHxwIazZmlaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-03-03 10:53+0100, Vitaly Kuznetsov:
> Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> > 2015-02-27 17:14+0100, Vitaly Kuznetsov:
> >> Re-implement the communication using misc char device. Use ioctl t=
o do
> >> kernel/userspace version negotiation (doesn't make much sense at t=
his moment
> >> as we're breaking backwards compatibility but can be used in futur=
e).
> >
> > The ioctl is used too creatively for my liking: as an out-of-band
> > communication that is required after the main channel has been open=
ed.
> > It would be simpler to inject the version into first x bytes of the
> > stream, making a read() after open() mandatory.
>=20
> We need to perform a handshake - kernel part sends its version and
> receives daemon's version.

(We could also design a backward-compatible protocol, which should be
 possible for an application this simple, but keeping options is wise.)

>                            We can definitelly pack everything in the
> data stream but why do we need to avoid ioctls?

I think it is better if the kernel sends its version (set of features)
first, so it would be just a simple two-way handshake.

Kernel-initiated communication is not possible over ioctl and it doesn'=
t
give extra options for handshake either.

>                                                 It seems to me the
> handshake we're performing here belongs to a 'control' stream, not
> 'data' stream.

Handshake makes sense after we open the device and before any 'data' ca=
n
appear on it, so multiplexing the same carrier also prevents a lot of
stupid cases, like ioctls from different applications.
Not to mention that asynchronicity itself has a fairly bad record.

(I don't really understand the difference between 'control' and 'data'.=
)
