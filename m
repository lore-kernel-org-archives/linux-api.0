From: chrubis-AlSwsSmVLrQ@public.gmane.org
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Date: Wed, 2 Apr 2014 12:45:17 +0200
Message-ID: <20140402104517.GA20656@rei>
References: <533B04A9.6090405@bbn.com>
 <533B1439.3010403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <533B1439.3010403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Richard Hansen <rhansen-A08e6c8yq/Q@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Troxel <gdt-2FjktZCtrC/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!
> > and there's no good
> > reason to believe that this behavior would have persisted
> > indefinitely.
> > 
> > The msync(2) man page (as currently written in man-pages.git) is
> > silent on the behavior if both flags are unset, so this change should
> > not break an application written by somone who carefully reads the
> > Linux man pages or the POSIX spec.
> 
> Sadly, people do not always carefully read man pages, so there
> remains the chance that a change like this will break applications.
> Aside from standards conformance, what do you see as the benefit
> of the change?

I've looked around Linux Test Project and this change will break a few
testcases, but nothing that couldn't be easily fixed.

The rest of the world may be more problematic though.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
