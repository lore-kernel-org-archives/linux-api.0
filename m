From: nixiaoming <nixiaoming@huawei.com>
Subject: [PATCH] virt/kvm avoids oops by adding parameter checking
Date: Tue, 22 Aug 2017 09:09:09 +0800
Message-ID: <20170822010909.103060-1-nixiaoming@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rkrcmar@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The error parameter passed through the external interface causes the system oops.
So it is necessary to increase the parameter check for all EXPORT_SYMBOL_GPL

example:
 void kvm_get_kvm(struct kvm *kvm)
 {
        refcount_inc(&kvm->users_count); /*oops if kvm == NULL */
 }
 EXPORT_SYMBOL_GPL(kvm_get_kvm);

Signed-off-by: nixiaoming <nixiaoming@huawei.com>
---
 virt/kvm/eventfd.c  |  2 ++
 virt/kvm/kvm_main.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index f2ac53a..250200b 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -444,6 +444,8 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 {
 	struct kvm_irq_ack_notifier *kian;
 	int gsi, idx;
+	if (kvm == NULL)
+		return false;
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 15252d7..3e25de0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -150,6 +150,8 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 int vcpu_load(struct kvm_vcpu *vcpu)
 {
 	int cpu;
+	if (vcpu == NULL)
+		return -EINVAL;
 
 	if (mutex_lock_killable(&vcpu->mutex))
 		return -EINTR;
@@ -163,6 +165,8 @@ EXPORT_SYMBOL_GPL(vcpu_load);
 
 void vcpu_put(struct kvm_vcpu *vcpu)
 {
+	if (vcpu == NULL)
+		return;
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
@@ -235,6 +239,8 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+	if (kvm == NULL)
+		return;
 	/*
 	 * Read tlbs_dirty before setting KVM_REQ_TLB_FLUSH in
 	 * kvm_make_all_cpus_request.
@@ -269,6 +275,9 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	struct page *page;
 	int r;
 
+	if (vcpu == NULL)
+		return -EINVAL;
+
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
 	vcpu->kvm = kvm;
@@ -305,6 +314,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_init);
 
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
+	if (vcpu == NULL)
+		return;
 	/*
 	 * no need for rcu_read_lock as VCPU_RUN is the only place that
 	 * will change the vcpu->pid pointer and on uninit all file
@@ -779,12 +790,16 @@ static void kvm_destroy_vm(struct kvm *kvm)
 
 void kvm_get_kvm(struct kvm *kvm)
 {
+	if (kvm == NULL)
+		return;
 	refcount_inc(&kvm->users_count);
 }
 EXPORT_SYMBOL_GPL(kvm_get_kvm);
 
 void kvm_put_kvm(struct kvm *kvm)
 {
+	if (kvm == NULL)
+		return;
 	if (refcount_dec_and_test(&kvm->users_count))
 		kvm_destroy_vm(kvm);
 }
@@ -938,6 +953,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int as_id, id;
 	enum kvm_mr_change change;
 
+	if (mem == NULL)
+		return -EINVAL;
+
 	r = check_memory_region_flags(mem);
 	if (r)
 		goto out;
@@ -1121,6 +1139,9 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	unsigned long n;
 	unsigned long any = 0;
 
+	if (log == NULL || is_dirty == NULL)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1178,6 +1199,9 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 
+	if (log == NULL || is_dirty == NULL)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1996,6 +2020,8 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	int r;
+	if (ghc == NULL)
+		return -EINVAL;
 	gpa_t gpa = ghc->gpa + offset;
 
 	BUG_ON(len + offset > ghc->len);
@@ -2225,6 +2251,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
 	struct swait_queue_head *wqp;
+	if (vcpu == NULL)
+		return false;
 
 	wqp = kvm_arch_vcpu_wq(vcpu);
 	if (swait_active(wqp)) {
@@ -2244,7 +2272,11 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
 	int me;
-	int cpu = vcpu->cpu;
+	int cpu;
+
+	if (vcpu == NULL)
+		return;
+	cpu = vcpu->cpu;
 
 	if (kvm_vcpu_wake_up(vcpu))
 		return;
@@ -2264,6 +2296,9 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 	struct task_struct *task = NULL;
 	int ret = 0;
 
+	if (target == NULL)
+		return -EINVAL;
+
 	rcu_read_lock();
 	pid = rcu_dereference(target->pid);
 	if (pid)
@@ -2319,13 +2354,19 @@ static bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
-	struct kvm *kvm = me->kvm;
+	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int last_boosted_vcpu;
 	int yielded = 0;
 	int try = 3;
 	int pass;
 	int i;
+	if (me == NULL)
+		return;
+	kvm = me->kvm;
+	if (kvm == NULL)
+		return;
+	last_boosted_vcpu = me->kvm->last_boosted_vcpu;
 
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
@@ -3542,6 +3583,8 @@ static int __kvm_io_bus_read(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 			     struct kvm_io_range *range, void *val)
 {
 	int idx;
+	if (range == NULL)
+		return -EINVAL;
 
 	idx = kvm_io_bus_get_first_dev(bus, range->addr, range->len);
 	if (idx < 0)
@@ -3653,6 +3696,9 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	int dev_idx, srcu_idx;
 	struct kvm_io_device *iodev = NULL;
 
+	if (kvm == NULL)
+		return NULL;
+
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 
 	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
-- 
2.11.0.1
