From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [Y2038] [PATCH 0/3] introduce new evdev interface type
Date: Thu, 03 Dec 2015 13:56:32 +0100
Message-ID: <2642116.RNDaIWhxZX@wuerfel>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org> <1BB6B3AD-F547-49F8-886A-56EF80CE62FE@linaro.org> <3471947.HA9TBa0js5@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3471947.HA9TBa0js5@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: Pingbo Wen <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aksgarg1989-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday 03 December 2015 13:54:47 Arnd Bergmann wrote:
> > > struct input_event {
> > > #if !defined(__KERNEL__) && __TIME_T_BITS == __BITS_PER_LONG
> > >        struct timeval time;
> > 
> > > #else
> > >     struct {
> > >             union {
> > >                     __u32 tv_sec __attribute__((deprecated));
> > >                     __u32 tv_sec_monotonic;
> > >             };
> > >             __s32 tv_usec;
> > >     } time;
> > > #endif
> > >        __u16 type;
> > >        __u16 code;
> > >        __s32 value;
> > > };
> > 
> > I have one question here, if userspace use this structure, all helper functions
> > of timeval will not work. And userspace need to write extra helper function for
> > this fake timeval. This just create an another urgly time structure.
> 
> Correct, this is a useful side-effect of the change: any user space access to
> the event->time member that assumes it's a timeval will cause a compile-time
> warning or error (depending on the access), which helps us identify the
> broken code and fix it to use monotonic times as well as access the right
> struct members.
> 

To clarify, the code also intentionally only changes the types when
we are compiling with a new 32-bit libc: everything that builds today
will continue to build and work without warnings, unless it gets
recompiled with 64-bit time_t and needs to be fixed.

	Arnd
