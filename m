From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 13/24] task_diag: shows memory consumption for memory mappings (v2)
Date: Mon,  6 Jul 2015 11:47:14 +0300
Message-ID: <1436172445-6979-14-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

The same information are shown in /proc/self/smaps.

v2: account the task_diag_vma_stat struct in taskdiag_packet_size()
    Fix 8-byte alignment for vma and vma_stats // David Ahern

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/proc/task_mmu.c             | 14 +--------
 include/linux/proc_fs.h        | 17 +++++++++++
 include/uapi/linux/task_diag.h | 25 +++++++++++++++++
 kernel/taskdiag.c              | 64 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 101 insertions(+), 19 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 6dee68d..c89f68c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -435,18 +435,6 @@ const struct file_operations proc_tid_maps_operations = {
 #define PSS_SHIFT 12
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
-struct mem_size_stats {
-	unsigned long resident;
-	unsigned long shared_clean;
-	unsigned long shared_dirty;
-	unsigned long private_clean;
-	unsigned long private_dirty;
-	unsigned long referenced;
-	unsigned long anonymous;
-	unsigned long anonymous_thp;
-	unsigned long swap;
-	u64 pss;
-};
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		unsigned long size, bool young, bool dirty)
@@ -526,7 +514,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 }
 #endif
 
-static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 497e58c..62d0079 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -92,4 +92,21 @@ struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter);
 struct task_struct *
 task_next_child(struct task_struct *parent, struct task_struct *prev, unsigned int pos);
 
+struct mem_size_stats {
+	unsigned long resident;
+	unsigned long shared_clean;
+	unsigned long shared_dirty;
+	unsigned long private_clean;
+	unsigned long private_dirty;
+	unsigned long referenced;
+	unsigned long anonymous;
+	unsigned long anonymous_thp;
+	unsigned long swap;
+	u64 pss;
+};
+
+struct mm_walk;
+int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			   struct mm_walk *walk);
+
 #endif /* _LINUX_PROC_FS_H */
diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index 943d8d1..73d33c8 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -11,6 +11,7 @@ enum {
 	TASK_DIAG_CRED,
 	TASK_DIAG_STAT,
 	TASK_DIAG_VMA,
+	TASK_DIAG_VMA_STAT,
 
 	/* other attributes */
 	TASK_DIAG_PID	= 64,	/* u32 */
@@ -23,6 +24,7 @@ enum {
 #define TASK_DIAG_SHOW_CRED	(1ULL << TASK_DIAG_CRED)
 #define TASK_DIAG_SHOW_STAT	(1ULL << TASK_DIAG_STAT)
 #define TASK_DIAG_SHOW_VMA	(1ULL << TASK_DIAG_VMA)
+#define TASK_DIAG_SHOW_VMA_STAT	(1ULL << TASK_DIAG_VMA_STAT)
 
 enum {
 	TASK_DIAG_RUNNING,
@@ -96,6 +98,19 @@ struct task_diag_creds {
 #define TASK_DIAG_VMA_F_NOHUGEPAGE	(1ULL << 26)
 #define TASK_DIAG_VMA_F_MERGEABLE	(1ULL << 27)
 
+struct task_diag_vma_stat {
+	__u64 resident;
+	__u64 shared_clean;
+	__u64 shared_dirty;
+	__u64 private_clean;
+	__u64 private_dirty;
+	__u64 referenced;
+	__u64 anonymous;
+	__u64 anonymous_thp;
+	__u64 swap;
+	__u64 pss;
+} __attribute__((__aligned__(NLA_ALIGNTO)));
+
 /* task_diag_vma must be NLA_ALIGN'ed */
 struct task_diag_vma {
 	__u64 start, end;
@@ -108,6 +123,8 @@ struct task_diag_vma {
 	__u16 vma_len;
 	__u16 name_off;
 	__u16 name_len;
+	__u16 stat_off;
+	__u16 stat_len;
 } __attribute__((__aligned__(NLA_ALIGNTO)));
 
 static inline char *task_diag_vma_name(struct task_diag_vma *vma)
@@ -118,6 +135,14 @@ static inline char *task_diag_vma_name(struct task_diag_vma *vma)
 	return ((char *)vma) + vma->name_off;
 }
 
+static inline struct task_diag_vma_stat *task_diag_vma_stat(struct task_diag_vma *vma)
+{
+	if (!vma->stat_len)
+		return NULL;
+
+	return ((void *)vma) + vma->stat_off;
+}
+
 #define TASK_DIAG_DUMP_ALL	0
 #define TASK_DIAG_DUMP_CHILDREN	1
 
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index c488c1b..8e00c3e 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -24,11 +24,17 @@ static size_t taskdiag_packet_size(u64 show_flags, int n_vma)
 		size += nla_total_size(sizeof(struct taskstats));
 
 	if (show_flags & TASK_DIAG_SHOW_VMA && n_vma > 0) {
+		size_t entry_size;
+
 		/*
 		 * 128 is a schwag on average path length for maps; used to
 		 * ballpark initial memory allocation for genl msg
 		 */
-		size += nla_total_size(sizeof(struct task_diag_vma) * n_vma + 128);
+		entry_size = sizeof(struct task_diag_vma) + 128;
+
+		if (show_flags & TASK_DIAG_SHOW_VMA_STAT)
+			entry_size += sizeof(struct task_diag_vma_stat);
+		size += nla_total_size(entry_size * n_vma);
 	}
 
 	return size;
@@ -292,8 +298,37 @@ out:
 	return name;
 }
 
+static void fill_diag_vma_stat(struct vm_area_struct *vma, struct task_diag_vma_stat *stat)
+{
+	struct task_diag_vma_stat tmp;
+	struct mem_size_stats mss;
+	struct mm_walk smaps_walk = {
+		.pmd_entry = smaps_pte_range,
+		.mm = vma->vm_mm,
+		.private = &mss,
+	};
+
+	memset(&mss, 0, sizeof mss);
+	memset(&tmp, 0, sizeof(tmp));
+
+	/* mmap_sem is held in m_start */
+	walk_page_vma(vma, &smaps_walk);
+
+	tmp.resident		= mss.resident;
+	tmp.pss			= mss.pss;
+	tmp.shared_clean	= mss.shared_clean;
+	tmp.private_clean	= mss.private_clean;
+	tmp.private_dirty	= mss.private_dirty;
+	tmp.referenced		= mss.referenced;
+	tmp.anonymous		= mss.anonymous;
+	tmp.anonymous_thp	= mss.anonymous_thp;
+	tmp.swap		= mss.swap;
+
+	memcpy(stat, &tmp, sizeof(*stat));
+}
+
 static int fill_vma(struct task_struct *p, struct sk_buff *skb,
-			struct netlink_callback *cb, bool *progress)
+		    struct netlink_callback *cb, bool *progress, u64 show_flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
@@ -301,7 +336,7 @@ static int fill_vma(struct task_struct *p, struct sk_buff *skb,
 	struct task_diag_vma *diag_vma;
 	unsigned long mark = 0;
 	char *page;
-	int i, rc = -EMSGSIZE;
+	int i, rc = -EMSGSIZE, size;
 
 	if (cb)
 		mark = cb->args[3];
@@ -316,6 +351,10 @@ static int fill_vma(struct task_struct *p, struct sk_buff *skb,
 		return -ENOMEM;
 	}
 
+	size = NLA_ALIGN(sizeof(struct task_diag_vma));
+	if (show_flags & TASK_DIAG_SHOW_VMA_STAT)
+		size += NLA_ALIGN(sizeof(struct task_diag_vma_stat));
+
 	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next, i++) {
 		unsigned char *b = skb_tail_pointer(skb);
@@ -328,13 +367,13 @@ static int fill_vma(struct task_struct *p, struct sk_buff *skb,
 
 		/* setup pointer for next map */
 		if (attr == NULL) {
-			attr = nla_reserve(skb, TASK_DIAG_VMA, sizeof(*diag_vma));
+			attr = nla_reserve(skb, TASK_DIAG_VMA, size);
 			if (!attr)
 				goto err;
 
 			diag_vma = nla_data(attr);
 		} else {
-			diag_vma = nla_reserve_nohdr(skb, sizeof(*diag_vma));
+			diag_vma = nla_reserve_nohdr(skb, size);
 
 			if (diag_vma == NULL) {
 				nlmsg_trim(skb, b);
@@ -344,6 +383,19 @@ static int fill_vma(struct task_struct *p, struct sk_buff *skb,
 
 		fill_diag_vma(vma, diag_vma);
 
+		if (show_flags & TASK_DIAG_SHOW_VMA_STAT) {
+			struct task_diag_vma_stat *stat;
+
+			stat = (void *) diag_vma + NLA_ALIGN(sizeof(struct task_diag_vma));
+
+			fill_diag_vma_stat(vma, stat);
+			diag_vma->stat_len = sizeof(struct task_diag_vma_stat);
+			diag_vma->stat_off = (void *) stat - (void *)diag_vma;
+		} else {
+			diag_vma->stat_len = 0;
+			diag_vma->stat_off = 0;
+		}
+
 		name = get_vma_name(vma, page);
 		if (IS_ERR(name)) {
 			nlmsg_trim(skb, b);
@@ -441,7 +493,7 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 
 	if (show_flags & TASK_DIAG_SHOW_VMA) {
 		if (i >= n)
-			err = fill_vma(tsk, skb, cb, &progress);
+			err = fill_vma(tsk, skb, cb, &progress, show_flags);
 		if (err)
 			goto err;
 		i++;
-- 
2.1.0
