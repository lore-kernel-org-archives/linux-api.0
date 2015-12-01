From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/3] introduce new evdev interface type
Date: Tue, 01 Dec 2015 11:47:52 +0100
Message-ID: <6792470.H7eb3IQorJ@wuerfel>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org> <3322044.DFSNLmiFGl@wuerfel> <CB4E5A6F-D514-4D3B-9C95-13A52C509EC9@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CB4E5A6F-D514-4D3B-9C95-13A52C509EC9-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pingbo Wen <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, aksgarg1989-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 01 December 2015 16:34:00 Pingbo Wen wrote:
> Hi, Arnd
>=20
> >>>>=20
> >>>> The patch series add three evdev interface type:
> >>>>=20
> >>>> - EV_IF_LEGACY
> >>>> send event by input_event. This is the default option, keep kern=
el
> >>>> backward compatible.
> >>>=20
> >>> The problem I see with this approach is that it still breaks any
> >>> legacy source code that is compiled with a new libc that uses 64-=
bit
> >>> time_t. If we are requiring source code changes for building user=
s
> >>> of input devices with a new libc, we can easily get them to handl=
e
> >>> the overflow (they normally only care about the microsecond porti=
on
> >>> anyway, so it doesn't matter in most cases), or to use monotonic =
time.
> >>=20
> >> I don=E2=80=99t think so.
> >>=20
> >> Actually, from the view of userspace, EV_IF_LEGACY interface is wo=
rk
> >> exactly the same as old evdev. We didn=E2=80=99t change anything i=
n input_event
> >> and input_event_compat. And the problem you said will still be the=
re,
> >> even without those patches.
> >=20
> > I think we're still talking past one another. I thought we had esta=
blished
> > that
> >=20
> > 1. the current interface is broken when time_t changes in user spac=
e
>=20
> What kinds of changes in time_t? Extending it to 64-bits in both kern=
el
> and userspace? Ok, I get confused here, if there are some sample code=
s
> or use-cases here, it will help me a lot.

We don't change time_t in the kernel, we just try to replace it
with time64_t, or ktime_t where appropriate.

What I meant is the problem when glibc defines their time_t to
be 'long long' so that user space can be built that runs after
2038. This changes the timeval and timespec definitions, so
a process that tries to use 'struct input_event' has a different
layout compared to what the kernel has.

I though that we had already discussed that multiple times.

> > 2. we can fix it by redefining struct input_event in a way that
> >   is independent of time_t
> > 3. once both user space and kernel are using the same ABI independe=
nt
> >   of time_t, we can look improving the timestamps so they don't
> >   overflow
> > 4. the monotonic timestamp interface already avoids the overflow, s=
o
> >   it would be sufficient as a solution for 3.
> >=20
> > Where did I lose you here? Did you find any other facts that I
> > was missing? I don't know whether the two new event structures make
> > the interface better in some other way, but it seems mostly unrelat=
ed
> > to either of the two problems we already have with time_t (the
> > ABI mismatch, and the use of non-monotonic timestamps).
>=20
> It seems we are mismatch here.
>=20
> Actually input_composite_event has the similar structure with input_e=
vent,
> but with a nicer definition, which can take both monotonic and non-mo=
notonic
> timestamps safely.
>=20
> What I assumed here, is that leaving EV_IF_LEGACY as a untouched, dep=
recated
> interface. If userspace try to adapt to new libc and kernel, it shoul=
d move
> to new interface. The userspace can do a lazy update, keep the code u=
ntouched,
> but suffer the y2038 problem by itself.

=46orcing the move to the new API is very ugly, because you can't do it
in a way that works on old kernels as well, unless you then try to supp=
ort
both APIs at runtime.

Just requiring user space to switch to monotonic time is easily done,
as it can likely work either way.

> We can force kernel using monotonic time in EV_IF_LEGACY interface, a=
nd
> making input_event independent from time_t(after evdev has converted =
to
> input_value, it=E2=80=99s easy to do that), but that also imply users=
pace
> must change their code to fit this change. If changing userspace code=
 is
> a mandatory option, why not to force them do a complete conversion?

Most user space programs won't care, as they don't even look at the tv_=
sec
portion, and the goal is to avoid having to change them.

There is still an open question to how exactly we want to get user spac=
e
to change.

We could do some compile-time trick by having a union in struct input_e=
vent
and mark the existing timeval part as deprecated, so we flag any use of=
 the
32-bit tv_sec member, such as:

struct input_event {
#if !defined(__KERNEL__) && __TIME_T_BITS =3D=3D __BITS_PER_LONG
        struct timeval time;
#else
	struct {
		union {
			__u32 tv_sec __attribute__((deprecated));
			__u32 tv_sec_monotonic;
		};
		__s32 tv_usec;
	} time;
#endif
        __u16 type;
        __u16 code;
        __s32 value;
};

Another option is to do a runtime change, and always set the time field
to zero when the kernel is built without support for 32-bit time_t
and user space has not yet called the ioctl to change to monotonic time=
=2E

We can also do a combination of the two.

	Arnd
