From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Date: Wed, 4 Feb 2009 16:18:16 -0800
Message-ID: <20090204161816.b93a4588.akpm@linux-foundation.org>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	<20090204150507.665b5b7c.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
	<20090204152434.c8f65d52.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
	<20090204155514.6abbdc8f.akpm@linux-foundation.org>
	<cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0902041559l4c40d9b6k704068337a00df7a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 5 Feb 2009 12:59:07 +1300
Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:

> >> > > > What should be userspace's fallback strategy if that support is not
> >> > > > present?
> >> > >
> >> > > #ifdef EFD_SEMAPHORE, maybe?
> >> >
> >> > That's compile-time.  People who ship binaries will probably want
> >> > to find a runtime thing for back-compatibility.
> >>
> >> I dunno. How do they actually do when we add new flags, like the O_ ones?
> >>
> >
> > Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
> > that work in this case?
> 
> As youll have seen by now, Ulrich and I noted that it works.

I think you means "should work" ;)

We're talking about this, yes?

SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
{
	int fd;
	struct eventfd_ctx *ctx;

	/* Check the EFD_* constants for consistency.  */
	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);

	if (flags & ~(EFD_CLOEXEC | EFD_NONBLOCK))
		return -EINVAL;

That looks like it should work to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
