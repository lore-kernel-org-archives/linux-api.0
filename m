From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 6/7] [RFC] [media]: v4l2: introduce v4l2_timeval
Date: Wed, 16 Sep 2015 09:56:21 +0200
Message-ID: <7758607.pJFdek7ljg@wuerfel>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de> <2432018.5rA5LXfiBo@wuerfel> <55F91162.8030002@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F91162.8030002-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wednesday 16 September 2015 08:51:14 Hans Verkuil wrote:

> > a) Similar to my first attempt, define a new struct v4l2_timeval, but
> >    only use it when building with a y2038-aware libc, so we don't break
> >    existing environments:
> > 
> > 	/* some compile-time conditional that we first need to agree on with libc */
> > 	#if __BITS_PER_TIME_T > __BITS_PER_LONG
> > 	struct v4l2_timeval { long tv_sec; long tv_usec; }
> > 	#else
> > 	#define v4l2_timeval timeval
> > 	#endif
> > 
> >    This means that any user space that currently assumes the timestamp
> >    member to be a 'struct timeval' has to be changed to access the members
> >    individually, or get a build error.
> >    The __BITS_PER_TIME_T trick has to be used in a couple of other subsystems
> >    too, as some of them have no other way to identify an interface
> 
> I don't like this as this means some applications will compile on 64 bit or
> with a non-y2038-aware libc, but fail on a 32-bit with y2038-aware libc. This
> will be confusing and it may take a long time before the application developer
> discovers this.

Right.

> > b) Keep the header file unchanged, but deal with both formats of v4l2_buffer
> >    in the kernel. Fortunately, all ioctls that pass a v4l2_buffer have
> >    properly defined command codes, and it does not get passed using a
> >    read/write style interface. This means we move the v4l2_buffer32
> >    handling from v4l2-compat-ioctl32.c to v4l2-ioctl.c and add an in-kernel
> >    v4l2_buffer64 that matches the 64-bit variant of v4l2_buffer.
> >    This way, user space can use either definition of time_t, and the
> >    kernel will just handle them natively.
> >    This is going to be the most common way to handle y2038 compatibility
> >    in device drivers, and it has the additional advantage of simplifying
> >    the compat path.
> 
> This would work.

Ok. So the only downside I can think of for this is that it uses a slightly
less efficient format with additional padding in it. The kernel side will
be a little ugly as I'm trying to avoid defining a generic timeval64
structure (the generic syscalls should not need one), but I'll try to
implement it first to see how it ends up.

> > c) As you describe above, introduce a new v4l2_buffer replacement with
> >    a different layout that does not reference timeval. For this case, I
> >    would recommend using a single 64-bit nanosecond timestamp that can
> >    be generated using ktime_get_ns().
> >    However, to avoid ambiguity with the user space definition of struct
> >    timeval, we still have to hide the existing 'struct v4l2_buffer' from
> >    y2038-aware user space by enclosing it in '#if __BITS_PER_TIME_T > 
> >    __BITS_PER_LONG' or similar.
> 
> Right, and if we do that we still have the problem I describe under a). So we
> would need to implement b) regardless.
> 
> In other words, choosing c) doesn't depend on y2038 and it should be decided
> on its own merits.
> 
> I've proposed this as a topic to the media workshop we'll have during the Linux
> Kernel Summit.

Thanks, good idea. I'll be at the kernel summit, but don't plan to attend
the media workshop otherwise. If you let me know about the schedule, I can
come to this session (or ping me on IRC or hangout when it starts).

	Arnd
