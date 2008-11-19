From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Wed, 19 Nov 2008 17:53:51 +0300
Message-ID: <20081119145351.GA2652@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081118131937.GC16944@lst.de> <20081119140500.GA25968@ioremap.net> <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Michael.

On Wed, Nov 19, 2008 at 09:34:46AM -0500, Michael Kerrisk (mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org) wrote:
> > So effectively you propose to have second generation of the inotify
> > which will have additional pid field, which will be unused by all but
> > the same uid events?
> 
> I susepect that Christoph wants the same thing as I do: some thinking
> towards a future-proof design, rather than a quick hack to address the needs
> of a single application.

So far the only real need is a pid. That will solve the cases I'm
working on and it may be interesting for other applications. It is
possible to extend read/write IO with offset and size parameters though.

Do you see any other possible extensions?

> > If you want to return -EPERM, than it will be _always_ returned for non
> > sysadmin capable user, which effectively makes it unusable.
> >
> Again, appropriate flags in inotify_init1() could fix this -- e.g., only
> fill the field (and give an error if no perms) if a flag is set.

Um, hmm... Permission is _always_ denied for 'alien' IO, as it was
pointed by Robert, at init time there is no way to know, will there be
alien IO (i.e. originated by the process with different uid) or not.
More on this: inotify initialization is just a memory allocation in
the kernel, nothing more.

We can argue about object insertion into inotify queue though. But
again, we check already that it has read permissions, and if so, we are
allowed to receive notificatons about IO against given target, since if
new code will return for whatever reason -EPERM, people will use old
code.

So, putting PID/whatever else into event can be flag-driven, but there
is no way to return EPERM anywhere in the call chain not breaking
backward compatibility of the whole idea.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
