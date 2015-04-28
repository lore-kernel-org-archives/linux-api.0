From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Should mmap MAP_LOCKED fail if mm_poppulate fails?
Date: Tue, 28 Apr 2015 20:35:36 +0200
Message-ID: <20150428183535.GB30918@dhcp22.suse.cz>
References: <20150114095019.GC4706@dhcp22.suse.cz>
 <1430223111-14817-1-git-send-email-mhocko@suse.cz>
 <CA+55aFxzLXx=cC309h_tEc-Gkn_zH4ipR7PsefVcE-97Uj066g@mail.gmail.com>
 <20150428164302.GI2659@dhcp22.suse.cz>
 <CA+55aFydkG-BgZzry5DrTzueVh9VvEcVJdLV8iOyUphQk=0vpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFydkG-BgZzry5DrTzueVh9VvEcVJdLV8iOyUphQk=0vpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 28-04-15 09:57:11, Linus Torvalds wrote:
> On Tue, Apr 28, 2015 at 9:43 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> >
> > Hmm, no other thread has the address from the current mmap call except
> > for MAP_FIXED (more on that below).
> 
> With things like opportunistic SIGSEGV handlers that map/unmap things
> as the user takes faults, that's actually not at all guaranteed.
> 
> Yeah, it's unusual, but I've seen it, with threaded applications where
> people play games with user-space memory management, and do "demand
> allocation" with mmap() in response to signals.

I am still not sure I see the problem here. Let's say we have a
userspace page fault handler which would do mmap(fault_addr, MAP_FIXED),
right?

If we had a racy mmap(NULL, MAP_LOCKED) that could have mapped
fault_addr by the time handler does its work then this is buggy wrt. to
MAP_LOCKED semantic because the fault handler would discard the locked
part. This wouldn't lead to a data loss but still makes MAP_LOCKED usage
buggy IMO.

If the racing thread did mmap(around_fault_addr, MAP_FIXED|MAP_LOCKED)
then it would be broken as well, and even worse I would say, because the
original fault could have been discarded and data lost.

I would expect that user fault handlers would be synchronized with
other mmap activity otherwise I have hard time to see how this can all
have a well defined behavior. Especially when MAP_FIXED is involved.

> Admittedly we already do bad things in mmap(MAP_FIXED) for that case,
> since we dropped the vm lock. But at least it shouldn't be any worse
> than a thread speculatively touching the pages..

Actually we already allow to mmap(MAP_FIXED) to fail after
discarding an existing mmaped area (see mmap_region and e.g.
security_vm_enough_memory_mm or other failure cases).
-- 
Michal Hocko
SUSE Labs
