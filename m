From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 3/6] lib/bucket_locks: use kvmalloc_array()
Date: Wed, 30 May 2018 09:42:16 +0200
Message-ID: <20180530074216.GZ27180@dhcp22.suse.cz>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-4-dave@stgolabs.net>
 <CA+55aFxvNCEBQsxfr=yL3jgxiC8M8wY2MHwVBH+T8qSWyP-WPg@mail.gmail.com>
 <20180529144317.GA20910@dhcp22.suse.cz>
 <20180529145106.GV27180@dhcp22.suse.cz>
 <CA+55aFxoC0+hKBQ_TmbXM_X60fnP8JKC3aVvGc=8bKh2oxL12g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxoC0+hKBQ_TmbXM_X60fnP8JKC3aVvGc=8bKh2oxL12g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Tue 29-05-18 15:46:25, Linus Torvalds wrote:
[...]
> The whole and ONLY point of "kvmalloc()" and friends is to make it easy to
> write code and _not_ have those idiotic "let's do kmalloc or kvmalloc
> depending on the phase of the moon" garbage. So the warning has literally
> destroyed the only value that function has!

Well, I do agree but I've also seen terrible things while doing the
conversion when introducing kvmalloc.

So I admit that the defensive mode here is mostly inspired by existing
users of vmalloc(GFP_NOFS). They are simply wrong and not really
eager to be fixed from my experience. Now with kvmalloc fixing them
up silently it would get even less likely to get fixed because there
won't be any deadlock possible (compared to open coded kvmalloc like
ext4_kvmalloc for example).

My experience also tells me that most of those vmalloc NOFS users
simply do not need NOFS at all because there is no risk of the reclaim
recursion deadlocks. They are just used because of cargo cult which is
sad and it causes some subtle problems for the direct reclaim. I would
really like to eliminate those (e.g. see [1]).  It is sad reality that
people tend to be more sensitive to WARN splats than "look this is wrong
albeit not critical in most cases).

[1] http://lkml.kernel.org/r/20180424162712.GL17484@dhcp22.suse.cz

That being sad, if you believe that silently fixing up a code like that
is a good idea we can do the following of course:

>From c1a098e809a109800f9cfa63cb27fe9a78f3f316 Mon Sep 17 00:00:00 2001
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

I haven't seen this happening but it is true that we can grow those in
future. Therefore Linus suggested to simply not fallback to vmalloc for
incompatible gfp flags and rather stick with the kmalloc path.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
