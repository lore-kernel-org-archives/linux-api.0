From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 3/6] lib/bucket_locks: use kvmalloc_array()
Date: Thu, 31 May 2018 17:29:50 +0200
Message-ID: <20180531152950.GR15278@dhcp22.suse.cz>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-4-dave@stgolabs.net>
 <CA+55aFxvNCEBQsxfr=yL3jgxiC8M8wY2MHwVBH+T8qSWyP-WPg@mail.gmail.com>
 <20180529144317.GA20910@dhcp22.suse.cz>
 <20180529145106.GV27180@dhcp22.suse.cz>
 <CA+55aFxoC0+hKBQ_TmbXM_X60fnP8JKC3aVvGc=8bKh2oxL12g@mail.gmail.com>
 <20180530074216.GZ27180@dhcp22.suse.cz>
 <CA+55aFyu9HpoHcn0p6uaADOspTd2DKPYciAgHz+C6zwLBvVSJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyu9HpoHcn0p6uaADOspTd2DKPYciAgHz+C6zwLBvVSJA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Thu 31-05-18 10:01:51, Linus Torvalds wrote:
> On Wed, May 30, 2018 at 2:42 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > That being sad, if you believe that silently fixing up a code like that
> > is a good idea we can do the following of course:
> 
> Ack.
> 
> Except for:
> 
> > Linus argues that this just motivates people to do even
> > more hacks like
> >         if (gfp == GFP_KERNEL)
> >                 kvmalloc
> >         else
> >                 kmalloc
> >
> > I haven't seen this happening but it is true that we can grow those in
> > future.
> 
> This whole discussion came from the fact that YES, THIS IS ACTUALLY HAPPENING.
> 
> See lib/bucket_locks.c - it just uses gfpflags_allow_blocking()
> instead of explicitly checking for GFP_KERNEL (probably because the
> only two cases it actually deals with is GFP_ATOMIC and GFP_KERNEL).

OK, I haven't noticed this one and will fix it up. So what about the
following?

>From abc6ac9a690060d5ceda79e747c78d24cc7f2951 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 30 May 2018 09:34:39 +0200
Subject: [PATCH] mm: kvmalloc does not fallback to vmalloc for incompatible
 gfp flags

kvmalloc warned about incompatible gfp_mask to catch abusers (mostly
GFP_NOFS) with an intention that this will motivate authors of the code
to fix those. Linus argues that this just motivates people to do even
more hacks like
	if (gfp == GFP_KERNEL)
		kvmalloc
	else
		kmalloc

I haven't seen this happening much (bucket_lock special cases an atomic
allocation) but it is true that we can grow those in future. Therefore
Linus suggested to simply not fallback to vmalloc for incompatible gfp
flags and rather stick with the kmalloc path.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 lib/bucket_locks.c | 5 +----
 mm/util.c          | 6 ++++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/bucket_locks.c b/lib/bucket_locks.c
index 266a97c5708b..ade3ce6c4af6 100644
--- a/lib/bucket_locks.c
+++ b/lib/bucket_locks.c
@@ -30,10 +30,7 @@ int alloc_bucket_spinlocks(spinlock_t **locks, unsigned int *locks_mask,
 	}
 
 	if (sizeof(spinlock_t) != 0) {
-		if (gfpflags_allow_blocking(gfp))
-			tlocks = kvmalloc(size * sizeof(spinlock_t), gfp);
-		else
-			tlocks = kmalloc_array(size, sizeof(spinlock_t), gfp);
+		tlocks = kvmalloc_array(size, sizeof(spinlock_t), gfp);
 		if (!tlocks)
 			return -ENOMEM;
 		for (i = 0; i < size; i++)
diff --git a/mm/util.c b/mm/util.c
index 45fc3169e7b0..c6586c146995 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -391,7 +391,8 @@ EXPORT_SYMBOL(vm_mmap);
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
- * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm people.
+ * Please note that any use of gfp flags outside of GFP_KERNEL is careful to not
+ * fall back to vmalloc.
  */
 void *kvmalloc_node(size_t size, gfp_t flags, int node)
 {
@@ -402,7 +403,8 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
 	 * so the given set of flags has to be compatible.
 	 */
-	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
+	if ((flags & GFP_KERNEL) != GFP_KERNEL)
+		return kmalloc_node(size, flags, node);
 
 	/*
 	 * We want to attempt a large physically contiguous block first because
-- 
2.17.0

-- 
Michal Hocko
SUSE Labs
