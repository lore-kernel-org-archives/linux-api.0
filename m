From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 17/21] userfaultfd: remap_pages: swp_entry_swapcount() preparation
Date: Thu,  5 Mar 2015 18:18:00 +0100
Message-ID: <1425575884-2574-18-git-send-email-aarcange@redhat.com>
References: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Android Kernel Team <kernel-team@android.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
List-Id: linux-api@vger.kernel.org

Provide a new swapfile method for remap_pages() to verify the swap
entry is mapped only in one vma before relocating the swap entry in a
different virtual address. Otherwise if the swap entry is mapped in
multiple vmas, when the page is swapped back in, it could get mapped
in a non linear way in some anon_vma.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/swap.h |  6 ++++++
 mm/swapfile.c        | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4759491..9adda11 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -436,6 +436,7 @@ extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
+extern int swp_entry_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
@@ -527,6 +528,11 @@ static inline int page_swapcount(struct page *page)
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
index 63f55cc..04c7621 100644
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

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
