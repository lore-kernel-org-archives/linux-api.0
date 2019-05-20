From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v2 6/7] mm: Introduce find_vma_filter_flags() helper
Date: Mon, 20 May 2019 17:00:34 +0300
Message-ID: <155836083406.2441.7999607190635457587.stgit@localhost.localdomain>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, ktkhai@virtuozzo.com, mhocko@suse.com, keith.busch@intel.com, kirill.shutemov@linux.intel.com, alexander.h.duyck@linux.intel.com, ira.weiny@intel.com, andreyknvl@google.com, arunks@codeaurora.org, vbabka@suse.cz, cl@linux.com, riel@surriel.com, keescook@chromium.org, hannes@cmpxchg.org, npiggin@gmail.com, mathieu.desnoyers@efficios.com, shakeelb@google.com, guro@fb.com, aarcange@redhat.com, hughd@google.com, jglisse@redhat.com, mgorman@techsingularity.net, daniel.m.jordan@oracle.com, jannh@google.com, kilobyte@angband.pl, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

This patch introduce a new helper, which returns
vma of enough length at given address, but only
if it does not contain passed flags.

v2: New

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 include/linux/mm.h |    3 +++
 mm/mremap.c        |   39 ++++++++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 54328d08dbdd..65ceb56acd44 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1515,6 +1515,9 @@ void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
+struct vm_area_struct *find_vma_without_flags(struct mm_struct *mm,
+		unsigned long addr, unsigned long len,
+		unsigned long prohibited_flags);
 #else
 static inline vm_fault_t handle_mm_fault(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags)
diff --git a/mm/mremap.c b/mm/mremap.c
index 9a96cfc28675..dabae6a70287 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -430,14 +430,37 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	return new_addr;
 }
 
+struct vm_area_struct *find_vma_without_flags(struct mm_struct *mm,
+		unsigned long addr, unsigned long len,
+		unsigned long prohibited_flags)
+{
+	struct vm_area_struct *vma = find_vma(mm, addr);
+
+	if (!vma || vma->vm_start > addr)
+		return ERR_PTR(-EFAULT);
+
+	/* vm area boundaries crossing */
+	if (len > vma->vm_end - addr)
+		return ERR_PTR(-EFAULT);
+
+	if (vma->vm_flags & prohibited_flags)
+		return ERR_PTR(-EFAULT);
+
+	return vma;
+}
+
 static struct vm_area_struct *vma_to_resize(unsigned long addr,
 	unsigned long old_len, unsigned long new_len, unsigned long *p)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma = find_vma(mm, addr);
-	unsigned long pgoff;
+	struct vm_area_struct *vma;
+	unsigned long pgoff, prohibited_flags = VM_HUGETLB;
 
-	if (!vma || vma->vm_start > addr)
+	if (old_len != new_len)
+		prohibited_flags |= VM_DONTEXPAND | VM_PFNMAP;
+
+	vma = find_vma_without_flags(mm, addr, old_len, prohibited_flags);
+	if (IS_ERR(vma))
 		return ERR_PTR(-EFAULT);
 
 	/*
@@ -453,13 +476,6 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (is_vm_hugetlb_page(vma))
-		return ERR_PTR(-EINVAL);
-
-	/* We can't remap across vm area boundaries */
-	if (old_len > vma->vm_end - addr)
-		return ERR_PTR(-EFAULT);
-
 	if (new_len == old_len)
 		return vma;
 
@@ -469,9 +485,6 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return ERR_PTR(-EINVAL);
 
-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
-		return ERR_PTR(-EFAULT);
-
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
 		locked = atomic64_read(&mm->locked_vm) << PAGE_SHIFT;
