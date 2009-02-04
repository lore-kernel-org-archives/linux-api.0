From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Date: Wed, 4 Feb 2009 15:24:34 -0800
Message-ID: <20090204152434.c8f65d52.akpm@linux-foundation.org>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	<20090204150507.665b5b7c.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.1.10.0902041509060.6214-GPJ85BhbkB8RepQJljzAVbITYcZ0+W3JAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 4 Feb 2009 15:18:43 -0800 (PST)
Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org> wrote:

> > > Simple test here:
> > > 
> > > http://www.xmailserver.org/eventfd-sem.c
> > > 
> > > 
> > > Signed-off-by: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
> > > 
> > > +/*
> > > + * CAREFUL: Check include/asm-generic/fcntl.h when defining
> > > + * new flags, since they might collide with O_* ones. We want
> > > + * to re-use O_* flags that couldn't possibly have a meaning
> > > + * from eventfd, in order to leave a free define-space for
> > > + * shared O_* flags.
> > > + */
> > > +#define EFD_SEMAPHORE (1 << 0)
> > >  #define EFD_CLOEXEC O_CLOEXEC
> > >  #define EFD_NONBLOCK O_NONBLOCK
> > >  
> > > +#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
> > > +#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
> > 
> > How would you recommend that userspace determine whether its kernel
> > supports this feature, bearing in mind that someone might backport this
> > patch into arbitrarily earlier kernel versions?
> > 
> > What should be userspace's fallback strategy if that support is not
> > present?
> 
> #ifdef EFD_SEMAPHORE, maybe?

That's compile-time.  People who ship binaries will probably want
to find a runtime thing for back-compatibility.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
