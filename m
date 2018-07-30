From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 4/4] mm: proc/pid/smaps_rollup: convert to single value
 seq_file
Date: Mon, 30 Jul 2018 10:53:53 +0200
Message-ID: <bf4525b0-fd5b-4c4c-2cb3-adee3dd95a48@suse.cz>
References: <20180723111933.15443-1-vbabka@suse.cz>
 <20180723111933.15443-5-vbabka@suse.cz>
 <cb1d1965-9a13-e80f-dfde-a5d3bf9f510c@suse.cz> <20180726162637.GB25227@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180726162637.GB25227@avx2>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Daniel Colascione <dancol@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/26/2018 06:26 PM, Alexey Dobriyan wrote:
> On Wed, Jul 25, 2018 at 08:53:53AM +0200, Vlastimil Babka wrote:
>> I moved the reply to this thread since the "added to -mm tree"
>> notification Alexey replied to in <20180724182908.GD27053@avx2> has
>> reduced CC list and is not linked to the patch postings.
>>
>> On 07/24/2018 08:29 PM, Alexey Dobriyan wrote:
>>> On Mon, Jul 23, 2018 at 04:55:48PM -0700, akpm@linux-foundation.org wrote:
>>>> The patch titled
>>>>      Subject: mm: /proc/pid/smaps_rollup: convert to single value seq_file
>>>> has been added to the -mm tree.  Its filename is
>>>>      mm-proc-pid-smaps_rollup-convert-to-single-value-seq_file.patch
>>>
>>>> Subject: mm: /proc/pid/smaps_rollup: convert to single value seq_file
>>>>
>>>> The /proc/pid/smaps_rollup file is currently implemented via the
>>>> m_start/m_next/m_stop seq_file iterators shared with the other maps files,
>>>> that iterate over vma's.  However, the rollup file doesn't print anything
>>>> for each vma, only accumulate the stats.
>>>
>>> What I don't understand why keep seq_ops then and not do all the work in
>>> ->show hook.  Currently /proc/*/smaps_rollup is at ~500 bytes so with
>>> minimum 1 page seq buffer, no buffer resizing is possible.
>>
>> Hmm IIUC seq_file also provides the buffer and handles feeding the data
>> from there to the user process, which might have called read() with a smaller
>> buffer than that. So I would rather not avoid the seq_file infrastructure.
>> Or you're saying it could be converted to single_open()? Maybe, with more work.
> 
> Prefereably yes.

OK here it is. Sending as a new patch instead of delta, as that's easier
to review - the delta is significant. Line stats wise it's the same.
Again a bit less boilerplate thans to no special seq_ops, a bit more
copy/paste in the open and release functions. But I guess it's better
overall.

----8>----
>From c6a2eaf3bb3546509d6b7c42f8bcc56cd7e92f90 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 18 Jul 2018 13:14:30 +0200
Subject: [PATCH] mm: proc/pid/smaps_rollup: convert to single value seq_file

The /proc/pid/smaps_rollup file is currently implemented via the
m_start/m_next/m_stop seq_file iterators shared with the other maps files,
that iterate over vma's. However, the rollup file doesn't print anything
for each vma, only accumulate the stats.

There are some issues with the current code as reported in [1] - the
accumulated stats can get skewed if seq_file start()/stop() op is called
multiple times, if show() is called multiple times, and after seeks to
non-zero position.

Patch [1] fixed those within existing design, but I believe it is
fundamentally wrong to expose the vma iterators to the seq_file mechanism
when smaps_rollup shows logically a single set of values for the whole
address space.

This patch thus refactors the code to provide a single "value" at offset 0,
with vma iteration to gather the stats done internally. This fixes the
situations where results are skewed, and simplifies the code, especially
in show_smap(), at the expense of somewhat less code reuse.

[1] https://marc.info/?l=linux-mm&m=151927723128134&w=2

Reported-by: Daniel Colascione <dancol@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 fs/proc/internal.h |   1 -
 fs/proc/task_mmu.c | 155 ++++++++++++++++++++++++++++-----------------
 2 files changed, 96 insertions(+), 60 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 0c538769512a..f5b75d258d22 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -285,7 +285,6 @@ struct proc_maps_private {
 	struct inode *inode;
 	struct task_struct *task;
 	struct mm_struct *mm;
-	struct mem_size_stats *rollup;
 #ifdef CONFIG_MMU
 	struct vm_area_struct *tail_vma;
 #endif
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c47f3cab70a1..5ea1d64cb0b4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -247,7 +247,6 @@ static int proc_map_release(struct inode *inode, struct file *file)
 	if (priv->mm)
 		mmdrop(priv->mm);
 
-	kfree(priv->rollup);
 	return seq_release_private(inode, file);
 }
 
@@ -404,7 +403,6 @@ const struct file_operations proc_pid_maps_operations = {
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats {
-	bool first;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -418,7 +416,6 @@ struct mem_size_stats {
 	unsigned long swap;
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
-	unsigned long first_vma_start;
 	u64 pss;
 	u64 pss_locked;
 	u64 swap_pss;
@@ -775,57 +772,75 @@ static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss)
 
 static int show_smap(struct seq_file *m, void *v)
 {
-	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
-	struct mem_size_stats mss_stack;
-	struct mem_size_stats *mss;
+	struct mem_size_stats mss;
+
+	memset(&mss, 0, sizeof(mss));
+
+	smap_gather_stats(vma, &mss);
+
+	show_map_vma(m, vma);
+
+	SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
+	SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
+	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
+	seq_puts(m, " kB\n");
+
+	__show_smap(m, &mss);
+
+	if (arch_pkeys_enabled())
+		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
+	show_smap_vma_flags(m, vma);
+
+	m_cache_vma(m, vma);
+
+	return 0;
+}
+
+static int show_smaps_rollup(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	struct mem_size_stats mss;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	unsigned long last_vma_end = 0;
 	int ret = 0;
-	bool rollup_mode;
-	bool last_vma;
-
-	if (priv->rollup) {
-		rollup_mode = true;
-		mss = priv->rollup;
-		if (mss->first) {
-			mss->first_vma_start = vma->vm_start;
-			mss->first = false;
-		}
-		last_vma = !m_next_vma(priv, vma);
-	} else {
-		rollup_mode = false;
-		memset(&mss_stack, 0, sizeof(mss_stack));
-		mss = &mss_stack;
-	}
 
-	smap_gather_stats(vma, mss);
+	priv->task = get_proc_task(priv->inode);
+	if (!priv->task)
+		return -ESRCH;
 
-	if (!rollup_mode) {
-		show_map_vma(m, vma);
-	} else if (last_vma) {
-		show_vma_header_prefix(
-			m, mss->first_vma_start, vma->vm_end, 0, 0, 0, 0);
-		seq_pad(m, ' ');
-		seq_puts(m, "[rollup]\n");
-	} else {
-		ret = SEQ_SKIP;
+	mm = priv->mm;
+	if (!mm || !mmget_not_zero(mm)) {
+		ret = -ESRCH;
+		goto out_put_task;
 	}
 
-	if (!rollup_mode) {
-		SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
-		SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
-		SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
-		seq_puts(m, " kB\n");
-	}
+	memset(&mss, 0, sizeof(mss));
 
-	if (!rollup_mode || last_vma)
-		__show_smap(m, mss);
+	down_read(&mm->mmap_sem);
+	hold_task_mempolicy(priv);
 
-	if (!rollup_mode) {
-		if (arch_pkeys_enabled())
-			seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
-		show_smap_vma_flags(m, vma);
+	for (vma = priv->mm->mmap; vma; vma = vma->vm_next) {
+		smap_gather_stats(vma, &mss);
+		last_vma_end = vma->vm_end;
 	}
-	m_cache_vma(m, vma);
+
+	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+			       last_vma_end, 0, 0, 0, 0);
+	seq_pad(m, ' ');
+	seq_puts(m, "[rollup]\n");
+
+	__show_smap(m, &mss);
+
+	release_task_mempolicy(priv);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+
+out_put_task:
+	put_task_struct(priv->task);
+	priv->task = NULL;
+
 	return ret;
 }
 #undef SEQ_PUT_DEC
@@ -842,23 +857,45 @@ static int pid_smaps_open(struct inode *inode, struct file *file)
 	return do_maps_open(inode, file, &proc_pid_smaps_op);
 }
 
-static int pid_smaps_rollup_open(struct inode *inode, struct file *file)
+static int smaps_rollup_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
+	int ret;
 	struct proc_maps_private *priv;
-	int ret = do_maps_open(inode, file, &proc_pid_smaps_op);
-
-	if (ret < 0)
-		return ret;
-	seq = file->private_data;
-	priv = seq->private;
-	priv->rollup = kzalloc(sizeof(*priv->rollup), GFP_KERNEL);
-	if (!priv->rollup) {
-		proc_map_release(inode, file);
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL_ACCOUNT);
+	if (!priv)
 		return -ENOMEM;
+
+	ret = single_open(file, show_smaps_rollup, priv);
+	if (ret)
+		goto out_free;
+
+	priv->inode = inode;
+	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR(priv->mm)) {
+		ret = PTR_ERR(priv->mm);
+
+		single_release(inode, file);
+		goto out_free;
 	}
-	priv->rollup->first = true;
+
 	return 0;
+
+out_free:
+	kfree(priv);
+	return ret;
+}
+
+static int smaps_rollup_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct proc_maps_private *priv = seq->private;
+
+	if (priv->mm)
+		mmdrop(priv->mm);
+
+	kfree(priv);
+	return single_release(inode, file);
 }
 
 const struct file_operations proc_pid_smaps_operations = {
@@ -869,10 +906,10 @@ const struct file_operations proc_pid_smaps_operations = {
 };
 
 const struct file_operations proc_pid_smaps_rollup_operations = {
-	.open		= pid_smaps_rollup_open,
+	.open		= smaps_rollup_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_map_release,
+	.release	= smaps_rollup_release,
 };
 
 enum clear_refs_types {
-- 
2.18.0
