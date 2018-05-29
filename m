From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 3/6] lib/bucket_locks: use kvmalloc_array()
Date: Tue, 29 May 2018 16:51:06 +0200
Message-ID: <20180529145106.GV27180@dhcp22.suse.cz>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-4-dave@stgolabs.net>
 <CA+55aFxvNCEBQsxfr=yL3jgxiC8M8wY2MHwVBH+T8qSWyP-WPg@mail.gmail.com>
 <20180529144317.GA20910@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144317.GA20910@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Tue 29-05-18 16:43:17, Michal Hocko wrote:
> On Thu 24-05-18 14:37:36, Linus Torvalds wrote:
> > On Thu, May 24, 2018 at 2:28 PM Davidlohr Bueso <dave@stgolabs.net> wrote:
> > 
> > >                  if (gfpflags_allow_blocking(gfp))
> > > -                       tlocks = kvmalloc(size * sizeof(spinlock_t), gfp);
> > > +                       tlocks = kvmalloc_array(size, sizeof(spinlock_t),
> > gfp);
> > >                  else
> > >                          tlocks = kmalloc_array(size, sizeof(spinlock_t),
> > gfp);
> > 
> > Side note: how about we just move that "gfpflags_allow_blocking()" into
> > kvmalloc() instead, and make kvmalloc() generally usable?
> > 
> > Now we have that really odd situation where kvmalloc() takes gfp flags, but
> > to quote the comment:
> > 
> >   * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm
> > people.
> > 
> > and the code:
> > 
> >          /*
> >           * vmalloc uses GFP_KERNEL for some internal allocations (e.g page
> > tables)
> >           * so the given set of flags has to be compatible.
> >           */
> >          WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
> > 
> > which isn't really all that helpful. Do mm people really want to be
> > consulted about random uses?
> 
> The purpose was to have a clean usage base after the conversion. If we
> are growing a non-trivial use base which wants to use GFP_NOWAIT semantic
> then sure we can make kvmalloc never fallback to vmallock. But see
> below...
> 
> > Maybe we could just make the rule for kvmalloc() be to only fall back on
> > vmalloc for allocations that are
> > 
> >   - larger than page size
> > 
> >   - blocking and allow GFP_KERNEL (so basically that WARN_ON_ONCE() logic in
> > kvmalloc_node).
> > 
> > Hmm? Isn't that what everybody really *wants* kvmalloc() and friends to do?
> 
> ... Well, there are users who would like to use kvmalloc for
> GFP_NOFS/GFP_NOIO context. Do we want them to fail more likely for
> larger order rather than have them fixed (to either drop the NOFS
> because it just has been blindly copied from a different code without
> too much thinking or use the scope NOFS/NOIO API)? A warn_on tends to be
> rather harsh but effective way to push maintainers fix their broken
> code...

In other words, what about the following?

diff --git a/mm/util.c b/mm/util.c
index 45fc3169e7b0..05706e18d201 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -391,6 +391,10 @@ EXPORT_SYMBOL(vm_mmap);
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
+ * GFP_NOWAIT request never fallback to vmalloc but it is accepted for convenience
+ * to not force people open conding kmalloc fallback on !gfpflags_allow_blocking
+ * requests.
+ *
  * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm people.
  */
 void *kvmalloc_node(size_t size, gfp_t flags, int node)
@@ -402,7 +406,7 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
 	 * so the given set of flags has to be compatible.
 	 */
-	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
+	WARN_ON_ONCE((flags & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO));
 
 	/*
 	 * We want to attempt a large physically contiguous block first because
@@ -427,6 +431,9 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
+	if (!gfpflags_allow_blocking(flags))
+		return NULL;
+
 	return __vmalloc_node_flags_caller(size, node, flags,
 			__builtin_return_address(0));
 }
-- 
Michal Hocko
SUSE Labs
