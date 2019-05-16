From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: [PATCH RFC 3/5] mm/ksm: introduce ksm_madvise_unmerge() helper
Date: Thu, 16 May 2019 11:42:32 +0200
Message-ID: <20190516094234.9116-4-oleksandr@redhat.com>
References: <20190516094234.9116-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516094234.9116-1-oleksandr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Move MADV_UNMERGEABLE part of ksm_madvise() into a dedicated helper
since it will be further used for unmerging VMAs forcibly.

This does not bring any functional changes.

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 include/linux/ksm.h |  2 ++
 mm/ksm.c            | 32 ++++++++++++++++++++++----------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index e824b3141677..a91a7cfc87a1 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -21,6 +21,8 @@ struct mem_cgroup;
 #ifdef CONFIG_KSM
 int ksm_madvise_merge(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long *vm_flags);
+int ksm_madvise_unmerge(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, unsigned long *vm_flags);
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags);
 int __ksm_enter(struct mm_struct *mm);
diff --git a/mm/ksm.c b/mm/ksm.c
index 1fdcf2fbd58d..e0357e25e09f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2478,6 +2478,25 @@ int ksm_madvise_merge(struct mm_struct *mm, struct vm_area_struct *vma,
 	return 0;
 }
 
+int ksm_madvise_unmerge(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, unsigned long *vm_flags)
+{
+	int err;
+
+	if (!(*vm_flags & VM_MERGEABLE))
+		return 0;		/* just ignore the advice */
+
+	if (vma->anon_vma) {
+		err = unmerge_ksm_pages(vma, start, end);
+		if (err)
+			return err;
+	}
+
+	*vm_flags &= ~VM_MERGEABLE;
+
+	return 0;
+}
+
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags)
 {
@@ -2492,16 +2511,9 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		break;
 
 	case MADV_UNMERGEABLE:
-		if (!(*vm_flags & VM_MERGEABLE))
-			return 0;		/* just ignore the advice */
-
-		if (vma->anon_vma) {
-			err = unmerge_ksm_pages(vma, start, end);
-			if (err)
-				return err;
-		}
-
-		*vm_flags &= ~VM_MERGEABLE;
+		err = ksm_madvise_unmerge(vma, start, end, vm_flags);
+		if (err)
+			return err;
 		break;
 	}
 
-- 
2.21.0
