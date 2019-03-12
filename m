From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 1/2] mm/mincore: make mincore() more conservative
Date: Tue, 12 Mar 2019 15:17:07 +0100
Message-ID: <20190312141708.6652-2-vbabka@suse.cz>
References: <20190130124420.1834-1-vbabka@suse.cz>
 <20190312141708.6652-1-vbabka@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190312141708.6652-1-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Vlastimil Babka <vbabka@suse.cz>, Josh Snyder <joshs@netflix.com>, Michal Hocko <mhocko@suse.com>, Jiri Kosina <jikos@kernel.org>
List-Id: linux-api@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

The semantics of what mincore() considers to be resident is not completely
clear, but Linux has always (since 2.3.52, which is when mincore() was
initially done) treated it as "page is available in page cache".

That's potentially a problem, as that [in]directly exposes meta-information
about pagecache / memory mapping state even about memory not strictly belonging
to the process executing the syscall, opening possibilities for sidechannel
attacks.

Change the semantics of mincore() so that it only reveals pagecache information
for non-anonymous mappings that belog to files that the calling process could
(if it tried to) successfully open for writing; otherwise we'd be including
shared non-exclusive mappings, which

- is the sidechannel

- is not the usecase for mincore(), as that's primarily used for data, not
  (shared) text

[mhocko@suse.com: restructure can_do_mincore() conditions]
Originally-by: Linus Torvalds <torvalds@linux-foundation.org>
Originally-by: Dominique Martinet <asmadeus@codewreck.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kevin Easton <kevin@guarana.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Cyril Hrubis <chrubis@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Daniel Gruss <daniel@gruss.cc>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Josh Snyder <joshs@netflix.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mincore.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 218099b5ed31..c3f058bd0faf 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -169,6 +169,22 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	return 0;
 }
 
+static inline bool can_do_mincore(struct vm_area_struct *vma)
+{
+	if (vma_is_anonymous(vma))
+		return true;
+	if (!vma->vm_file)
+		return false;
+	/*
+	 * Reveal pagecache information only for non-anonymous mappings that
+	 * correspond to the files the calling process could (if tried) open
+	 * for writing; otherwise we'd be including shared non-exclusive
+	 * mappings, which opens a side channel.
+	 */
+	return inode_owner_or_capable(file_inode(vma->vm_file)) ||
+		inode_permission(file_inode(vma->vm_file), MAY_WRITE) == 0;
+}
+
 /*
  * Do a chunk of "sys_mincore()". We've already checked
  * all the arguments, we hold the mmap semaphore: we should
@@ -189,8 +205,13 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
 	vma = find_vma(current->mm, addr);
 	if (!vma || addr < vma->vm_start)
 		return -ENOMEM;
-	mincore_walk.mm = vma->vm_mm;
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
+	if (!can_do_mincore(vma)) {
+		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
+		memset(vec, 1, pages);
+		return pages;
+	}
+	mincore_walk.mm = vma->vm_mm;
 	err = walk_page_range(addr, end, &mincore_walk);
 	if (err < 0)
 		return err;
-- 
2.20.1
