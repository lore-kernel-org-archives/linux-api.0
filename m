From: Julien Grall <julien.grall@citrix.com>
Subject: [PATCH 8/8] xen/privcmd: Further s/MFN/GFN/ clean-up
Date: Tue, 28 Jul 2015 16:02:49 +0100
Message-ID: <1438095769-2560-9-git-send-email-julien.grall@citrix.com>
References: <1438095769-2560-1-git-send-email-julien.grall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1438095769-2560-1-git-send-email-julien.grall@citrix.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: xen-devel@lists.xenproject.org
Cc: x86@kernel.org, Russell King <linux@arm.linux.org.uk>, ian.campbell@citrix.com, linux-api@vger.kernel.org, stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org, Julien Grall <julien.grall@citrix.com>, Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>, "H. Peter Anvin" <hpa@zytor.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

The privcmd code is mixing the usage of GFN and MFN within the same
functions which make the code difficult to understand when you only work
with auto-translated guests.

The privcmd driver is only dealing with GFN so replace all the mention
of MFN into GFN.

The ioctl structure used to map foreign change has been left unchanged
given that the userspace is using it. Nonetheless, add a comment to
explain the expected value within the "mfn" field.

Signed-off-by: Julien Grall <julien.grall@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-api@vger.kernel.org
---
 arch/arm/xen/enlighten.c   | 18 +++++++++---------
 arch/x86/xen/mmu.c         | 32 ++++++++++++++++----------------
 drivers/xen/privcmd.c      | 44 ++++++++++++++++++++++----------------------
 drivers/xen/xlate_mmu.c    | 18 +++++++++---------
 include/uapi/xen/privcmd.h |  4 ++++
 include/xen/xen-ops.h      | 10 +++++-----
 6 files changed, 65 insertions(+), 61 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 6c09cc4..a8b8806 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -56,35 +56,35 @@ static __read_mostly unsigned int xen_events_irq;
 
 static __initdata struct device_node *xen_node;
 
-int xen_remap_domain_mfn_array(struct vm_area_struct *vma,
+int xen_remap_domain_gfn_array(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       xen_pfn_t *mfn, int nr,
+			       xen_pfn_t *gfn, int nr,
 			       int *err_ptr, pgprot_t prot,
 			       unsigned domid,
 			       struct page **pages)
 {
-	return xen_xlate_remap_gfn_array(vma, addr, mfn, nr, err_ptr,
+	return xen_xlate_remap_gfn_array(vma, addr, gfn, nr, err_ptr,
 					 prot, domid, pages);
 }
-EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_array);
+EXPORT_SYMBOL_GPL(xen_remap_domain_gfn_array);
 
 /* Not used by XENFEAT_auto_translated guests. */
-int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
+int xen_remap_domain_gfn_range(struct vm_area_struct *vma,
                               unsigned long addr,
-                              xen_pfn_t mfn, int nr,
+                              xen_pfn_t gfn, int nr,
                               pgprot_t prot, unsigned domid,
                               struct page **pages)
 {
 	return -ENOSYS;
 }
-EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
+EXPORT_SYMBOL_GPL(xen_remap_domain_gfn_range);
 
-int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+int xen_unmap_domain_gfn_range(struct vm_area_struct *vma,
 			       int nr, struct page **pages)
 {
 	return xen_xlate_unmap_gfn_range(vma, nr, pages);
 }
-EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
+EXPORT_SYMBOL_GPL(xen_unmap_domain_gfn_range);
 
 static void xen_percpu_init(void)
 {
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 742b8d2..ca5c71f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2465,9 +2465,9 @@ static int remap_area_mfn_pte_fn(pte_t *ptep, pgtable_t token,
 	return 0;
 }
 
-static int do_remap_mfn(struct vm_area_struct *vma,
+static int do_remap_gfn(struct vm_area_struct *vma,
 			unsigned long addr,
-			xen_pfn_t *mfn, int nr,
+			xen_pfn_t *gfn, int nr,
 			int *err_ptr, pgprot_t prot,
 			unsigned domid,
 			struct page **pages)
@@ -2483,14 +2483,14 @@ static int do_remap_mfn(struct vm_area_struct *vma,
 	if (xen_feature(XENFEAT_auto_translated_physmap)) {
 #ifdef CONFIG_XEN_PVH
 		/* We need to update the local page tables and the xen HAP */
-		return xen_xlate_remap_gfn_array(vma, addr, mfn, nr, err_ptr,
+		return xen_xlate_remap_gfn_array(vma, addr, gfn, nr, err_ptr,
 						 prot, domid, pages);
 #else
 		return -EINVAL;
 #endif
         }
 
-	rmd.mfn = mfn;
+	rmd.mfn = gfn;
 	rmd.prot = prot;
 	/* We use the err_ptr to indicate if there we are doing a contigious
 	 * mapping or a discontigious mapping. */
@@ -2518,8 +2518,8 @@ static int do_remap_mfn(struct vm_area_struct *vma,
 						    batch_left, &done, domid);
 
 			/*
-			 * @err_ptr may be the same buffer as @mfn, so
-			 * only clear it after each chunk of @mfn is
+			 * @err_ptr may be the same buffer as @gfn, so
+			 * only clear it after each chunk of @gfn is
 			 * used.
 			 */
 			if (err_ptr) {
@@ -2549,19 +2549,19 @@ out:
 	return err < 0 ? err : mapped;
 }
 
-int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
+int xen_remap_domain_gfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       xen_pfn_t mfn, int nr,
+			       xen_pfn_t gfn, int nr,
 			       pgprot_t prot, unsigned domid,
 			       struct page **pages)
 {
-	return do_remap_mfn(vma, addr, &mfn, nr, NULL, prot, domid, pages);
+	return do_remap_gfn(vma, addr, &gfn, nr, NULL, prot, domid, pages);
 }
-EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
+EXPORT_SYMBOL_GPL(xen_remap_domain_gfn_range);
 
-int xen_remap_domain_mfn_array(struct vm_area_struct *vma,
+int xen_remap_domain_gfn_array(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       xen_pfn_t *mfn, int nr,
+			       xen_pfn_t *gfn, int nr,
 			       int *err_ptr, pgprot_t prot,
 			       unsigned domid, struct page **pages)
 {
@@ -2570,13 +2570,13 @@ int xen_remap_domain_mfn_array(struct vm_area_struct *vma,
 	 * cause of "wrong memory was mapped in".
 	 */
 	BUG_ON(err_ptr == NULL);
-	return do_remap_mfn(vma, addr, mfn, nr, err_ptr, prot, domid, pages);
+	return do_remap_gfn(vma, addr, gfn, nr, err_ptr, prot, domid, pages);
 }
-EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_array);
+EXPORT_SYMBOL_GPL(xen_remap_domain_gfn_array);
 
 
 /* Returns: 0 success */
-int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+int xen_unmap_domain_gfn_range(struct vm_area_struct *vma,
 			       int numpgs, struct page **pages)
 {
 	if (!pages || !xen_feature(XENFEAT_auto_translated_physmap))
@@ -2588,4 +2588,4 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 	return -EINVAL;
 #endif
 }
-EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
+EXPORT_SYMBOL_GPL(xen_unmap_domain_gfn_range);
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 5a29616..c6deb87 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -193,16 +193,16 @@ static int traverse_pages_block(unsigned nelem, size_t size,
 	return ret;
 }
 
-struct mmap_mfn_state {
+struct mmap_gfn_state {
 	unsigned long va;
 	struct vm_area_struct *vma;
 	domid_t domain;
 };
 
-static int mmap_mfn_range(void *data, void *state)
+static int mmap_gfn_range(void *data, void *state)
 {
 	struct privcmd_mmap_entry *msg = data;
-	struct mmap_mfn_state *st = state;
+	struct mmap_gfn_state *st = state;
 	struct vm_area_struct *vma = st->vma;
 	int rc;
 
@@ -216,7 +216,7 @@ static int mmap_mfn_range(void *data, void *state)
 	    ((msg->va+(msg->npages<<PAGE_SHIFT)) > vma->vm_end))
 		return -EINVAL;
 
-	rc = xen_remap_domain_mfn_range(vma,
+	rc = xen_remap_domain_gfn_range(vma,
 					msg->va & PAGE_MASK,
 					msg->mfn, msg->npages,
 					vma->vm_page_prot,
@@ -236,7 +236,7 @@ static long privcmd_ioctl_mmap(void __user *udata)
 	struct vm_area_struct *vma;
 	int rc;
 	LIST_HEAD(pagelist);
-	struct mmap_mfn_state state;
+	struct mmap_gfn_state state;
 
 	/* We only support privcmd_ioctl_mmap_batch for auto translated. */
 	if (xen_feature(XENFEAT_auto_translated_physmap))
@@ -273,7 +273,7 @@ static long privcmd_ioctl_mmap(void __user *udata)
 
 	rc = traverse_pages(mmapcmd.num, sizeof(struct privcmd_mmap_entry),
 			    &pagelist,
-			    mmap_mfn_range, &state);
+			    mmap_gfn_range, &state);
 
 
 out_up:
@@ -299,18 +299,18 @@ struct mmap_batch_state {
 	int global_error;
 	int version;
 
-	/* User-space mfn array to store errors in the second pass for V1. */
-	xen_pfn_t __user *user_mfn;
+	/* User-space gfn array to store errors in the second pass for V1. */
+	xen_pfn_t __user *user_gfn;
 	/* User-space int array to store errors in the second pass for V2. */
 	int __user *user_err;
 };
 
-/* auto translated dom0 note: if domU being created is PV, then mfn is
- * mfn(addr on bus). If it's auto xlated, then mfn is pfn (input to HAP).
+/* auto translated dom0 note: if domU being created is PV, then gfn is
+ * mfn(addr on bus). If it's auto xlated, then gfn is pfn (input to HAP).
  */
 static int mmap_batch_fn(void *data, int nr, void *state)
 {
-	xen_pfn_t *mfnp = data;
+	xen_pfn_t *gfnp = data;
 	struct mmap_batch_state *st = state;
 	struct vm_area_struct *vma = st->vma;
 	struct page **pages = vma->vm_private_data;
@@ -321,8 +321,8 @@ static int mmap_batch_fn(void *data, int nr, void *state)
 		cur_pages = &pages[st->index];
 
 	BUG_ON(nr < 0);
-	ret = xen_remap_domain_mfn_array(st->vma, st->va & PAGE_MASK, mfnp, nr,
-					 (int *)mfnp, st->vma->vm_page_prot,
+	ret = xen_remap_domain_gfn_array(st->vma, st->va & PAGE_MASK, gfnp, nr,
+					 (int *)gfnp, st->vma->vm_page_prot,
 					 st->domain, cur_pages);
 
 	/* Adjust the global_error? */
@@ -347,22 +347,22 @@ static int mmap_return_error(int err, struct mmap_batch_state *st)
 
 	if (st->version == 1) {
 		if (err) {
-			xen_pfn_t mfn;
+			xen_pfn_t gfn;
 
-			ret = get_user(mfn, st->user_mfn);
+			ret = get_user(gfn, st->user_gfn);
 			if (ret < 0)
 				return ret;
 			/*
 			 * V1 encodes the error codes in the 32bit top
-			 * nibble of the mfn (with its known
+			 * nibble of the gfn (with its known
 			 * limitations vis-a-vis 64 bit callers).
 			 */
-			mfn |= (err == -ENOENT) ?
+			gfn |= (err == -ENOENT) ?
 				PRIVCMD_MMAPBATCH_PAGED_ERROR :
 				PRIVCMD_MMAPBATCH_MFN_ERROR;
-			return __put_user(mfn, st->user_mfn++);
+			return __put_user(gfn, st->user_gfn++);
 		} else
-			st->user_mfn++;
+			st->user_gfn++;
 	} else { /* st->version == 2 */
 		if (err)
 			return __put_user(err, st->user_err++);
@@ -388,7 +388,7 @@ static int mmap_return_errors(void *data, int nr, void *state)
 	return 0;
 }
 
-/* Allocate pfns that are then mapped with gmfns from foreign domid. Update
+/* Allocate pfns that are then mapped with gfns from foreign domid. Update
  * the vma with the page info to use later.
  * Returns: 0 if success, otherwise -errno
  */
@@ -526,7 +526,7 @@ static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
 
 	if (state.global_error) {
 		/* Write back errors in second pass. */
-		state.user_mfn = (xen_pfn_t *)m.arr;
+		state.user_gfn = (xen_pfn_t *)m.arr;
 		state.user_err = m.err;
 		ret = traverse_pages_block(m.num, sizeof(xen_pfn_t),
 					   &pagelist, mmap_return_errors, &state);
@@ -587,7 +587,7 @@ static void privcmd_close(struct vm_area_struct *vma)
 	if (!xen_feature(XENFEAT_auto_translated_physmap) || !numpgs || !pages)
 		return;
 
-	rc = xen_unmap_domain_mfn_range(vma, numpgs, pages);
+	rc = xen_unmap_domain_gfn_range(vma, numpgs, pages);
 	if (rc == 0)
 		free_xenballooned_pages(numpgs, pages);
 	else
diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index 58a5389..cff2387 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -38,8 +38,8 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
 
-/* map fgmfn of domid to lpfn in the current domain */
-static int map_foreign_page(unsigned long lpfn, unsigned long fgmfn,
+/* map fgfn of domid to lpfn in the current domain */
+static int map_foreign_page(unsigned long lpfn, unsigned long fgfn,
 			    unsigned int domid)
 {
 	int rc;
@@ -49,7 +49,7 @@ static int map_foreign_page(unsigned long lpfn, unsigned long fgmfn,
 		.size = 1,
 		.space = XENMAPSPACE_gmfn_foreign,
 	};
-	xen_ulong_t idx = fgmfn;
+	xen_ulong_t idx = fgfn;
 	xen_pfn_t gpfn = lpfn;
 	int err = 0;
 
@@ -62,13 +62,13 @@ static int map_foreign_page(unsigned long lpfn, unsigned long fgmfn,
 }
 
 struct remap_data {
-	xen_pfn_t *fgmfn; /* foreign domain's gmfn */
+	xen_pfn_t *fgfn; /* foreign domain's gfn */
 	pgprot_t prot;
 	domid_t  domid;
 	struct vm_area_struct *vma;
 	int index;
 	struct page **pages;
-	struct xen_remap_mfn_info *info;
+	struct xen_remap_gfn_info *info;
 	int *err_ptr;
 	int mapped;
 };
@@ -82,20 +82,20 @@ static int remap_pte_fn(pte_t *ptep, pgtable_t token, unsigned long addr,
 	pte_t pte = pte_mkspecial(pfn_pte(pfn, info->prot));
 	int rc;
 
-	rc = map_foreign_page(pfn, *info->fgmfn, info->domid);
+	rc = map_foreign_page(pfn, *info->fgfn, info->domid);
 	*info->err_ptr++ = rc;
 	if (!rc) {
 		set_pte_at(info->vma->vm_mm, addr, ptep, pte);
 		info->mapped++;
 	}
-	info->fgmfn++;
+	info->fgfn++;
 
 	return 0;
 }
 
 int xen_xlate_remap_gfn_array(struct vm_area_struct *vma,
 			      unsigned long addr,
-			      xen_pfn_t *mfn, int nr,
+			      xen_pfn_t *gfn, int nr,
 			      int *err_ptr, pgprot_t prot,
 			      unsigned domid,
 			      struct page **pages)
@@ -108,7 +108,7 @@ int xen_xlate_remap_gfn_array(struct vm_area_struct *vma,
 	   x86 PVOPS */
 	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_IO)) == (VM_PFNMAP | VM_IO)));
 
-	data.fgmfn = mfn;
+	data.fgfn = gfn;
 	data.prot  = prot;
 	data.domid = domid;
 	data.vma   = vma;
diff --git a/include/uapi/xen/privcmd.h b/include/uapi/xen/privcmd.h
index a853168..7ddeeda 100644
--- a/include/uapi/xen/privcmd.h
+++ b/include/uapi/xen/privcmd.h
@@ -44,6 +44,10 @@ struct privcmd_hypercall {
 
 struct privcmd_mmap_entry {
 	__u64 va;
+	/*
+	 * This should be a GFN. It's not possible to change the name because
+	 * it's exposed to the user-space.
+	 */
 	__u64 mfn;
 	__u64 npages;
 };
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 0ce4f32..e4e214a 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -30,7 +30,7 @@ void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order);
 struct vm_area_struct;
 
 /*
- * xen_remap_domain_mfn_array() - map an array of foreign frames
+ * xen_remap_domain_gfn_array() - map an array of foreign frames
  * @vma:     VMA to map the pages into
  * @addr:    Address at which to map the pages
  * @gfn:     Array of GFNs to map
@@ -46,14 +46,14 @@ struct vm_area_struct;
  * Returns the number of successfully mapped frames, or a -ve error
  * code.
  */
-int xen_remap_domain_mfn_array(struct vm_area_struct *vma,
+int xen_remap_domain_gfn_array(struct vm_area_struct *vma,
 			       unsigned long addr,
 			       xen_pfn_t *gfn, int nr,
 			       int *err_ptr, pgprot_t prot,
 			       unsigned domid,
 			       struct page **pages);
 
-/* xen_remap_domain_mfn_range() - map a range of foreign frames
+/* xen_remap_domain_gfn_range() - map a range of foreign frames
  * @vma:     VMA to map the pages into
  * @addr:    Address at which to map the pages
  * @gfn:     First GFN to map.
@@ -65,12 +65,12 @@ int xen_remap_domain_mfn_array(struct vm_area_struct *vma,
  * Returns the number of successfully mapped frames, or a -ve error
  * code.
  */
-int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
+int xen_remap_domain_gfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
 			       xen_pfn_t gfn, int nr,
 			       pgprot_t prot, unsigned domid,
 			       struct page **pages);
-int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+int xen_unmap_domain_gfn_range(struct vm_area_struct *vma,
 			       int numpgs, struct page **pages);
 int xen_xlate_remap_gfn_array(struct vm_area_struct *vma,
 			      unsigned long addr,
-- 
2.1.4
