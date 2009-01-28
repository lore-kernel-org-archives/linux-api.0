From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Wed, 28 Jan 2009 04:14:39 +0100
Message-ID: <20090128031439.GA11025@redhat.com>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090127165504.53ed7a2d.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/27, Andrew Morton wrote:
>
> On Fri, 23 Jan 2009 05:56:46 +0100
> Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:
>
> > On Thu, Jan 22, 2009 at 03:32:49PM -0500, Christoph Hellwig wrote:
> > > On Thu, Jan 22, 2009 at 06:51:04AM -0800, Andrew Morton wrote:
> > > > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > > > straightforwad.  But it's really really sad.  It basically leaves a great
> > > > big FIXME in there.  It'd be better to fix it.
> > >
> > >
> > > Umm, we've been discussiong this in and out a guestimated million times.
> > >
> > > Let's go forward with Jon's patch which is on obvious improvement and
> > > if it shows problems later on we can revisit it.
> >
> > The point was that we already have a better patch from Oleg.
> >
>
> Where is this patch?

I didn't send the actual patch. The idea is,

	can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
	and I won't insist if you don't like is.

		static inline int try_lock_f_flags(struct file *file)
		{
			return !test_and_set_bit(O_LOCK_FLAGS, file->f_flags);
		}

		static inline set_f_flags(struct file *file, unsigned int flags)
		{
			file->f_flags = flags & ~O_LOCK_FLAGS;
		}

	Now, nobody should change ->f_flags directly (except create/open
	pathes. For example, ioctl_fionbio() should be changed:

			if (try_lock_f_flags(filp)) {
				if (on)
					set_f_flags(filp, filp->f_flags | flag);
				else
					set_f_flags(filp, filp->f_flags & ~flag);
			}

	If try_lock_f_flags() fails we do nothing, as if the current owner of
	O_LOCK_FLAGS changes ->f_flags after us.

and, from another message,

	No need to disable preemption, we never spin waiting for the
	lock bit. If it is locked - somebody else updates ->f_flags,
	we can pretend it does this after us. This can confuse F_GETFL
	after F_SETFL (if F_SETFL "fails"), but I think in that case
	user-space is wrong anyway, it must not do F_GETFL in parallel.

I'll try to make the patch tomorrow, but the problem is that I am not
sure this is not too ugly. At least Jonathan dislikes this approach,
and I do understand him ;)

Oleg.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
