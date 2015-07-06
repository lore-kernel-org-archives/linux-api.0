From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 12/24] task_diag: add a new group to get tasks memory mappings (v2)
Date: Mon,  6 Jul 2015 11:47:13 +0300
Message-ID: <1436172445-6979-13-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

v2: Fixes from David Ahern
    * Fix 8-byte alignment
    * Change implementation of DIAG_VMA attribute:

This patch puts the filename into the task_diag_vma struct and
converts TASK_DIAG_VMA attribute into a series of task_diag_vma.
Now is there is a single TASK_DIAG_VMA attribute that is parsed
as:

 | struct task_diag_vma | filename | ...

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/task_diag.h |  54 +++++++++
 kernel/taskdiag.c              | 255 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 306 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index c51380a..943d8d1 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -2,6 +2,7 @@
 #define _LINUX_TASK_DIAG_H
 
 #include <linux/types.h>
+#include <linux/netlink.h>
 #include <linux/capability.h>
 
 enum {
@@ -9,6 +10,7 @@ enum {
 	TASK_DIAG_BASE	= 0,
 	TASK_DIAG_CRED,
 	TASK_DIAG_STAT,
+	TASK_DIAG_VMA,
 
 	/* other attributes */
 	TASK_DIAG_PID	= 64,	/* u32 */
@@ -20,6 +22,7 @@ enum {
 #define TASK_DIAG_SHOW_BASE	(1ULL << TASK_DIAG_BASE)
 #define TASK_DIAG_SHOW_CRED	(1ULL << TASK_DIAG_CRED)
 #define TASK_DIAG_SHOW_STAT	(1ULL << TASK_DIAG_STAT)
+#define TASK_DIAG_SHOW_VMA	(1ULL << TASK_DIAG_VMA)
 
 enum {
 	TASK_DIAG_RUNNING,
@@ -64,6 +67,57 @@ struct task_diag_creds {
 	__u32 fsgid;
 };
 
+#define TASK_DIAG_VMA_F_READ		(1ULL <<  0)
+#define TASK_DIAG_VMA_F_WRITE		(1ULL <<  1)
+#define TASK_DIAG_VMA_F_EXEC		(1ULL <<  2)
+#define TASK_DIAG_VMA_F_SHARED		(1ULL <<  3)
+#define TASK_DIAG_VMA_F_MAYREAD		(1ULL <<  4)
+#define TASK_DIAG_VMA_F_MAYWRITE	(1ULL <<  5)
+#define TASK_DIAG_VMA_F_MAYEXEC		(1ULL <<  6)
+#define TASK_DIAG_VMA_F_MAYSHARE	(1ULL <<  7)
+#define TASK_DIAG_VMA_F_GROWSDOWN	(1ULL <<  8)
+#define TASK_DIAG_VMA_F_PFNMAP		(1ULL <<  9)
+#define TASK_DIAG_VMA_F_DENYWRITE	(1ULL << 10)
+#define TASK_DIAG_VMA_F_MPX		(1ULL << 11)
+#define TASK_DIAG_VMA_F_LOCKED		(1ULL << 12)
+#define TASK_DIAG_VMA_F_IO		(1ULL << 13)
+#define TASK_DIAG_VMA_F_SEQ_READ	(1ULL << 14)
+#define TASK_DIAG_VMA_F_RAND_READ	(1ULL << 15)
+#define TASK_DIAG_VMA_F_DONTCOPY	(1ULL << 16)
+#define TASK_DIAG_VMA_F_DONTEXPAND	(1ULL << 17)
+#define TASK_DIAG_VMA_F_ACCOUNT		(1ULL << 18)
+#define TASK_DIAG_VMA_F_NORESERVE	(1ULL << 19)
+#define TASK_DIAG_VMA_F_HUGETLB		(1ULL << 20)
+#define TASK_DIAG_VMA_F_ARCH_1		(1ULL << 21)
+#define TASK_DIAG_VMA_F_DONTDUMP	(1ULL << 22)
+#define TASK_DIAG_VMA_F_SOFTDIRTY	(1ULL << 23)
+#define TASK_DIAG_VMA_F_MIXEDMAP	(1ULL << 24)
+#define TASK_DIAG_VMA_F_HUGEPAGE	(1ULL << 25)
+#define TASK_DIAG_VMA_F_NOHUGEPAGE	(1ULL << 26)
+#define TASK_DIAG_VMA_F_MERGEABLE	(1ULL << 27)
+
+/* task_diag_vma must be NLA_ALIGN'ed */
+struct task_diag_vma {
+	__u64 start, end;
+	__u64 vm_flags;
+	__u64 pgoff;
+	__u32 major;
+	__u32 minor;
+	__u64 inode;
+	__u32 generation;
+	__u16 vma_len;
+	__u16 name_off;
+	__u16 name_len;
+} __attribute__((__aligned__(NLA_ALIGNTO)));
+
+static inline char *task_diag_vma_name(struct task_diag_vma *vma)
+{
+	if (!vma->name_len)
+		return NULL;
+
+	return ((char *)vma) + vma->name_off;
+}
+
 #define TASK_DIAG_DUMP_ALL	0
 #define TASK_DIAG_DUMP_CHILDREN	1
 
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index a49ccab..c488c1b 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -8,7 +8,7 @@
 #include <linux/sched.h>
 #include <linux/taskstats.h>
 
-static size_t taskdiag_packet_size(u64 show_flags)
+static size_t taskdiag_packet_size(u64 show_flags, int n_vma)
 {
 	size_t size;
 
@@ -23,6 +23,14 @@ static size_t taskdiag_packet_size(u64 show_flags)
 	if (show_flags & TASK_DIAG_SHOW_STAT)
 		size += nla_total_size(sizeof(struct taskstats));
 
+	if (show_flags & TASK_DIAG_SHOW_VMA && n_vma > 0) {
+		/*
+		 * 128 is a schwag on average path length for maps; used to
+		 * ballpark initial memory allocation for genl msg
+		 */
+		size += nla_total_size(sizeof(struct task_diag_vma) * n_vma + 128);
+	}
+
 	return size;
 }
 
@@ -150,12 +158,245 @@ static int fill_creds(struct task_struct *p, struct sk_buff *skb)
 	return 0;
 }
 
+static u64 get_vma_flags(struct vm_area_struct *vma)
+{
+	u64 flags = 0;
+
+	static const u64 mnemonics[BITS_PER_LONG] = {
+		/*
+		 * In case if we meet a flag we don't know about.
+		 */
+		[0 ... (BITS_PER_LONG-1)] = 0,
+
+		[ilog2(VM_READ)]	= TASK_DIAG_VMA_F_READ,
+		[ilog2(VM_WRITE)]	= TASK_DIAG_VMA_F_WRITE,
+		[ilog2(VM_EXEC)]	= TASK_DIAG_VMA_F_EXEC,
+		[ilog2(VM_SHARED)]	= TASK_DIAG_VMA_F_SHARED,
+		[ilog2(VM_MAYREAD)]	= TASK_DIAG_VMA_F_MAYREAD,
+		[ilog2(VM_MAYWRITE)]	= TASK_DIAG_VMA_F_MAYWRITE,
+		[ilog2(VM_MAYEXEC)]	= TASK_DIAG_VMA_F_MAYEXEC,
+		[ilog2(VM_MAYSHARE)]	= TASK_DIAG_VMA_F_MAYSHARE,
+		[ilog2(VM_GROWSDOWN)]	= TASK_DIAG_VMA_F_GROWSDOWN,
+		[ilog2(VM_PFNMAP)]	= TASK_DIAG_VMA_F_PFNMAP,
+		[ilog2(VM_DENYWRITE)]	= TASK_DIAG_VMA_F_DENYWRITE,
+#ifdef CONFIG_X86_INTEL_MPX
+		[ilog2(VM_MPX)]		= TASK_DIAG_VMA_F_MPX,
+#endif
+		[ilog2(VM_LOCKED)]	= TASK_DIAG_VMA_F_LOCKED,
+		[ilog2(VM_IO)]		= TASK_DIAG_VMA_F_IO,
+		[ilog2(VM_SEQ_READ)]	= TASK_DIAG_VMA_F_SEQ_READ,
+		[ilog2(VM_RAND_READ)]	= TASK_DIAG_VMA_F_RAND_READ,
+		[ilog2(VM_DONTCOPY)]	= TASK_DIAG_VMA_F_DONTCOPY,
+		[ilog2(VM_DONTEXPAND)]	= TASK_DIAG_VMA_F_DONTEXPAND,
+		[ilog2(VM_ACCOUNT)]	= TASK_DIAG_VMA_F_ACCOUNT,
+		[ilog2(VM_NORESERVE)]	= TASK_DIAG_VMA_F_NORESERVE,
+		[ilog2(VM_HUGETLB)]	= TASK_DIAG_VMA_F_HUGETLB,
+		[ilog2(VM_ARCH_1)]	= TASK_DIAG_VMA_F_ARCH_1,
+		[ilog2(VM_DONTDUMP)]	= TASK_DIAG_VMA_F_DONTDUMP,
+#ifdef CONFIG_MEM_SOFT_DIRTY
+		[ilog2(VM_SOFTDIRTY)]	= TASK_DIAG_VMA_F_SOFTDIRTY,
+#endif
+		[ilog2(VM_MIXEDMAP)]	= TASK_DIAG_VMA_F_MIXEDMAP,
+		[ilog2(VM_HUGEPAGE)]	= TASK_DIAG_VMA_F_HUGEPAGE,
+		[ilog2(VM_NOHUGEPAGE)]	= TASK_DIAG_VMA_F_NOHUGEPAGE,
+		[ilog2(VM_MERGEABLE)]	= TASK_DIAG_VMA_F_MERGEABLE,
+	};
+	size_t i;
+
+	for (i = 0; i < BITS_PER_LONG; i++) {
+		if (vma->vm_flags & (1UL << i))
+			flags |= mnemonics[i];
+	}
+
+	return flags;
+}
+
+static int task_vma_num(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+	int n_vma = 0;
+
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+		return 0;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next, n_vma++)
+		;
+
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+
+	return n_vma;
+}
+
+/*
+ * use a tmp variable and copy to input arg to deal with
+ * alignment issues. diag_vma contains u64 elements which
+ * means extended load operations can be used and those can
+ * require 8-byte alignment (e.g., sparc)
+ */
+static void fill_diag_vma(struct vm_area_struct *vma,
+			  struct task_diag_vma *diag_vma)
+{
+	struct task_diag_vma tmp;
+
+	/* We don't show the stack guard page in /proc/maps */
+	tmp.start = vma->vm_start;
+	if (stack_guard_page_start(vma, tmp.start))
+		tmp.start += PAGE_SIZE;
+
+	tmp.end = vma->vm_end;
+	if (stack_guard_page_end(vma, tmp.end))
+		tmp.end -= PAGE_SIZE;
+	tmp.vm_flags = get_vma_flags(vma);
+
+	if (vma->vm_file) {
+		struct inode *inode = file_inode(vma->vm_file);
+		dev_t dev;
+
+		dev = inode->i_sb->s_dev;
+		tmp.major = MAJOR(dev);
+		tmp.minor = MINOR(dev);
+		tmp.inode = inode->i_ino;
+		tmp.generation = inode->i_generation;
+		tmp.pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
+	} else {
+		tmp.major = 0;
+		tmp.minor = 0;
+		tmp.inode = 0;
+		tmp.generation = 0;
+		tmp.pgoff = 0;
+	}
+
+	memcpy(diag_vma, &tmp, sizeof(*diag_vma));
+}
+
+static const char *get_vma_name(struct vm_area_struct *vma, char *page)
+{
+	const char *name = NULL;
+
+	if (vma->vm_file) {
+		name = d_path(&vma->vm_file->f_path, page, PAGE_SIZE);
+		goto out;
+	}
+
+	if (vma->vm_ops && vma->vm_ops->name) {
+		name = vma->vm_ops->name(vma);
+		if (name)
+			goto out;
+	}
+
+	name = arch_vma_name(vma);
+
+out:
+	return name;
+}
+
+static int fill_vma(struct task_struct *p, struct sk_buff *skb,
+			struct netlink_callback *cb, bool *progress)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	struct nlattr *attr = NULL;
+	struct task_diag_vma *diag_vma;
+	unsigned long mark = 0;
+	char *page;
+	int i, rc = -EMSGSIZE;
+
+	if (cb)
+		mark = cb->args[3];
+
+	mm = p->mm;
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+		return 0;
+
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page) {
+		mmput(mm);
+		return -ENOMEM;
+	}
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next, i++) {
+		unsigned char *b = skb_tail_pointer(skb);
+		const char *name;
+		void *pfile;
+
+
+		if (mark >= vma->vm_start)
+			continue;
+
+		/* setup pointer for next map */
+		if (attr == NULL) {
+			attr = nla_reserve(skb, TASK_DIAG_VMA, sizeof(*diag_vma));
+			if (!attr)
+				goto err;
+
+			diag_vma = nla_data(attr);
+		} else {
+			diag_vma = nla_reserve_nohdr(skb, sizeof(*diag_vma));
+
+			if (diag_vma == NULL) {
+				nlmsg_trim(skb, b);
+				goto out;
+			}
+		}
+
+		fill_diag_vma(vma, diag_vma);
+
+		name = get_vma_name(vma, page);
+		if (IS_ERR(name)) {
+			nlmsg_trim(skb, b);
+			rc = PTR_ERR(name);
+			goto out;
+		}
+
+		if (name) {
+			diag_vma->name_len = strlen(name) + 1;
+
+			/* reserves NLA_ALIGN(len) */
+			pfile = nla_reserve_nohdr(skb, diag_vma->name_len);
+			if (pfile == NULL) {
+				nlmsg_trim(skb, b);
+				goto out;
+			}
+			diag_vma->name_off = pfile - (void *) diag_vma;
+			memcpy(pfile, name, diag_vma->name_len);
+		} else {
+			diag_vma->name_len = 0;
+			diag_vma->name_off = 0;
+		}
+
+		mark = vma->vm_start;
+
+		diag_vma->vma_len = skb_tail_pointer(skb) - (unsigned char *) diag_vma;
+
+		*progress = true;
+	}
+
+	rc = 0;
+	mark = 0;
+out:
+	if (*progress)
+		attr->nla_len = skb_tail_pointer(skb) - (unsigned char *) attr;
+
+err:
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	free_page((unsigned long) page);
+	if (cb)
+		cb->args[3] = mark;
+
+	return rc;
+}
+
 static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 				u64 show_flags, u32 portid, u32 seq,
 				struct netlink_callback *cb)
 {
 	void *reply;
 	int err = 0, i = 0, n = 0;
+	bool progress = false;
 	int flags = 0;
 	u32 pid;
 
@@ -198,13 +439,21 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 		i++;
 	}
 
+	if (show_flags & TASK_DIAG_SHOW_VMA) {
+		if (i >= n)
+			err = fill_vma(tsk, skb, cb, &progress);
+		if (err)
+			goto err;
+		i++;
+	}
+
 	genlmsg_end(skb, reply);
 	if (cb)
 		cb->args[2] = 0;
 
 	return 0;
 err:
-	if (err == -EMSGSIZE && i != 0) {
+	if (err == -EMSGSIZE && (i > n || progress)) {
 		if (cb)
 			cb->args[2] = i;
 		genlmsg_end(skb, reply);
@@ -374,7 +623,7 @@ int taskdiag_doit(struct sk_buff *skb, struct genl_info *info)
 		return -EPERM;
 	}
 
-	size = taskdiag_packet_size(req.show_flags);
+	size = taskdiag_packet_size(req.show_flags, task_vma_num(tsk->mm));
 
 	while (1) {
 		msg = genlmsg_new(size, GFP_KERNEL);
-- 
2.1.0
