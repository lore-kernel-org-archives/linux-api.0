From: Oded Gabbay <oded.gabbay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 27/83] hsa/radeon: Implement hsaKmtSetMemoryPolicy
Date: Fri, 11 Jul 2014 00:50:27 +0300
Message-ID: <1405029027-6085-26-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay-5C7GfCeVMHo@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, John Bridgman <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, Andrew Lewycky <Andrew.Lewycky-5C7GfCeVMHo@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Oded Gabbay <oded.gabbay-5C7GfCeVMHo@public.gmane.org>, Ben Goz <ben.goz-5C7GfCeVMHo@public.gmane.org>, Evgeny Pinchuk <evgeny.pinchuk-5C7GfCeVMHo@public.gmane.org>, Alexey Skidanov <Alexey.Skidanov-5C7GfCeVMHo@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Andrew Lewycky <Andrew.Lewycky-5C7GfCeVMHo@public.gmane.org>

This patch adds support in KFD for the hsaKmtSetMemoryPolicy
HSA thunk API call

Signed-off-by: Andrew Lewycky <Andrew.Lewycky-5C7GfCeVMHo@public.gmane.org>
Signed-off-by: Oded Gabbay <oded.gabbay-5C7GfCeVMHo@public.gmane.org>
---
 drivers/gpu/hsa/radeon/cik_regs.h             |  1 +
 drivers/gpu/hsa/radeon/kfd_chardev.c          | 59 +++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c | 91 +++++++++++++++++++++++++--
 drivers/gpu/hsa/radeon/kfd_scheduler.h        | 12 ++++
 include/uapi/linux/kfd_ioctl.h                | 13 ++++
 5 files changed, 172 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/cik_regs.h b/drivers/gpu/hsa/radeon/cik_regs.h
index 813cdc4..93f7b34 100644
--- a/drivers/gpu/hsa/radeon/cik_regs.h
+++ b/drivers/gpu/hsa/radeon/cik_regs.h
@@ -54,6 +54,7 @@
 #define	APE1_MTYPE(x)					((x) << 7)
 
 /* valid for both DEFAULT_MTYPE and APE1_MTYPE */
+#define	MTYPE_CACHED					0
 #define	MTYPE_NONCACHED					3
 
 
diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index e0b276d..ddaf357 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -231,6 +231,61 @@ kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *a
 }
 
 static long
+kfd_ioctl_set_memory_policy(struct file *filep, struct kfd_process *p, void __user *arg)
+{
+	struct kfd_ioctl_set_memory_policy_args args;
+	struct kfd_dev *dev;
+	int err = 0;
+	struct kfd_process_device *pdd;
+	enum cache_policy default_policy, alternate_policy;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	if (args.default_policy != KFD_IOC_CACHE_POLICY_COHERENT
+	    && args.default_policy != KFD_IOC_CACHE_POLICY_NONCOHERENT) {
+		return -EINVAL;
+	}
+
+	if (args.alternate_policy != KFD_IOC_CACHE_POLICY_COHERENT
+	    && args.alternate_policy != KFD_IOC_CACHE_POLICY_NONCOHERENT) {
+		return -EINVAL;
+	}
+
+	dev = radeon_kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&p->mutex);
+
+	pdd = radeon_kfd_bind_process_to_device(dev, p);
+	if (IS_ERR(pdd) < 0) {
+		err = PTR_ERR(pdd);
+		goto out;
+	}
+
+	default_policy = (args.default_policy == KFD_IOC_CACHE_POLICY_COHERENT)
+			 ? cache_policy_coherent : cache_policy_noncoherent;
+
+	alternate_policy = (args.alternate_policy == KFD_IOC_CACHE_POLICY_COHERENT)
+			   ? cache_policy_coherent : cache_policy_noncoherent;
+
+	if (!dev->device_info->scheduler_class->set_cache_policy(dev->scheduler,
+								 pdd->scheduler_process,
+								 default_policy,
+								 alternate_policy,
+								 (void __user *)args.alternate_aperture_base,
+								 args.alternate_aperture_size))
+		err = -EINVAL;
+
+out:
+	mutex_unlock(&p->mutex);
+
+	return err;
+}
+
+
+static long
 kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct kfd_process *process;
@@ -253,6 +308,10 @@ kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		err = kfd_ioctl_destroy_queue(filep, process, (void __user *)arg);
 		break;
 
+	case KFD_IOC_SET_MEMORY_POLICY:
+		err = kfd_ioctl_set_memory_policy(filep, process, (void __user *)arg);
+		break;
+
 	default:
 		dev_err(kfd_device,
 			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index 9add5e5..3c3e7d6 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -162,6 +162,10 @@ struct cik_static_private {
 struct cik_static_process {
 	unsigned int vmid;
 	pasid_t pasid;
+
+	uint32_t sh_mem_config;
+	uint32_t ape1_base;
+	uint32_t ape1_limit;
 };
 
 struct cik_static_queue {
@@ -346,6 +350,7 @@ static void init_ats(struct cik_static_private *priv)
 
 			sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
 			sh_mem_config |= DEFAULT_MTYPE(MTYPE_NONCACHED);
+			sh_mem_config |= APE1_MTYPE(MTYPE_NONCACHED);
 
 			WRITE_REG(priv->dev, SH_MEM_CONFIG, sh_mem_config);
 
@@ -562,14 +567,26 @@ static void release_vmid(struct cik_static_private *priv, unsigned int vmid)
 	set_bit(vmid, &priv->free_vmid_mask);
 }
 
+static void program_sh_mem_settings(struct cik_static_private *sched,
+				    struct cik_static_process *proc)
+{
+	lock_srbm_index(sched);
+
+	vmid_select(sched, proc->vmid);
+
+	WRITE_REG(sched->dev, SH_MEM_CONFIG, proc->sh_mem_config);
+
+	WRITE_REG(sched->dev, SH_MEM_APE1_BASE, proc->ape1_base);
+	WRITE_REG(sched->dev, SH_MEM_APE1_LIMIT, proc->ape1_limit);
+
+	unlock_srbm_index(sched);
+}
+
 static void setup_vmid_for_process(struct cik_static_private *priv, struct cik_static_process *p)
 {
 	set_vmid_pasid_mapping(priv, p->vmid, p->pasid);
 
-	/*
-	 * SH_MEM_CONFIG and others need to be programmed differently
-	 * for 32/64-bit processes. And maybe other reasons.
-	 */
+	program_sh_mem_settings(priv, p);
 }
 
 static int
@@ -591,6 +608,12 @@ cik_static_register_process(struct kfd_scheduler *scheduler, struct kfd_process
 
 	hwp->pasid = process->pasid;
 
+	hwp->sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED)
+			     | DEFAULT_MTYPE(MTYPE_NONCACHED)
+			     | APE1_MTYPE(MTYPE_NONCACHED);
+	hwp->ape1_base = 1;
+	hwp->ape1_limit = 0;
+
 	setup_vmid_for_process(priv, hwp);
 
 	*scheduler_process = (struct kfd_scheduler_process *)hwp;
@@ -894,6 +917,64 @@ cik_static_interrupt_wq(struct kfd_scheduler *scheduler, const void *ih_ring_ent
 {
 }
 
+/* Low bits must be 0000/FFFF as required by HW, high bits must be 0 to stay in user mode. */
+#define APE1_FIXED_BITS_MASK 0xFFFF80000000FFFFULL
+#define APE1_LIMIT_ALIGNMENT 0xFFFF /* APE1 limit is inclusive and 64K aligned. */
+
+static bool cik_static_set_cache_policy(struct kfd_scheduler *scheduler,
+					struct kfd_scheduler_process *process,
+					enum cache_policy default_policy,
+					enum cache_policy alternate_policy,
+					void __user *alternate_aperture_base,
+					uint64_t alternate_aperture_size)
+{
+	struct cik_static_private *sched = kfd_scheduler_to_private(scheduler);
+	struct cik_static_process *proc = kfd_process_to_private(process);
+
+	uint32_t default_mtype;
+	uint32_t ape1_mtype;
+
+	if (alternate_aperture_size == 0) {
+		/* base > limit disables APE1 */
+		proc->ape1_base = 1;
+		proc->ape1_limit = 0;
+	} else {
+		/*
+		 * In FSA64, APE1_Base[63:0] = { 16{SH_MEM_APE1_BASE[31]}, SH_MEM_APE1_BASE[31:0], 0x0000 }
+		 * APE1_Limit[63:0] = { 16{SH_MEM_APE1_LIMIT[31]}, SH_MEM_APE1_LIMIT[31:0], 0xFFFF }
+		 * Verify that the base and size parameters can be represented in this format
+		 * and convert them. Additionally restrict APE1 to user-mode addresses.
+		 */
+
+		uint64_t base = (uintptr_t)alternate_aperture_base;
+		uint64_t limit = base + alternate_aperture_size - 1;
+
+		if (limit <= base)
+			return false;
+
+		if ((base & APE1_FIXED_BITS_MASK) != 0)
+			return false;
+
+		if ((limit & APE1_FIXED_BITS_MASK) != APE1_LIMIT_ALIGNMENT)
+			return false;
+
+		proc->ape1_base = base >> 16;
+		proc->ape1_limit = limit >> 16;
+	}
+
+	default_mtype = (default_policy == cache_policy_coherent) ? MTYPE_NONCACHED : MTYPE_CACHED;
+	ape1_mtype = (alternate_policy == cache_policy_coherent) ? MTYPE_NONCACHED : MTYPE_CACHED;
+
+	proc->sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED)
+			      | DEFAULT_MTYPE(default_mtype)
+			      | APE1_MTYPE(ape1_mtype);
+
+	program_sh_mem_settings(sched, proc);
+
+	return true;
+}
+
+
 const struct kfd_scheduler_class radeon_kfd_cik_static_scheduler_class = {
 	.name = "CIK static scheduler",
 	.create = cik_static_create,
@@ -908,4 +989,6 @@ const struct kfd_scheduler_class radeon_kfd_cik_static_scheduler_class = {
 
 	.interrupt_isr = cik_static_interrupt_isr,
 	.interrupt_wq = cik_static_interrupt_wq,
+
+	.set_cache_policy = cik_static_set_cache_policy,
 };
diff --git a/drivers/gpu/hsa/radeon/kfd_scheduler.h b/drivers/gpu/hsa/radeon/kfd_scheduler.h
index e5a93c4..9dc2994 100644
--- a/drivers/gpu/hsa/radeon/kfd_scheduler.h
+++ b/drivers/gpu/hsa/radeon/kfd_scheduler.h
@@ -31,6 +31,11 @@ struct kfd_scheduler;
 struct kfd_scheduler_process;
 struct kfd_scheduler_queue;
 
+enum cache_policy {
+	cache_policy_coherent,
+	cache_policy_noncoherent
+};
+
 struct kfd_scheduler_class {
 	const char *name;
 
@@ -58,6 +63,13 @@ struct kfd_scheduler_class {
 
 	bool (*interrupt_isr)(struct kfd_scheduler *, const void *ih_ring_entry);
 	void (*interrupt_wq)(struct kfd_scheduler *, const void *ih_ring_entry);
+
+	bool (*set_cache_policy)(struct kfd_scheduler *scheduler,
+				 struct kfd_scheduler_process *process,
+				 enum cache_policy default_policy,
+				 enum cache_policy alternate_policy,
+				 void __user *alternate_aperture_base,
+				 uint64_t alternate_aperture_size);
 };
 
 extern const struct kfd_scheduler_class radeon_kfd_cik_static_scheduler_class;
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index dcc5fe0..928e628 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -58,11 +58,24 @@ struct kfd_ioctl_destroy_queue_args {
 	uint32_t queue_id;		/* to KFD */
 };
 
+/* For kfd_ioctl_set_memory_policy_args.default_policy and alternate_policy */
+#define KFD_IOC_CACHE_POLICY_COHERENT 0
+#define KFD_IOC_CACHE_POLICY_NONCOHERENT 1
+
+struct kfd_ioctl_set_memory_policy_args {
+	uint32_t gpu_id;			/* to KFD */
+	uint32_t default_policy;		/* to KFD */
+	uint32_t alternate_policy;		/* to KFD */
+	uint64_t alternate_aperture_base;	/* to KFD */
+	uint64_t alternate_aperture_size;	/* to KFD */
+};
+
 #define KFD_IOC_MAGIC 'K'
 
 #define KFD_IOC_GET_VERSION	_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
 #define KFD_IOC_CREATE_QUEUE	_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
 #define KFD_IOC_DESTROY_QUEUE	_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
+#define KFD_IOC_SET_MEMORY_POLICY	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
 
 #pragma pack(pop)
 
-- 
1.9.1
