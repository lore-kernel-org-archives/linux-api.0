From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next 1/5] treewide: remove struct-pass-by-value from tracepoints arguments
Date: Wed, 28 Feb 2018 20:19:53 -0800
Message-ID: <20180301041957.399230-2-ast@kernel.org>
References: <20180301041957.399230-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180301041957.399230-1-ast@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fix all tracepoint arguments to pass structures (large and small) by reference
instead of by value.
Avoiding passing large structs by value is a good coding style.
Passing small structs sometimes is beneficial, but in all cases
it makes no difference vs readability of the code.
The subsequent patch enforces that all tracepoints args are either integers
or pointers and fit into 64-bit.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/xen/mmu_pv.c                    | 16 +++++-----
 drivers/gpu/drm/i915/i915_trace.h        | 13 +++++++--
 drivers/infiniband/hw/hfi1/file_ops.c    |  2 +-
 drivers/infiniband/hw/hfi1/trace_ctxts.h | 12 ++++----
 drivers/s390/cio/ioasm.c                 | 18 ++++++------
 drivers/s390/cio/trace.h                 | 50 ++++++++++++++++----------------
 fs/dax.c                                 |  2 +-
 include/trace/events/f2fs.h              |  2 +-
 include/trace/events/fs_dax.h            |  6 ++--
 include/trace/events/rcu.h               |  4 +--
 include/trace/events/xen.h               | 32 ++++++++++----------
 kernel/rcu/tree.c                        | 10 +++----
 net/wireless/trace.h                     |  2 +-
 sound/firewire/amdtp-stream-trace.h      |  2 +-
 14 files changed, 89 insertions(+), 82 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index aae88fec9941..b1a8061c3b28 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -218,7 +218,7 @@ static void xen_set_pmd_hyper(pmd_t *ptr, pmd_t val)
 
 static void xen_set_pmd(pmd_t *ptr, pmd_t val)
 {
-	trace_xen_mmu_set_pmd(ptr, val);
+	trace_xen_mmu_set_pmd(ptr, &val);
 
 	/* If page is not pinned, we can just update the entry
 	   directly */
@@ -277,14 +277,14 @@ static inline void __xen_set_pte(pte_t *ptep, pte_t pteval)
 
 static void xen_set_pte(pte_t *ptep, pte_t pteval)
 {
-	trace_xen_mmu_set_pte(ptep, pteval);
+	trace_xen_mmu_set_pte(ptep, &pteval);
 	__xen_set_pte(ptep, pteval);
 }
 
 static void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
-	trace_xen_mmu_set_pte_at(mm, addr, ptep, pteval);
+	trace_xen_mmu_set_pte_at(mm, addr, ptep, &pteval);
 	__xen_set_pte(ptep, pteval);
 }
 
@@ -292,7 +292,7 @@ pte_t xen_ptep_modify_prot_start(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep)
 {
 	/* Just return the pte as-is.  We preserve the bits on commit */
-	trace_xen_mmu_ptep_modify_prot_start(mm, addr, ptep, *ptep);
+	trace_xen_mmu_ptep_modify_prot_start(mm, addr, ptep, ptep);
 	return *ptep;
 }
 
@@ -301,7 +301,7 @@ void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 {
 	struct mmu_update u;
 
-	trace_xen_mmu_ptep_modify_prot_commit(mm, addr, ptep, pte);
+	trace_xen_mmu_ptep_modify_prot_commit(mm, addr, ptep, &pte);
 	xen_mc_batch();
 
 	u.ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
@@ -409,7 +409,7 @@ static void xen_set_pud_hyper(pud_t *ptr, pud_t val)
 
 static void xen_set_pud(pud_t *ptr, pud_t val)
 {
-	trace_xen_mmu_set_pud(ptr, val);
+	trace_xen_mmu_set_pud(ptr, &val);
 
 	/* If page is not pinned, we can just update the entry
 	   directly */
@@ -424,7 +424,7 @@ static void xen_set_pud(pud_t *ptr, pud_t val)
 #ifdef CONFIG_X86_PAE
 static void xen_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
-	trace_xen_mmu_set_pte_atomic(ptep, pte);
+	trace_xen_mmu_set_pte_atomic(ptep, &pte);
 	set_64bit((u64 *)ptep, native_pte_val(pte));
 }
 
@@ -514,7 +514,7 @@ static void xen_set_p4d(p4d_t *ptr, p4d_t val)
 	pgd_t *user_ptr = xen_get_user_pgd((pgd_t *)ptr);
 	pgd_t pgd_val;
 
-	trace_xen_mmu_set_p4d(ptr, (p4d_t *)user_ptr, val);
+	trace_xen_mmu_set_p4d(ptr, (p4d_t *)user_ptr, &val);
 
 	/* If page is not pinned, we can just update the entry
 	   directly */
diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index e1169c02eb2b..681da1f51911 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -849,8 +849,8 @@ TRACE_EVENT(i915_flip_complete,
 	    TP_printk("plane=%d, obj=%p", __entry->plane, __entry->obj)
 );
 
-TRACE_EVENT_CONDITION(i915_reg_rw,
-	TP_PROTO(bool write, i915_reg_t reg, u64 val, int len, bool trace),
+TRACE_EVENT_CONDITION(i915_reg_rw__,
+	TP_PROTO(bool write, u32 reg, u64 val, int len, bool trace),
 
 	TP_ARGS(write, reg, val, len, trace),
 
@@ -865,7 +865,7 @@ TRACE_EVENT_CONDITION(i915_reg_rw,
 
 	TP_fast_assign(
 		__entry->val = (u64)val;
-		__entry->reg = i915_mmio_reg_offset(reg);
+		__entry->reg = reg;
 		__entry->write = write;
 		__entry->len = len;
 		),
@@ -876,6 +876,13 @@ TRACE_EVENT_CONDITION(i915_reg_rw,
 		(u32)(__entry->val & 0xffffffff),
 		(u32)(__entry->val >> 32))
 );
+#if !defined(CREATE_TRACE_POINTS) && !defined(TRACE_HEADER_MULTI_READ)
+static inline void trace_i915_reg_rw(bool write, i915_reg_t reg, u64 val,
+				     int len, bool trace)
+{
+	trace_i915_reg_rw__(write, i915_mmio_reg_offset(reg), val, len, trace);
+}
+#endif
 
 TRACE_EVENT(intel_gpu_freq_change,
 	    TP_PROTO(u32 freq),
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 41fafebe3b0d..da4aa1a95b11 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1153,7 +1153,7 @@ static int get_ctxt_info(struct hfi1_filedata *fd, unsigned long arg, u32 len)
 	cinfo.sdma_ring_size = fd->cq->nentries;
 	cinfo.rcvegr_size = uctxt->egrbufs.rcvtid_size;
 
-	trace_hfi1_ctxt_info(uctxt->dd, uctxt->ctxt, fd->subctxt, cinfo);
+	trace_hfi1_ctxt_info(uctxt->dd, uctxt->ctxt, fd->subctxt, &cinfo);
 	if (copy_to_user((void __user *)arg, &cinfo, len))
 		return -EFAULT;
 
diff --git a/drivers/infiniband/hw/hfi1/trace_ctxts.h b/drivers/infiniband/hw/hfi1/trace_ctxts.h
index 4eb4cc798035..e00c8a7d559c 100644
--- a/drivers/infiniband/hw/hfi1/trace_ctxts.h
+++ b/drivers/infiniband/hw/hfi1/trace_ctxts.h
@@ -106,7 +106,7 @@ TRACE_EVENT(hfi1_uctxtdata,
 TRACE_EVENT(hfi1_ctxt_info,
 	    TP_PROTO(struct hfi1_devdata *dd, unsigned int ctxt,
 		     unsigned int subctxt,
-		     struct hfi1_ctxt_info cinfo),
+		     struct hfi1_ctxt_info *cinfo),
 	    TP_ARGS(dd, ctxt, subctxt, cinfo),
 	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
 			     __field(unsigned int, ctxt)
@@ -120,11 +120,11 @@ TRACE_EVENT(hfi1_ctxt_info,
 	    TP_fast_assign(DD_DEV_ASSIGN(dd);
 			    __entry->ctxt = ctxt;
 			    __entry->subctxt = subctxt;
-			    __entry->egrtids = cinfo.egrtids;
-			    __entry->rcvhdrq_cnt = cinfo.rcvhdrq_cnt;
-			    __entry->rcvhdrq_size = cinfo.rcvhdrq_entsize;
-			    __entry->sdma_ring_size = cinfo.sdma_ring_size;
-			    __entry->rcvegr_size = cinfo.rcvegr_size;
+			    __entry->egrtids = cinfo->egrtids;
+			    __entry->rcvhdrq_cnt = cinfo->rcvhdrq_cnt;
+			    __entry->rcvhdrq_size = cinfo->rcvhdrq_entsize;
+			    __entry->sdma_ring_size = cinfo->sdma_ring_size;
+			    __entry->rcvegr_size = cinfo->rcvegr_size;
 			    ),
 	    TP_printk("[%s] ctxt %u:%u " CINFO_FMT,
 		      __get_str(dev),
diff --git a/drivers/s390/cio/ioasm.c b/drivers/s390/cio/ioasm.c
index 4fa9ee1d09fa..0aecb6314e6f 100644
--- a/drivers/s390/cio/ioasm.c
+++ b/drivers/s390/cio/ioasm.c
@@ -35,7 +35,7 @@ int stsch(struct subchannel_id schid, struct schib *addr)
 	int ccode;
 
 	ccode = __stsch(schid, addr);
-	trace_s390_cio_stsch(schid, addr, ccode);
+	trace_s390_cio_stsch(&schid, addr, ccode);
 
 	return ccode;
 }
@@ -63,7 +63,7 @@ int msch(struct subchannel_id schid, struct schib *addr)
 	int ccode;
 
 	ccode = __msch(schid, addr);
-	trace_s390_cio_msch(schid, addr, ccode);
+	trace_s390_cio_msch(&schid, addr, ccode);
 
 	return ccode;
 }
@@ -88,7 +88,7 @@ int tsch(struct subchannel_id schid, struct irb *addr)
 	int ccode;
 
 	ccode = __tsch(schid, addr);
-	trace_s390_cio_tsch(schid, addr, ccode);
+	trace_s390_cio_tsch(&schid, addr, ccode);
 
 	return ccode;
 }
@@ -115,7 +115,7 @@ int ssch(struct subchannel_id schid, union orb *addr)
 	int ccode;
 
 	ccode = __ssch(schid, addr);
-	trace_s390_cio_ssch(schid, addr, ccode);
+	trace_s390_cio_ssch(&schid, addr, ccode);
 
 	return ccode;
 }
@@ -141,7 +141,7 @@ int csch(struct subchannel_id schid)
 	int ccode;
 
 	ccode = __csch(schid);
-	trace_s390_cio_csch(schid, ccode);
+	trace_s390_cio_csch(&schid, ccode);
 
 	return ccode;
 }
@@ -202,7 +202,7 @@ int rchp(struct chp_id chpid)
 	int ccode;
 
 	ccode = __rchp(chpid);
-	trace_s390_cio_rchp(chpid, ccode);
+	trace_s390_cio_rchp(&chpid, ccode);
 
 	return ccode;
 }
@@ -228,7 +228,7 @@ int rsch(struct subchannel_id schid)
 	int ccode;
 
 	ccode = __rsch(schid);
-	trace_s390_cio_rsch(schid, ccode);
+	trace_s390_cio_rsch(&schid, ccode);
 
 	return ccode;
 }
@@ -253,7 +253,7 @@ int hsch(struct subchannel_id schid)
 	int ccode;
 
 	ccode = __hsch(schid);
-	trace_s390_cio_hsch(schid, ccode);
+	trace_s390_cio_hsch(&schid, ccode);
 
 	return ccode;
 }
@@ -278,7 +278,7 @@ int xsch(struct subchannel_id schid)
 	int ccode;
 
 	ccode = __xsch(schid);
-	trace_s390_cio_xsch(schid, ccode);
+	trace_s390_cio_xsch(&schid, ccode);
 
 	return ccode;
 }
diff --git a/drivers/s390/cio/trace.h b/drivers/s390/cio/trace.h
index 1f8d1c1e566d..4aa6d1426106 100644
--- a/drivers/s390/cio/trace.h
+++ b/drivers/s390/cio/trace.h
@@ -22,7 +22,7 @@
 #include <linux/tracepoint.h>
 
 DECLARE_EVENT_CLASS(s390_class_schib,
-	TP_PROTO(struct subchannel_id schid, struct schib *schib, int cc),
+	TP_PROTO(struct subchannel_id *schid, struct schib *schib, int cc),
 	TP_ARGS(schid, schib, cc),
 	TP_STRUCT__entry(
 		__field(u8, cssid)
@@ -33,9 +33,9 @@ DECLARE_EVENT_CLASS(s390_class_schib,
 		__field(int, cc)
 	),
 	TP_fast_assign(
-		__entry->cssid = schid.cssid;
-		__entry->ssid = schid.ssid;
-		__entry->schno = schid.sch_no;
+		__entry->cssid = schid->cssid;
+		__entry->ssid = schid->ssid;
+		__entry->schno = schid->sch_no;
 		__entry->devno = schib->pmcw.dev;
 		__entry->schib = *schib;
 		__entry->cc = cc;
@@ -60,7 +60,7 @@ DECLARE_EVENT_CLASS(s390_class_schib,
  * @cc: Condition code
  */
 DEFINE_EVENT(s390_class_schib, s390_cio_stsch,
-	TP_PROTO(struct subchannel_id schid, struct schib *schib, int cc),
+	TP_PROTO(struct subchannel_id *schid, struct schib *schib, int cc),
 	TP_ARGS(schid, schib, cc)
 );
 
@@ -71,7 +71,7 @@ DEFINE_EVENT(s390_class_schib, s390_cio_stsch,
  * @cc: Condition code
  */
 DEFINE_EVENT(s390_class_schib, s390_cio_msch,
-	TP_PROTO(struct subchannel_id schid, struct schib *schib, int cc),
+	TP_PROTO(struct subchannel_id *schid, struct schib *schib, int cc),
 	TP_ARGS(schid, schib, cc)
 );
 
@@ -82,7 +82,7 @@ DEFINE_EVENT(s390_class_schib, s390_cio_msch,
  * @cc: Condition code
  */
 TRACE_EVENT(s390_cio_tsch,
-	TP_PROTO(struct subchannel_id schid, struct irb *irb, int cc),
+	TP_PROTO(struct subchannel_id *schid, struct irb *irb, int cc),
 	TP_ARGS(schid, irb, cc),
 	TP_STRUCT__entry(
 		__field(u8, cssid)
@@ -92,9 +92,9 @@ TRACE_EVENT(s390_cio_tsch,
 		__field(int, cc)
 	),
 	TP_fast_assign(
-		__entry->cssid = schid.cssid;
-		__entry->ssid = schid.ssid;
-		__entry->schno = schid.sch_no;
+		__entry->cssid = schid->cssid;
+		__entry->ssid = schid->ssid;
+		__entry->schno = schid->sch_no;
 		__entry->irb = *irb;
 		__entry->cc = cc;
 	),
@@ -151,7 +151,7 @@ TRACE_EVENT(s390_cio_tpi,
  * @cc: Condition code
  */
 TRACE_EVENT(s390_cio_ssch,
-	TP_PROTO(struct subchannel_id schid, union orb *orb, int cc),
+	TP_PROTO(struct subchannel_id *schid, union orb *orb, int cc),
 	TP_ARGS(schid, orb, cc),
 	TP_STRUCT__entry(
 		__field(u8, cssid)
@@ -161,9 +161,9 @@ TRACE_EVENT(s390_cio_ssch,
 		__field(int, cc)
 	),
 	TP_fast_assign(
-		__entry->cssid = schid.cssid;
-		__entry->ssid = schid.ssid;
-		__entry->schno = schid.sch_no;
+		__entry->cssid = schid->cssid;
+		__entry->ssid = schid->ssid;
+		__entry->schno = schid->sch_no;
 		__entry->orb = *orb;
 		__entry->cc = cc;
 	),
@@ -173,7 +173,7 @@ TRACE_EVENT(s390_cio_ssch,
 );
 
 DECLARE_EVENT_CLASS(s390_class_schid,
-	TP_PROTO(struct subchannel_id schid, int cc),
+	TP_PROTO(struct subchannel_id *schid, int cc),
 	TP_ARGS(schid, cc),
 	TP_STRUCT__entry(
 		__field(u8, cssid)
@@ -182,9 +182,9 @@ DECLARE_EVENT_CLASS(s390_class_schid,
 		__field(int, cc)
 	),
 	TP_fast_assign(
-		__entry->cssid = schid.cssid;
-		__entry->ssid = schid.ssid;
-		__entry->schno = schid.sch_no;
+		__entry->cssid = schid->cssid;
+		__entry->ssid = schid->ssid;
+		__entry->schno = schid->sch_no;
 		__entry->cc = cc;
 	),
 	TP_printk("schid=%x.%x.%04x cc=%d", __entry->cssid, __entry->ssid,
@@ -198,7 +198,7 @@ DECLARE_EVENT_CLASS(s390_class_schid,
  * @cc: Condition code
  */
 DEFINE_EVENT(s390_class_schid, s390_cio_csch,
-	TP_PROTO(struct subchannel_id schid, int cc),
+	TP_PROTO(struct subchannel_id *schid, int cc),
 	TP_ARGS(schid, cc)
 );
 
@@ -208,7 +208,7 @@ DEFINE_EVENT(s390_class_schid, s390_cio_csch,
  * @cc: Condition code
  */
 DEFINE_EVENT(s390_class_schid, s390_cio_hsch,
-	TP_PROTO(struct subchannel_id schid, int cc),
+	TP_PROTO(struct subchannel_id *schid, int cc),
 	TP_ARGS(schid, cc)
 );
 
@@ -218,7 +218,7 @@ DEFINE_EVENT(s390_class_schid, s390_cio_hsch,
  * @cc: Condition code
  */
 DEFINE_EVENT(s390_class_schid, s390_cio_xsch,
-	TP_PROTO(struct subchannel_id schid, int cc),
+	TP_PROTO(struct subchannel_id *schid, int cc),
 	TP_ARGS(schid, cc)
 );
 
@@ -228,7 +228,7 @@ DEFINE_EVENT(s390_class_schid, s390_cio_xsch,
  * @cc: Condition code
  */
 DEFINE_EVENT(s390_class_schid, s390_cio_rsch,
-	TP_PROTO(struct subchannel_id schid, int cc),
+	TP_PROTO(struct subchannel_id *schid, int cc),
 	TP_ARGS(schid, cc)
 );
 
@@ -238,7 +238,7 @@ DEFINE_EVENT(s390_class_schid, s390_cio_rsch,
  * @cc: Condition code
  */
 TRACE_EVENT(s390_cio_rchp,
-	TP_PROTO(struct chp_id chpid, int cc),
+	TP_PROTO(struct chp_id *chpid, int cc),
 	TP_ARGS(chpid, cc),
 	TP_STRUCT__entry(
 		__field(u8, cssid)
@@ -246,8 +246,8 @@ TRACE_EVENT(s390_cio_rchp,
 		__field(int, cc)
 	),
 	TP_fast_assign(
-		__entry->cssid = chpid.cssid;
-		__entry->id = chpid.id;
+		__entry->cssid = chpid->cssid;
+		__entry->id = chpid->id;
 		__entry->cc = cc;
 	),
 	TP_printk("chpid=%x.%02x cc=%d", __entry->cssid, __entry->id,
diff --git a/fs/dax.c b/fs/dax.c
index 0276df90e86c..6d03ead8e788 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1429,7 +1429,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			goto finish_iomap;
 		}
 
-		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
+		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, &pfn, entry);
 		result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
 					    write);
 		break;
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 06c87f9f720c..795698925d20 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -491,7 +491,7 @@ DEFINE_EVENT(f2fs__truncate_node, f2fs_truncate_node,
 
 TRACE_EVENT(f2fs_truncate_partial_nodes,
 
-	TP_PROTO(struct inode *inode, nid_t nid[], int depth, int err),
+	TP_PROTO(struct inode *inode, nid_t *nid, int depth, int err),
 
 	TP_ARGS(inode, nid, depth, err),
 
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 97b09fcf7e52..5a6a8285750f 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -104,7 +104,7 @@ DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
 
 DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
-		long length, pfn_t pfn, void *radix_entry),
+		long length, pfn_t *pfn, void *radix_entry),
 	TP_ARGS(inode, vmf, length, pfn, radix_entry),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
@@ -123,7 +123,7 @@ DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
 		__entry->address = vmf->address;
 		__entry->write = vmf->flags & FAULT_FLAG_WRITE;
 		__entry->length = length;
-		__entry->pfn_val = pfn.val;
+		__entry->pfn_val = pfn->val;
 		__entry->radix_entry = radix_entry;
 	),
 	TP_printk("dev %d:%d ino %#lx %s %s address %#lx length %#lx "
@@ -145,7 +145,7 @@ DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
 #define DEFINE_PMD_INSERT_MAPPING_EVENT(name) \
 DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		long length, pfn_t pfn, void *radix_entry), \
+		long length, pfn_t *pfn, void *radix_entry), \
 	TP_ARGS(inode, vmf, length, pfn, radix_entry))
 
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 0b50fda80db0..4b463294306f 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -436,7 +436,7 @@ TRACE_EVENT(rcu_fqs,
  */
 TRACE_EVENT(rcu_dyntick,
 
-	TP_PROTO(const char *polarity, long oldnesting, long newnesting, atomic_t dynticks),
+	TP_PROTO(const char *polarity, long oldnesting, long newnesting, atomic_t *dynticks),
 
 	TP_ARGS(polarity, oldnesting, newnesting, dynticks),
 
@@ -451,7 +451,7 @@ TRACE_EVENT(rcu_dyntick,
 		__entry->polarity = polarity;
 		__entry->oldnesting = oldnesting;
 		__entry->newnesting = newnesting;
-		__entry->dynticks = atomic_read(&dynticks);
+		__entry->dynticks = atomic_read(dynticks);
 	),
 
 	TP_printk("%s %lx %lx %#3x", __entry->polarity,
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 7dd8f34c37df..ea9e9014f0c5 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -128,14 +128,14 @@ TRACE_EVENT(xen_mc_extend_args,
 TRACE_DEFINE_SIZEOF(pteval_t);
 /* mmu */
 DECLARE_EVENT_CLASS(xen_mmu__set_pte,
-	    TP_PROTO(pte_t *ptep, pte_t pteval),
+	    TP_PROTO(pte_t *ptep, pte_t *pteval),
 	    TP_ARGS(ptep, pteval),
 	    TP_STRUCT__entry(
 		    __field(pte_t *, ptep)
 		    __field(pteval_t, pteval)
 		    ),
 	    TP_fast_assign(__entry->ptep = ptep;
-			   __entry->pteval = pteval.pte),
+			   __entry->pteval = pteval->pte),
 	    TP_printk("ptep %p pteval %0*llx (raw %0*llx)",
 		      __entry->ptep,
 		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
@@ -144,14 +144,14 @@ DECLARE_EVENT_CLASS(xen_mmu__set_pte,
 
 #define DEFINE_XEN_MMU_SET_PTE(name)				\
 	DEFINE_EVENT(xen_mmu__set_pte, name,			\
-		     TP_PROTO(pte_t *ptep, pte_t pteval),	\
+		     TP_PROTO(pte_t *ptep, pte_t *pteval),	\
 		     TP_ARGS(ptep, pteval))
 
 DEFINE_XEN_MMU_SET_PTE(xen_mmu_set_pte);
 
 TRACE_EVENT(xen_mmu_set_pte_at,
 	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
-		     pte_t *ptep, pte_t pteval),
+		     pte_t *ptep, pte_t *pteval),
 	    TP_ARGS(mm, addr, ptep, pteval),
 	    TP_STRUCT__entry(
 		    __field(struct mm_struct *, mm)
@@ -162,7 +162,7 @@ TRACE_EVENT(xen_mmu_set_pte_at,
 	    TP_fast_assign(__entry->mm = mm;
 			   __entry->addr = addr;
 			   __entry->ptep = ptep;
-			   __entry->pteval = pteval.pte),
+			   __entry->pteval = pteval->pte),
 	    TP_printk("mm %p addr %lx ptep %p pteval %0*llx (raw %0*llx)",
 		      __entry->mm, __entry->addr, __entry->ptep,
 		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
@@ -172,14 +172,14 @@ TRACE_EVENT(xen_mmu_set_pte_at,
 TRACE_DEFINE_SIZEOF(pmdval_t);
 
 TRACE_EVENT(xen_mmu_set_pmd,
-	    TP_PROTO(pmd_t *pmdp, pmd_t pmdval),
+	    TP_PROTO(pmd_t *pmdp, pmd_t *pmdval),
 	    TP_ARGS(pmdp, pmdval),
 	    TP_STRUCT__entry(
 		    __field(pmd_t *, pmdp)
 		    __field(pmdval_t, pmdval)
 		    ),
 	    TP_fast_assign(__entry->pmdp = pmdp;
-			   __entry->pmdval = pmdval.pmd),
+			   __entry->pmdval = pmdval->pmd),
 	    TP_printk("pmdp %p pmdval %0*llx (raw %0*llx)",
 		      __entry->pmdp,
 		      (int)sizeof(pmdval_t) * 2, (unsigned long long)pmd_val(native_make_pmd(__entry->pmdval)),
@@ -220,14 +220,14 @@ TRACE_EVENT(xen_mmu_pmd_clear,
 TRACE_DEFINE_SIZEOF(pudval_t);
 
 TRACE_EVENT(xen_mmu_set_pud,
-	    TP_PROTO(pud_t *pudp, pud_t pudval),
+	    TP_PROTO(pud_t *pudp, pud_t *pudval),
 	    TP_ARGS(pudp, pudval),
 	    TP_STRUCT__entry(
 		    __field(pud_t *, pudp)
 		    __field(pudval_t, pudval)
 		    ),
 	    TP_fast_assign(__entry->pudp = pudp;
-			   __entry->pudval = native_pud_val(pudval)),
+			   __entry->pudval = native_pud_val(*pudval)),
 	    TP_printk("pudp %p pudval %0*llx (raw %0*llx)",
 		      __entry->pudp,
 		      (int)sizeof(pudval_t) * 2, (unsigned long long)pud_val(native_make_pud(__entry->pudval)),
@@ -237,7 +237,7 @@ TRACE_EVENT(xen_mmu_set_pud,
 TRACE_DEFINE_SIZEOF(p4dval_t);
 
 TRACE_EVENT(xen_mmu_set_p4d,
-	    TP_PROTO(p4d_t *p4dp, p4d_t *user_p4dp, p4d_t p4dval),
+	    TP_PROTO(p4d_t *p4dp, p4d_t *user_p4dp, p4d_t *p4dval),
 	    TP_ARGS(p4dp, user_p4dp, p4dval),
 	    TP_STRUCT__entry(
 		    __field(p4d_t *, p4dp)
@@ -246,7 +246,7 @@ TRACE_EVENT(xen_mmu_set_p4d,
 		    ),
 	    TP_fast_assign(__entry->p4dp = p4dp;
 			   __entry->user_p4dp = user_p4dp;
-			   __entry->p4dval = p4d_val(p4dval)),
+			   __entry->p4dval = p4d_val(*p4dval)),
 	    TP_printk("p4dp %p user_p4dp %p p4dval %0*llx (raw %0*llx)",
 		      __entry->p4dp, __entry->user_p4dp,
 		      (int)sizeof(p4dval_t) * 2, (unsigned long long)pgd_val(native_make_pgd(__entry->p4dval)),
@@ -255,14 +255,14 @@ TRACE_EVENT(xen_mmu_set_p4d,
 #else
 
 TRACE_EVENT(xen_mmu_set_pud,
-	    TP_PROTO(pud_t *pudp, pud_t pudval),
+	    TP_PROTO(pud_t *pudp, pud_t *pudval),
 	    TP_ARGS(pudp, pudval),
 	    TP_STRUCT__entry(
 		    __field(pud_t *, pudp)
 		    __field(pudval_t, pudval)
 		    ),
 	    TP_fast_assign(__entry->pudp = pudp;
-			   __entry->pudval = native_pud_val(pudval)),
+			   __entry->pudval = native_pud_val(*pudval)),
 	    TP_printk("pudp %p pudval %0*llx (raw %0*llx)",
 		      __entry->pudp,
 		      (int)sizeof(pudval_t) * 2, (unsigned long long)pgd_val(native_make_pgd(__entry->pudval)),
@@ -273,7 +273,7 @@ TRACE_EVENT(xen_mmu_set_pud,
 
 DECLARE_EVENT_CLASS(xen_mmu_ptep_modify_prot,
 	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
-		     pte_t *ptep, pte_t pteval),
+		     pte_t *ptep, pte_t *pteval),
 	    TP_ARGS(mm, addr, ptep, pteval),
 	    TP_STRUCT__entry(
 		    __field(struct mm_struct *, mm)
@@ -284,7 +284,7 @@ DECLARE_EVENT_CLASS(xen_mmu_ptep_modify_prot,
 	    TP_fast_assign(__entry->mm = mm;
 			   __entry->addr = addr;
 			   __entry->ptep = ptep;
-			   __entry->pteval = pteval.pte),
+			   __entry->pteval = pteval->pte),
 	    TP_printk("mm %p addr %lx ptep %p pteval %0*llx (raw %0*llx)",
 		      __entry->mm, __entry->addr, __entry->ptep,
 		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
@@ -293,7 +293,7 @@ DECLARE_EVENT_CLASS(xen_mmu_ptep_modify_prot,
 #define DEFINE_XEN_MMU_PTEP_MODIFY_PROT(name)				\
 	DEFINE_EVENT(xen_mmu_ptep_modify_prot, name,			\
 		     TP_PROTO(struct mm_struct *mm, unsigned long addr,	\
-			      pte_t *ptep, pte_t pteval),		\
+			      pte_t *ptep, pte_t *pteval),		\
 		     TP_ARGS(mm, addr, ptep, pteval))
 
 DEFINE_XEN_MMU_PTEP_MODIFY_PROT(xen_mmu_ptep_modify_prot_start);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 491bdf39f276..43c0f899f78c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -772,7 +772,7 @@ static void rcu_eqs_enter(bool user)
 	}
 
 	lockdep_assert_irqs_disabled();
-	trace_rcu_dyntick(TPS("Start"), rdtp->dynticks_nesting, 0, rdtp->dynticks);
+	trace_rcu_dyntick(TPS("Start"), rdtp->dynticks_nesting, 0, &rdtp->dynticks);
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	for_each_rcu_flavor(rsp) {
 		rdp = this_cpu_ptr(rsp->rda);
@@ -848,14 +848,14 @@ void rcu_nmi_exit(void)
 	 * leave it in non-RCU-idle state.
 	 */
 	if (rdtp->dynticks_nmi_nesting != 1) {
-		trace_rcu_dyntick(TPS("--="), rdtp->dynticks_nmi_nesting, rdtp->dynticks_nmi_nesting - 2, rdtp->dynticks);
+		trace_rcu_dyntick(TPS("--="), rdtp->dynticks_nmi_nesting, rdtp->dynticks_nmi_nesting - 2, &rdtp->dynticks);
 		WRITE_ONCE(rdtp->dynticks_nmi_nesting, /* No store tearing. */
 			   rdtp->dynticks_nmi_nesting - 2);
 		return;
 	}
 
 	/* This NMI interrupted an RCU-idle CPU, restore RCU-idleness. */
-	trace_rcu_dyntick(TPS("Startirq"), rdtp->dynticks_nmi_nesting, 0, rdtp->dynticks);
+	trace_rcu_dyntick(TPS("Startirq"), rdtp->dynticks_nmi_nesting, 0, &rdtp->dynticks);
 	WRITE_ONCE(rdtp->dynticks_nmi_nesting, 0); /* Avoid store tearing. */
 	rcu_dynticks_eqs_enter();
 }
@@ -930,7 +930,7 @@ static void rcu_eqs_exit(bool user)
 	rcu_dynticks_task_exit();
 	rcu_dynticks_eqs_exit();
 	rcu_cleanup_after_idle();
-	trace_rcu_dyntick(TPS("End"), rdtp->dynticks_nesting, 1, rdtp->dynticks);
+	trace_rcu_dyntick(TPS("End"), rdtp->dynticks_nesting, 1, &rdtp->dynticks);
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	WRITE_ONCE(rdtp->dynticks_nesting, 1);
 	WRITE_ONCE(rdtp->dynticks_nmi_nesting, DYNTICK_IRQ_NONIDLE);
@@ -1004,7 +1004,7 @@ void rcu_nmi_enter(void)
 	}
 	trace_rcu_dyntick(incby == 1 ? TPS("Endirq") : TPS("++="),
 			  rdtp->dynticks_nmi_nesting,
-			  rdtp->dynticks_nmi_nesting + incby, rdtp->dynticks);
+			  rdtp->dynticks_nmi_nesting + incby, &rdtp->dynticks);
 	WRITE_ONCE(rdtp->dynticks_nmi_nesting, /* Prevent store tearing. */
 		   rdtp->dynticks_nmi_nesting + incby);
 	barrier();
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5152938b358d..018c81fa72fb 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3137,7 +3137,7 @@ TRACE_EVENT(rdev_start_radar_detection,
 
 TRACE_EVENT(rdev_set_mcast_rate,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 int mcast_rate[NUM_NL80211_BANDS]),
+		 int *mcast_rate),
 	TP_ARGS(wiphy, netdev, mcast_rate),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
diff --git a/sound/firewire/amdtp-stream-trace.h b/sound/firewire/amdtp-stream-trace.h
index ea0d486652c8..54cdd4ffa9ce 100644
--- a/sound/firewire/amdtp-stream-trace.h
+++ b/sound/firewire/amdtp-stream-trace.h
@@ -14,7 +14,7 @@
 #include <linux/tracepoint.h>
 
 TRACE_EVENT(in_packet,
-	TP_PROTO(const struct amdtp_stream *s, u32 cycles, u32 cip_header[2], unsigned int payload_length, unsigned int index),
+	TP_PROTO(const struct amdtp_stream *s, u32 cycles, u32 *cip_header, unsigned int payload_length, unsigned int index),
 	TP_ARGS(s, cycles, cip_header, payload_length, index),
 	TP_STRUCT__entry(
 		__field(unsigned int, second)
-- 
2.9.5
