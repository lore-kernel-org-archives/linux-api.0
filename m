From: Brian Geffon <bgeffon@google.com>
Subject: [PATCH v4] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Fri,  7 Feb 2020 12:18:56 -0800
Message-ID: <20200207201856.46070-1-bgeffon@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Brian Geffon <bgeffon@google.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Will Deacon <will@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Sonny Rao <sonnyrao@google.com>, Minchan Kim <minchan@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, Yu Zhao <yuzhao@google.com>, Jesse Barnes <jsbarnes@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Florian Weimer <fweimer@redhat.com>, "Kirill A . Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is
set, the source mapping will not be removed. Instead it will be
cleared as if a brand new anonymous, private mapping had been created
atomically as part of the mremap() call. =C2=A0If a userfaultfd was watchin=
g
the source, it will continue to watch the new mapping. =C2=A0For a mapping
that is shared or not anonymous, MREMAP_DONTUNMAP will cause the
mremap() call to fail. Because MREMAP_DONTUNMAP always results in moving
a VMA you MUST use the MREMAP_MAYMOVE flag. The final result is two
equally sized VMAs where the destination contains the PTEs of the source.

We hope to use this in Chrome OS where with userfaultfd we could write
an anonymous mapping to disk without having to STOP the process or worry
about VMA permission changes.

This feature also has a use case in Android, Lokesh Gidra has said
that "As part of using userfaultfd for GC, We'll have to move the physical
pages of the java heap to a separate location. For this purpose mremap
will be used. Without the MREMAP_DONTUNMAP flag, when I mremap the java
heap, its virtual mapping will be removed as well. Therefore, we'll
require performing mmap immediately after. This is not only time consuming
but also opens a time window where a native thread may call mmap and
reserve the java heap's address range for its own usage. This flag
solves the problem."
        =C2=A0 =C2=A0
Signed-off-by: Brian Geffon <bgeffon@google.com>
---
 include/uapi/linux/mman.h |  5 +-
 mm/mremap.c               | 98 ++++++++++++++++++++++++++++++---------
 2 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
index fc1a64c3447b..923cc162609c 100644
--- a/include/uapi/linux/mman.h
+++ b/include/uapi/linux/mman.h
@@ -5,8 +5,9 @@
 #include <asm/mman.h>
 #include <asm-generic/hugetlb_encode.h>
=20
-#define MREMAP_MAYMOVE	1
-#define MREMAP_FIXED	2
+#define MREMAP_MAYMOVE		1
+#define MREMAP_FIXED		2
+#define MREMAP_DONTUNMAP	4
=20
 #define OVERCOMMIT_GUESS		0
 #define OVERCOMMIT_ALWAYS		1
diff --git a/mm/mremap.c b/mm/mremap.c
index 122938dcec15..9f4aa17f178b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -318,8 +318,8 @@ unsigned long move_page_tables(struct vm_area_struct *v=
ma,
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
 		unsigned long new_len, unsigned long new_addr,
-		bool *locked, struct vm_userfaultfd_ctx *uf,
-		struct list_head *uf_unmap)
+		bool *locked, unsigned long flags,
+		struct vm_userfaultfd_ctx *uf, struct list_head *uf_unmap)
 {
 	struct mm_struct *mm =3D vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -408,11 +408,41 @@ static unsigned long move_vma(struct vm_area_struct *=
vma,
 	if (unlikely(vma->vm_flags & VM_PFNMAP))
 		untrack_pfn_moved(vma);
=20
+	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
+		if (vm_flags & VM_ACCOUNT) {
+			/* Always put back VM_ACCOUNT since we won't unmap */
+			vma->vm_flags |=3D VM_ACCOUNT;
+
+			vm_acct_memory(vma_pages(new_vma));
+		}
+
+		/*
+		 * locked_vm accounting: if the mapping remained the same size
+		 * it will have just moved and we don't need to touch locked_vm
+		 * because we skip the do_unmap. If the mapping shrunk before
+		 * being moved then the do_unmap on that portion will have
+		 * adjusted vm_locked. Only if the mapping grows do we need to
+		 * do something special; the reason is locked_vm only accounts
+		 * for old_len, but we're now adding new_len - old_len locked
+		 * bytes to the new mapping.
+		 */
+		if (new_len > old_len)
+			mm->locked_vm +=3D (new_len - old_len) >> PAGE_SHIFT;
+
+		goto out;
+	}
+
 	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		vm_unacct_memory(excess >> PAGE_SHIFT);
 		excess =3D 0;
 	}
+
+	if (vm_flags & VM_LOCKED) {
+		mm->locked_vm +=3D new_len >> PAGE_SHIFT;
+		*locked =3D true;
+	}
+out:
 	mm->hiwater_vm =3D hiwater_vm;
=20
 	/* Restore VM_ACCOUNT if one or two pieces of vma left */
@@ -422,16 +452,12 @@ static unsigned long move_vma(struct vm_area_struct *=
vma,
 			vma->vm_next->vm_flags |=3D VM_ACCOUNT;
 	}
=20
-	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm +=3D new_len >> PAGE_SHIFT;
-		*locked =3D true;
-	}
-
 	return new_addr;
 }
=20
 static struct vm_area_struct *vma_to_resize(unsigned long addr,
-	unsigned long old_len, unsigned long new_len, unsigned long *p)
+	unsigned long old_len, unsigned long new_len, unsigned long flags,
+	unsigned long *p)
 {
 	struct mm_struct *mm =3D current->mm;
 	struct vm_area_struct *vma =3D find_vma(mm, addr);
@@ -453,6 +479,10 @@ static struct vm_area_struct *vma_to_resize(unsigned l=
ong addr,
 		return ERR_PTR(-EINVAL);
 	}
=20
+	if (flags & MREMAP_DONTUNMAP && (!vma_is_anonymous(vma) ||
+			vma->vm_flags & VM_SHARED))
+		return ERR_PTR(-EINVAL);
+
 	if (is_vm_hugetlb_page(vma))
 		return ERR_PTR(-EINVAL);
=20
@@ -497,7 +527,7 @@ static struct vm_area_struct *vma_to_resize(unsigned lo=
ng addr,
=20
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 		unsigned long new_addr, unsigned long new_len, bool *locked,
-		struct vm_userfaultfd_ctx *uf,
+		unsigned long flags, struct vm_userfaultfd_ctx *uf,
 		struct list_head *uf_unmap_early,
 		struct list_head *uf_unmap)
 {
@@ -505,7 +535,7 @@ static unsigned long mremap_to(unsigned long addr, unsi=
gned long old_len,
 	struct vm_area_struct *vma;
 	unsigned long ret =3D -EINVAL;
 	unsigned long charged =3D 0;
-	unsigned long map_flags;
+	unsigned long map_flags =3D 0;
=20
 	if (offset_in_page(new_addr))
 		goto out;
@@ -534,9 +564,11 @@ static unsigned long mremap_to(unsigned long addr, uns=
igned long old_len,
 	if ((mm->map_count + 2) >=3D sysctl_max_map_count - 3)
 		return -ENOMEM;
=20
-	ret =3D do_munmap(mm, new_addr, new_len, uf_unmap_early);
-	if (ret)
-		goto out;
+	if (flags & MREMAP_FIXED) {
+		ret =3D do_munmap(mm, new_addr, new_len, uf_unmap_early);
+		if (ret)
+			goto out;
+	}
=20
 	if (old_len >=3D new_len) {
 		ret =3D do_munmap(mm, addr+new_len, old_len - new_len, uf_unmap);
@@ -545,13 +577,26 @@ static unsigned long mremap_to(unsigned long addr, un=
signed long old_len,
 		old_len =3D new_len;
 	}
=20
-	vma =3D vma_to_resize(addr, old_len, new_len, &charged);
+	vma =3D vma_to_resize(addr, old_len, new_len, flags, &charged);
 	if (IS_ERR(vma)) {
 		ret =3D PTR_ERR(vma);
 		goto out;
 	}
=20
-	map_flags =3D MAP_FIXED;
+	/*
+	 * MREMAP_DONTUNMAP expands by new_len - (new_len - old_len), we will
+	 * check that we can expand by new_len and vma_to_resize will handle
+	 * the vma growing which is (new_len - old_len).
+	 */
+	if (flags & MREMAP_DONTUNMAP &&
+		!may_expand_vm(mm, vma->vm_flags, new_len >> PAGE_SHIFT)) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+
+	if (flags & MREMAP_FIXED)
+		map_flags |=3D MAP_FIXED;
+
 	if (vma->vm_flags & VM_MAYSHARE)
 		map_flags |=3D MAP_SHARED;
=20
@@ -561,10 +606,16 @@ static unsigned long mremap_to(unsigned long addr, un=
signed long old_len,
 	if (IS_ERR_VALUE(ret))
 		goto out1;
=20
-	ret =3D move_vma(vma, addr, old_len, new_len, new_addr, locked, uf,
+	/* We got a new mapping */
+	if (!(flags & MREMAP_FIXED))
+		new_addr =3D ret;
+
+	ret =3D move_vma(vma, addr, old_len, new_len, new_addr, locked, flags, uf=
,
 		       uf_unmap);
+
 	if (!(offset_in_page(ret)))
 		goto out;
+
 out1:
 	vm_unacct_memory(charged);
=20
@@ -609,12 +660,16 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned=
 long, old_len,
 	addr =3D untagged_addr(addr);
 	new_addr =3D untagged_addr(new_addr);
=20
-	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
+	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP))
 		return ret;
=20
 	if (flags & MREMAP_FIXED && !(flags & MREMAP_MAYMOVE))
 		return ret;
=20
+	/* MREMAP_DONTUNMAP is always a move */
+	if (flags & MREMAP_DONTUNMAP && !(flags & MREMAP_MAYMOVE))
+		return ret;
+
 	if (offset_in_page(addr))
 		return ret;
=20
@@ -632,9 +687,10 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned =
long, old_len,
 	if (down_write_killable(&current->mm->mmap_sem))
 		return -EINTR;
=20
-	if (flags & MREMAP_FIXED) {
+	if (flags & MREMAP_FIXED || flags & MREMAP_DONTUNMAP) {
 		ret =3D mremap_to(addr, old_len, new_addr, new_len,
-				&locked, &uf, &uf_unmap_early, &uf_unmap);
+				&locked, flags, &uf, &uf_unmap_early,
+				&uf_unmap);
 		goto out;
 	}
=20
@@ -662,7 +718,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned l=
ong, old_len,
 	/*
 	 * Ok, we need to grow..
 	 */
-	vma =3D vma_to_resize(addr, old_len, new_len, &charged);
+	vma =3D vma_to_resize(addr, old_len, new_len, flags, &charged);
 	if (IS_ERR(vma)) {
 		ret =3D PTR_ERR(vma);
 		goto out;
@@ -712,7 +768,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned l=
ong, old_len,
 		}
=20
 		ret =3D move_vma(vma, addr, old_len, new_len, new_addr,
-			       &locked, &uf, &uf_unmap);
+			       &locked, flags, &uf, &uf_unmap);
 	}
 out:
 	if (offset_in_page(ret)) {
--=20
2.25.0.341.g760bfbb309-goog
