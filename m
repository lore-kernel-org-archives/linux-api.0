From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/17] mm: swp_entry_swapcount
Date: Fri,  3 Oct 2014 19:08:01 +0200
Message-ID: <1412356087-16115-12-git-send-email-aarcange@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412356087-16115-1-git-send-email-aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "\\\"Dr. David Alan Gilbert\\\"" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Robert Love <rlove-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Adamushko <dmitry.adamushko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mike Hommey <mh-YmoObPS1fuhg9hUCZPvPmw@public.gmane.org>, Taras Glek <tglek-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minc
List-Id: linux-api@vger.kernel.org

Provide a new swapfile method for remap_anon_pages to verify the swap
entry is mapped only in one vma before relocating the swap entry in a
different virtual address. Otherwise if the swap entry is mapped
in multiple vmas, when the page is swapped back in, it could get
mapped in a non linear way in some anon_vma.

Signed-off-by: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/swap.h |  6 ++++++
 mm/swapfile.c        | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8197452..af9977c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -458,6 +458,7 @@ extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
+extern int swp_entry_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
@@ -559,6 +560,11 @@ static inline int page_swapcount(struct page *page)
 	return 0;
 }
 
+static inline int swp_entry_swapcount(swp_entry_t entry)
+{
+	return 0;
+}
+
 #define reuse_swap_page(page)	(page_mapcount(page) == 1)
 
 static inline int try_to_free_swap(struct page *page)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8798b2e..4cc9af6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -874,6 +874,19 @@ int page_swapcount(struct page *page)
 	return count;
 }
 
+int swp_entry_swapcount(swp_entry_t entry)
+{
+	int count = 0;
+	struct swap_info_struct *p;
+
+	p = swap_info_get(entry);
+	if (p) {
+		count = swap_count(p->swap_map[swp_offset(entry)]);
+		spin_unlock(&p->lock);
+	}
+	return count;
+}
+
 /*
  * We can write to an anon page without COW if there are no other references
  * to it.  And as a side-effect, free up its swap: because the old content
