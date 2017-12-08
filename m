From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Fri, 8 Dec 2017 21:31:31 +0100
Message-ID: <20171208203131.GA16196@rei>
References: <20171130065835.dbw4ajh5q5whikhf@dhcp22.suse.cz>
 <20171201152640.GA3765@rei>
 <87wp20e9wf.fsf@concordia.ellerman.id.au>
 <20171206045433.GQ26021@bombadil.infradead.org>
 <20171206070355.GA32044@bombadil.infradead.org>
 <87bmjbks4c.fsf@concordia.ellerman.id.au>
 <CAGXu5jLWRQn6EaXEEvdvXr+4gbiJawwp1EaLMfYisHVfMiqgSA@mail.gmail.com>
 <20171207195727.GA26792@bombadil.infradead.org>
 <87shclh3zc.fsf@concordia.ellerman.id.au>
 <20171208142714.GB7793@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171208142714.GB7793@amd>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Abdul Haleem <abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!
> > If we had a time machine, the right set of flags would be:
> > 
> >   - MAP_FIXED:   don't treat addr as a hint, fail if addr is not free
> >   - MAP_REPLACE: replace an existing mapping (or force or clobber)
> 
> Actually, if we had a time machine... would we even provide
> MAP_REPLACE functionality?

I did a bit of archeology just beacause we can and since there is a git
repository of the unix history [1].

The first version of mmap() seems to appear in BSD-4_2-Snapshot there was no
MAP_FIXED flag and the addr is expected to be used for the mapping. At least
that is what manual seems to say, the kernel code is not written at this point.
This seems to correspond to a time when Berkley students were busy rewriting
UNIX kernel to take advantage of the VAX's virtual memory.

The MAP_FIXED arrived to the manual shortly after, probably someone figured out
that passing an address to the call does not make much sense in most of the
cases.

The first actual implementation that supports MAP_FIXED appeared in the
BSD-4_3_Reno-Snapshot and already includes the replace behavior. The original
purpose seems to be replacing mappings in the implementation of the execve()
call.

So the answer would probably be yes but it would probably made sense to keep it
as kernel internal flag.

And BTW it looks like HPUX got it right before it was changed to follow POSIX.
There seems to be HPUX compatibility code in the early BSD codebase that
contains both HPUXMAP_FIXED and HPUXMAP_REPLACE.

[1] https://github.com/dspinellis/unix-history-repo

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
