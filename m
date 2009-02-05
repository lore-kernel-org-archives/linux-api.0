From: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Date: Wed, 4 Feb 2009 16:02:45 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902041600170.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>  <20090204150507.665b5b7c.akpm@linux-foundation.org>  <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>  <20090204152434.c8f65d52.akpm@linux-foundation.org>
 <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>  <20090204155514.6abbdc8f.akpm@linux-foundation.org> <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0902041559l4c40d9b6k704068337a00df7a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 5 Feb 2009, Michael Kerrisk wrote:

> > Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
> > that work in this case?
> 
> As youll have seen by now, Ulrich and I noted that it works.
> 
> > If so, it would be sensible to mention this in
> > the description somewhere as the approved probing method and to
> > maintain it.
> 
> I'll add something to the man page, as this patch progresses.

I see we already have stuff like this inside the man pages:

O_CLOEXEC (Since Linux 2.6.23)
          Enable the close-on-exec flag for the new file descriptor.  
          ...

Maybe a similar note for the new flag?



- Davide


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
