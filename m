From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [RFC PATCH] mmap.2: clarify MAP_LOCKED semantic (was: Re: Should
 mmap MAP_LOCKED fail if mm_poppulate fails?)
Date: Wed, 29 Apr 2015 13:38:18 +0200
Message-ID: <20150429113818.GC16097@dhcp22.suse.cz>
References: <20150114095019.GC4706@dhcp22.suse.cz>
 <1430223111-14817-1-git-send-email-mhocko@suse.cz>
 <CA+55aFxzLXx=cC309h_tEc-Gkn_zH4ipR7PsefVcE-97Uj066g@mail.gmail.com>
 <20150428164302.GI2659@dhcp22.suse.cz>
 <CA+55aFydkG-BgZzry5DrTzueVh9VvEcVJdLV8iOyUphQk=0vpw@mail.gmail.com>
 <20150428183535.GB30918@dhcp22.suse.cz>
 <CA+55aFyajquhGhw59qNWKGK4dBV0TPmDD7-1XqPo7DZWvO_hPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyajquhGhw59qNWKGK4dBV0TPmDD7-1XqPo7DZWvO_hPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 28-04-15 11:38:35, Linus Torvalds wrote:
> On Tue, Apr 28, 2015 at 11:35 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> >
> > I am still not sure I see the problem here.
> 
> Basically, I absolutely hate the notion of us doing something
> unsynchronized, when I can see us undoing a mmap that another thread
> is doing. It's wrong.

OK, I have checked the mmap(2) man page and there is no single mention
about multi-threaded usage. So even though I personally think that
user fault handlers which do mmap(MAP_FIXED) without synchronization
to parallel mmaps are broken by definition we cannot simply rule them
out and it is not the kernel job to make them broken even more or in a
subtly different way.
So here is an RFC for the man page patch. I am not very good in the
format but man doesn't complain about any formating issues.
---
>From 903ed733187afaa4d27fef3c24f413304494411c Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Wed, 29 Apr 2015 11:02:19 +0200
Subject: [RFC PATCH] mmap.2: clarify MAP_LOCKED semantic

MAP_LOCKED had a subtly different semantic from mmap(2)+mlock(2) since
it has been introduced.
mlock(2) fails if the memory range cannot get populated to guarantee
that no future major faults will happen on the range. mmap(MAP_LOCKED) on
the other hand silently succeeds even if the range was populated only
partially.

Fixing this subtle difference in the kernel is rather awkward because
the memory population happens after mm locks have been dropped and so
the cleanup before returning failure (munlock) could operate on something
else than the originally mapped area.

E.g. speculative userspace page fault handler catching SEGV and doing
mmap(fault_addr, MAP_FIXED|MAP_LOCKED) might discard portion of a racing
mmap and lead to lost data. Although it is not clear whether such a
usage would be valid, mmap page doesn't explicitly describe requirements
for threaded applications so we cannot exclude this possibility.

This patch makes the semantic of MAP_LOCKED explicit and suggest using
mmap + mlock as the only way to guarantee no later major page faults.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 man2/mmap.2 | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/man2/mmap.2 b/man2/mmap.2
index 54d68cf87e9e..1486be2e96b3 100644
--- a/man2/mmap.2
+++ b/man2/mmap.2
@@ -235,8 +235,19 @@ See the Linux kernel source file
 for further information.
 .TP
 .BR MAP_LOCKED " (since Linux 2.5.37)"
-Lock the pages of the mapped region into memory in the manner of
+Mark the mmaped region to be locked in the same way as
 .BR mlock (2).
+This implementation will try to populate (prefault) the whole range but
+the mmap call doesn't fail with
+.B ENOMEM
+if this fails. Therefore major faults might happen later on. So the semantic
+is not as strong as
+.BR mlock (2).
+.BR mmap (2)
++
+.BR mlock (2)
+should be used when major faults are not acceptable after the initialization
+of the mapping.
 This flag is ignored in older kernels.
 .\" If set, the mapped pages will not be swapped out.
 .TP
-- 
2.1.4

-- 
Michal Hocko
SUSE Labs
