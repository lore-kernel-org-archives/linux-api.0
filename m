From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/3] introduce new evdev interface type
Date: Mon, 30 Nov 2015 16:13:11 +0100
Message-ID: <3322044.DFSNLmiFGl@wuerfel>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org> <8705201.iaeQDTRocP@wuerfel> <DDC9234F-F89D-4112-BD68-FC6EFEC7E215@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DDC9234F-F89D-4112-BD68-FC6EFEC7E215@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Pingbo Wen <pingbo.wen@linaro.org>
Cc: y2038@lists.linaro.org, dmitry.torokhov@gmail.com, aksgarg1989@gmail.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sunday 29 November 2015 17:13:50 Pingbo Wen wrote:
> > =E5=9C=A8 2015=E5=B9=B411=E6=9C=8828=E6=97=A5=EF=BC=8C00:58=EF=BC=8C=
Arnd Bergmann <arnd@arndb.de> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Friday 27 November 2015 18:00:29 WEN Pingbo wrote:
> >> To solve the y2038 problem in input_event, I had some attempts bef=
ore [1],
> >> and this is the second one.
> >>=20
> >> We can force userspace to use monotonic time in event timestamp, s=
o the
> >> 'struct timeval' is enough to keep y2038-safe, as Arnd suggested. =
But we
> >> can not find a way to make kernel compatible with old binaries, wh=
ich use
> >> realtime, and there are still some devices, which depend on realti=
me.
> >>=20
> >> So I get a idea to add a new evdev interface, which is y2038 safe.=
 And
> >> userspace can switch between the old and new interface via ioctl.
> >>=20
> >> The patch series add three evdev interface type:
> >>=20
> >> - EV_IF_LEGACY
> >>  send event by input_event. This is the default option, keep kerne=
l
> >>  backward compatible.
> >=20
> > The problem I see with this approach is that it still breaks any
> > legacy source code that is compiled with a new libc that uses 64-bi=
t
> > time_t. If we are requiring source code changes for building users
> > of input devices with a new libc, we can easily get them to handle
> > the overflow (they normally only care about the microsecond portion
> > anyway, so it doesn't matter in most cases), or to use monotonic ti=
me.
>=20
> I don=E2=80=99t think so.
>=20
> Actually, from the view of userspace, EV_IF_LEGACY interface is work
> exactly the same as old evdev. We didn=E2=80=99t change anything in i=
nput_event
> and input_event_compat. And the problem you said will still be there,
> even without those patches.

I think we're still talking past one another. I thought we had establis=
hed
that

1. the current interface is broken when time_t changes in user space
2. we can fix it by redefining struct input_event in a way that
   is independent of time_t
3. once both user space and kernel are using the same ABI independent
   of time_t, we can look improving the timestamps so they don't
   overflow
4. the monotonic timestamp interface already avoids the overflow, so
   it would be sufficient as a solution for 3.

Where did I lose you here? Did you find any other facts that I
was missing? I don't know whether the two new event structures make
the interface better in some other way, but it seems mostly unrelated
to either of the two problems we already have with time_t (the
ABI mismatch, and the use of non-monotonic timestamps).

	Arnd
