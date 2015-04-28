From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Should mmap MAP_LOCKED fail if mm_poppulate fails?
Date: Tue, 28 Apr 2015 14:11:48 +0200
Message-ID: <1430223111-14817-1-git-send-email-mhocko@suse.cz>
References: <20150114095019.GC4706@dhcp22.suse.cz>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150114095019.GC4706-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,
it seems that the initial email got lost (or ignored). I would like to
revive it again. I've cooked up a potential fix to this issue which will
follow as a reply to this email.

The first patch is dumb and straightforward. It should be safe as is and
also good without the follow up 2 patches which try to handle potential
allocation failures in the do_munmap path more gracefully. As we still
do not fail small allocations even the first patch could be simplified
a bit and the retry loop replaced by a BUG_ON right away. But I felt this
would better be done robust.

An obvious alternative would be patching the man pages to mention the
subtle difference between mlock and MAP_LOCKED semantic. I have checked
debian code search and it shown some applications relying on MAP_LOCKED
but I have no idea whether they really require the mlock all-or-nothing
fault in semantic.

Any thoughts, ideas?
