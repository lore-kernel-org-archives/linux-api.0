From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC 1/3] mm: mmap make MAP_LOCKED really mlock semantic
Date: Tue, 28 Apr 2015 16:10:01 -0700
Message-ID: <20150428161001.e854fb3eaf82f738865130af@linux-foundation.org>
References: <20150114095019.GC4706@dhcp22.suse.cz>
	<1430223111-14817-1-git-send-email-mhocko@suse.cz>
	<1430223111-14817-2-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430223111-14817-2-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 28 Apr 2015 14:11:49 +0200 Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:

> The man page however says
> "
> MAP_LOCKED (since Linux 2.5.37)
>       Lock the pages of the mapped region into memory in the manner of
>       mlock(2).  This flag is ignored in older kernels.
> "

I'm trying to remember why we implemented MAP_LOCKED in the first
place.  Was it better than mmap+mlock in some fashion?

afaict we had a #define MAP_LOCKED in the header file but it wasn't
implemented, so we went and wired it up.  13 years ago:
https://lkml.org/lkml/2002/9/18/108


Anyway...  the third way of doing this is to use plain old mmap() while
mlockall(MCL_FUTURE) is in force.  Has anyone looked at that, checked
that the behaviour is sane and compared it with the mmap+mlock
behaviour, the MAP_LOCKED behaviour and the manpages?
