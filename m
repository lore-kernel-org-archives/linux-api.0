From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [Y2038] [PATCH 0/3] introduce new evdev interface type
Date: Thu, 03 Dec 2015 13:54:47 +0100
Message-ID: <3471947.HA9TBa0js5@wuerfel>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org> <6792470.H7eb3IQorJ@wuerfel> <1BB6B3AD-F547-49F8-886A-56EF80CE62FE@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1BB6B3AD-F547-49F8-886A-56EF80CE62FE-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: Pingbo Wen <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aksgarg1989-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday 03 December 2015 20:49:06 Pingbo Wen wrote:
> > =E5=9C=A8 2015=E5=B9=B412=E6=9C=881=E6=97=A5=EF=BC=8C18:47=EF=BC=8C=
Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> =E5=86=99=E9=81=93=EF=BC=9A
> > On Tuesday 01 December 2015 16:34:00 Pingbo Wen wrote:
> >> We can force kernel using monotonic time in EV_IF_LEGACY interface=
, and
> >> making input_event independent from time_t(after evdev has convert=
ed to
> >> input_value, it=E2=80=99s easy to do that), but that also imply us=
erspace
> >> must change their code to fit this change. If changing userspace c=
ode is
> >> a mandatory option, why not to force them do a complete conversion=
?
> >=20
> > Most user space programs won't care, as they don't even look at the=
 tv_sec
> > portion, and the goal is to avoid having to change them.
> >=20
> > There is still an open question to how exactly we want to get user =
space
> > to change.
> >=20
> > We could do some compile-time trick by having a union in struct inp=
ut_event
> > and mark the existing timeval part as deprecated, so we flag any us=
e of the
> > 32-bit tv_sec member, such as:
> >=20
> > struct input_event {
> > #if !defined(__KERNEL__) && __TIME_T_BITS =3D=3D __BITS_PER_LONG
> >        struct timeval time;
>=20
> > #else
> > 	struct {
> > 		union {
> > 			__u32 tv_sec __attribute__((deprecated));
> > 			__u32 tv_sec_monotonic;
> > 		};
> > 		__s32 tv_usec;
> > 	} time;
> > #endif
> >        __u16 type;
> >        __u16 code;
> >        __s32 value;
> > };
>=20
> I have one question here, if userspace use this structure, all helper=
 functions
> of timeval will not work. And userspace need to write extra helper fu=
nction for
> this fake timeval. This just create an another urgly time structure.

Correct, this is a useful side-effect of the change: any user space acc=
ess to
the event->time member that assumes it's a timeval will cause a compile=
-time
warning or error (depending on the access), which helps us identify the
broken code and fix it to use monotonic times as well as access the rig=
ht
struct members.

> And this method also forces most of old binaries to compile with new =
libc, adjust
> their codes with new fake time structure.
>=20
> Besides, I get an idea to combine your structure with input_composite=
_event:
>=20
> union {
> 	struct {
> 		__s32 tv_usec;
> 		__s32 tv_sec;
> 	};
> 	__s64 time;
> } time;
>=20
> I prefer to use a single s64 timestamp, if our goal is to remove time=
val from kernel.

We can't really remove this instance of timeval anyway, so adding an __=
s64 member
here is not all that helpful. We should use __s64 nanoseconds for new i=
nterfaces
like this, but I see no reason to change the one we have here.

	Arnd
