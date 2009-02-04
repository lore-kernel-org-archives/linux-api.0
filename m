From: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Date: Thu, 5 Feb 2009 12:59:07 +1300
Message-ID: <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	 <20090204150507.665b5b7c.akpm@linux-foundation.org>
	 <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
	 <20090204152434.c8f65d52.akpm@linux-foundation.org>
	 <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
	 <20090204155514.6abbdc8f.akpm@linux-foundation.org>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090204155514.6abbdc8f.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 5, 2009 at 12:55 PM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, 4 Feb 2009 15:27:45 -0800 (PST)
> Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org> wrote:
>
>> On Wed, 4 Feb 2009, Andrew Morton wrote:
>>
>> > On Wed, 4 Feb 2009 15:18:43 -0800 (PST)
>> > Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org> wrote:
>> >
>> > > > > Simple test here:
>> > > > >
>> > > > > http://www.xmailserver.org/eventfd-sem.c
>> > > > >
>> > > > >
>> > > > > Signed-off-by: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
>> > > > >
>> > > > > +/*
>> > > > > + * CAREFUL: Check include/asm-generic/fcntl.h when defining
>> > > > > + * new flags, since they might collide with O_* ones. We want
>> > > > > + * to re-use O_* flags that couldn't possibly have a meaning
>> > > > > + * from eventfd, in order to leave a free define-space for
>> > > > > + * shared O_* flags.
>> > > > > + */
>> > > > > +#define EFD_SEMAPHORE (1 << 0)
>> > > > >  #define EFD_CLOEXEC O_CLOEXEC
>> > > > >  #define EFD_NONBLOCK O_NONBLOCK
>> > > > >
>> > > > > +#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
>> > > > > +#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
>> > > >
>> > > > How would you recommend that userspace determine whether its kernel
>> > > > supports this feature, bearing in mind that someone might backport this
>> > > > patch into arbitrarily earlier kernel versions?
>> > > >
>> > > > What should be userspace's fallback strategy if that support is not
>> > > > present?
>> > >
>> > > #ifdef EFD_SEMAPHORE, maybe?
>> >
>> > That's compile-time.  People who ship binaries will probably want
>> > to find a runtime thing for back-compatibility.
>>
>> I dunno. How do they actually do when we add new flags, like the O_ ones?
>>
>
> Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
> that work in this case?

As youll have seen by now, Ulrich and I noted that it works.

> If so, it would be sensible to mention this in
> the description somewhere as the approved probing method and to
> maintain it.

I'll add something to the man page, as this patch progresses.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
