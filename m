From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/21] userfaultfd: remap_pages: rmap preparation
Date: Thu,  5 Mar 2015 18:17:59 +0100
Message-ID: <1425575884-2574-17-git-send-email-aarcange@redhat.com>
References: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425575884-2574-1-git-send-email-aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhang.zhanghailiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Robert Love <rlove-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Adamushko <dmitry.adamushko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mike Hommey <mh-YmoObPS1fuhg9hUCZPvPmw@public.gmane.org>, Taras Glek <tglek-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org>, Jan
List-Id: linux-api@vger.kernel.org

As far as the rmap code is concerned, rmap_pages only alters the
page->mapping and page->index. It does it while holding the page
lock. However there are a few places that in presence of anon pages
are allowed to do rmap walks without the page lock (split_huge_page
and page_referenced_anon). Those places that are doing rmap walks
without taking the page lock first, must be updated to re-check that
the page->mapping didn't change after they obtained the anon_vma
lock. remap_pages takes the anon_vma lock for writing before altering
the page->mapping, so if the page->mapping is still the same after
obtaining the anon_vma lock (without the page lock), the rmap walks
can go ahead safely (and remap_pages will wait them to complete before
proceeding).

remap_pages serializes against itself with the page lock.

All other places taking the anon_vma lock while holding the mmap_sem
for writing, don't need to check if the page->mapping has changed
after taking the anon_vma lock, regardless of the page lock, because
remap_pages holds the mmap_sem for reading.

There's one constraint enforced to allow this simplification: the
source pages passed to remap_pages must be mapped only in one vma, but
this is not a limitation when used to handle userland page faults. The
source addresses passed to remap_pages should be set as VM_DONTCOPY
with MADV_DONTFORK to avoid any risk of the mapcount of the pages
increasing, if fork runs in parallel in another thread, before or
while remap_pages runs.

Signed-off-by: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/huge_memory.c | 23 +++++++++++++++++++----
 mm/rmap.c        |  9 +++++++++
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8f1b6a5..1e25cb3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1902,6 +1902,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct anon_vma *anon_vma;
 	int ret = 1;
+	struct address_space *mapping;
 
 	BUG_ON(is_huge_zero_page(page));
 	BUG_ON(!PageAnon(page));
@@ -1913,10 +1914,24 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	 * page_lock_anon_vma_read except the write lock is taken to serialise
 	 * against parallel split or collapse operations.
 	 */
-	anon_vma = page_get_anon_vma(page);
-	if (!anon_vma)
-		goto out;
-	anon_vma_lock_write(anon_vma);
+	for (;;) {
+		mapping = ACCESS_ONCE(page->mapping);
+		anon_vma = page_get_anon_vma(page);
+		if (!anon_vma)
+			goto out;
+		anon_vma_lock_write(anon_vma);
+		/*
+		 * We don't hold the page lock here so
+		 * remap_pages_huge_pmd can change the anon_vma from
+		 * under us until we obtain the anon_vma lock. Verify
+		 * that we obtained the anon_vma lock before
+		 * remap_pages did.
+		 */
+		if (likely(mapping == ACCESS_ONCE(page->mapping)))
+			break;
+		anon_vma_unlock_write(anon_vma);
+		put_anon_vma(anon_vma);
+	}
 
 	ret = 0;
 	if (!PageCompound(page))
diff --git a/mm/rmap.c b/mm/rmap.c
index 5e3e090..5ab2df1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -492,6 +492,7 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
+repeat:
 	rcu_read_lock();
 	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
@@ -530,6 +531,14 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 	rcu_read_unlock();
 	anon_vma_lock_read(anon_vma);
 
+	/* check if remap_anon_pages changed the anon_vma */
+	if (unlikely((unsigned long) ACCESS_ONCE(page->mapping) != anon_mapping)) {
+		anon_vma_unlock_read(anon_vma);
+		put_anon_vma(anon_vma);
+		anon_vma = NULL;
+		goto repeat;
+	}
+
 	if (atomic_dec_and_test(&anon_vma->refcount)) {
 		/*
 		 * Oops, we held the last refcount, release the lock
