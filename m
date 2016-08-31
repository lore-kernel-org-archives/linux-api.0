From: Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: [PACTH v4 1/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Wed, 31 Aug 2016 11:45:37 +0200
Message-ID: <ca113c1a-d016-74a9-2e72-da1f881bfb8e@samsung.com>
References: <1471386804-7236-1-git-send-email-robert.foss@collabora.com>
 <1471386804-7236-2-git-send-email-robert.foss@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1471386804-7236-2-git-send-email-robert.foss@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robert.foss@collabora.com, corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, koct9i@gmail.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, john.stultz@linaro.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, mingo@kernel.org, keescook@chromium.org, viro@zeniv.linux.org.uk, gorcunov@openvz.org, mnfhuang@gmail.com, adobriyan@gmail.com, calvinowens@fb.com, jdanis@google.com, jann@thejh.net, sonnyrao@chromium.org, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Mateusz Guzik <mguzik@redhat.com>Michal Hocko <mhocko@>
List-Id: linux-api@vger.kernel.org

Hi Robert,

On 08/17/2016 12:33 AM, robert.foss@collabora.com wrote:
> From: Robert Foss <robert.foss@collabora.com>
>
> This is based on earlier work by Thiago Goncales. It implements a new
> per process proc file which summarizes the contents of the smaps file
> but doesn't display any addresses.  It gives more detailed information
> than statm like the PSS (proprotional set size).  It differs from the
> original implementation in that it doesn't use the full blown set of
> seq operations, uses a different termination condition, and doesn't
> displayed "Locked" as that was broken on the original implemenation.
>
> This new proc file provides information faster than parsing the potentially
> huge smaps file.
>
> Tested-by: Robert Foss <robert.foss@collabora.com>
> Signed-off-by: Robert Foss <robert.foss@collabora.com>
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
>  fs/proc/base.c     |   1 +
>  fs/proc/internal.h |   2 +
>  fs/proc/task_mmu.c | 141 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 144 insertions(+)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index a11eb71..de3acdf 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2855,6 +2855,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>  	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
>  	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
> +	REG("totmaps",    S_IRUGO, proc_totmaps_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
>  	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index aa27810..99f97d7 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -297,6 +297,8 @@ extern const struct file_operations proc_pid_smaps_operations;
>  extern const struct file_operations proc_tid_smaps_operations;
>  extern const struct file_operations proc_clear_refs_operations;
>  extern const struct file_operations proc_pagemap_operations;
> +extern const struct file_operations proc_totmaps_operations;
> +
>
>  extern unsigned long task_vsize(struct mm_struct *);
>  extern unsigned long task_statm(struct mm_struct *,
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 4648c7f..fd8fd7f 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -802,6 +802,75 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
>  	return 0;
>  }
>
> +static void add_smaps_sum(struct mem_size_stats *mss,
> +		struct mem_size_stats *mss_sum)
> +{
> +	mss_sum->resident += mss->resident;
> +	mss_sum->pss += mss->pss;
> +	mss_sum->shared_clean += mss->shared_clean;
> +	mss_sum->shared_dirty += mss->shared_dirty;
> +	mss_sum->private_clean += mss->private_clean;
> +	mss_sum->private_dirty += mss->private_dirty;
> +	mss_sum->referenced += mss->referenced;
> +	mss_sum->anonymous += mss->anonymous;
> +	mss_sum->anonymous_thp += mss->anonymous_thp;
> +	mss_sum->swap += mss->swap;
> +}
> +
> +static int totmaps_proc_show(struct seq_file *m, void *data)
> +{
> +	struct proc_maps_private *priv = m->private;
> +	struct mm_struct *mm = priv->mm;
> +	struct vm_area_struct *vma;
> +	struct mem_size_stats mss_sum;
> +
> +	memset(&mss_sum, 0, sizeof(mss_sum));
> +	down_read(&mm->mmap_sem);
> +	hold_task_mempolicy(priv);
> +
> +	for (vma = mm->mmap; vma != priv->tail_vma; vma = vma->vm_next) {
> +		struct mem_size_stats mss;
> +		struct mm_walk smaps_walk = {
> +			.pmd_entry = smaps_pte_range,
> +			.mm = vma->vm_mm,
> +			.private = &mss,
> +		};
> +
> +		if (vma->vm_mm && !is_vm_hugetlb_page(vma)) {
> +			memset(&mss, 0, sizeof(mss));
> +			walk_page_vma(vma, &smaps_walk);
> +			add_smaps_sum(&mss, &mss_sum);
> +		}
> +	}
> +
> +	release_task_mempolicy(priv);
> +	up_read(&mm->mmap_sem);
> +
> +	seq_printf(m,
> +		   "Rss:            %8lu kB\n"
> +		   "Pss:            %8lu kB\n"
> +		   "Shared_Clean:   %8lu kB\n"
> +		   "Shared_Dirty:   %8lu kB\n"
> +		   "Private_Clean:  %8lu kB\n"
> +		   "Private_Dirty:  %8lu kB\n"
> +		   "Referenced:     %8lu kB\n"
> +		   "Anonymous:      %8lu kB\n"
> +		   "AnonHugePages:  %8lu kB\n"
> +		   "Swap:           %8lu kB\n",
> +		   mss_sum.resident >> 10,
> +		   (unsigned long)(mss_sum.pss >> (10 + PSS_SHIFT)),
> +		   mss_sum.shared_clean  >> 10,
> +		   mss_sum.shared_dirty  >> 10,
> +		   mss_sum.private_clean >> 10,
> +		   mss_sum.private_dirty >> 10,
> +		   mss_sum.referenced >> 10,
> +		   mss_sum.anonymous >> 10,
> +		   mss_sum.anonymous_thp >> 10,
> +		   mss_sum.swap >> 10);
> +
> +	return 0;
> +}
> +
>  static int show_pid_smap(struct seq_file *m, void *v)
>  {
>  	return show_smap(m, v, 1);
> @@ -812,6 +881,28 @@ static int show_tid_smap(struct seq_file *m, void *v)
>  	return show_smap(m, v, 0);
>  }
>
> +static void *m_totmaps_start(struct seq_file *p, loff_t *pos)
> +{
> +	return NULL + (*pos == 0);
> +}
> +
> +static void *m_totmaps_next(struct seq_file *p, void *v, loff_t *pos)
> +{
> +	++*pos;
> +	return NULL;
> +}
> +
> +static void m_totmaps_stop(struct seq_file *p, void *v)
> +{
> +}
> +
> +static const struct seq_operations proc_totmaps_op = {
> +	.start	= m_totmaps_start,
> +	.next	= m_totmaps_next,
> +	.stop	= m_totmaps_stop,
> +	.show	= totmaps_proc_show
> +};
> +
>  static const struct seq_operations proc_pid_smaps_op = {
>  	.start	= m_start,
>  	.next	= m_next,
> @@ -836,6 +927,49 @@ static int tid_smaps_open(struct inode *inode, struct file *file)
>  	return do_maps_open(inode, file, &proc_tid_smaps_op);
>  }
>
> +static int totmaps_open(struct inode *inode, struct file *file)
> +{
> +	struct proc_maps_private *priv = NULL;
> +	struct seq_file *seq;
> +	int ret;
> +
> +	ret = do_maps_open(inode, file, &proc_totmaps_op);
> +	if (ret)
> +		goto error;
> +
> +	/*
> +	 * We need to grab references to the task_struct
> +	 * at open time, because there's a potential information
> +	 * leak where the totmaps file is opened and held open
> +	 * while the underlying pid to task mapping changes
> +	 * underneath it
> +	 */
> +	seq = file->private_data;
> +	priv = seq->private;
> +	priv->task = get_proc_task(inode);
> +	if (!priv->task) {
> +		ret = -ESRCH;
> +		goto error_free;
> +	}
> +
> +	return 0;
> +
> +error_free:
> +	proc_map_release(inode, file);
> +error:
> +	return ret;
> +}
> +
> +static int totmaps_release(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *seq = file->private_data;
> +	struct proc_maps_private *priv = seq->private;
> +
> +	put_task_struct(priv->task);
> +
> +	return proc_map_release(inode, file);
> +}
> +
>  const struct file_operations proc_pid_smaps_operations = {
>  	.open		= pid_smaps_open,
>  	.read		= seq_read,
> @@ -850,6 +984,13 @@ const struct file_operations proc_tid_smaps_operations = {
>  	.release	= proc_map_release,
>  };
>
> +const struct file_operations proc_totmaps_operations = {
> +	.open		= totmaps_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= totmaps_release,
> +};
> +
>  enum clear_refs_types {
>  	CLEAR_REFS_ALL = 1,
>  	CLEAR_REFS_ANON,
>

When reading totmaps of kernel processes the following NULL pointer
dereference occurs:

Unable to handle kernel NULL pointer dereference at virtual address 00000044
pgd = ee6e0000
[00000044] *pgd=7b83a831
Internal error: Oops: 17 [#6] PREEMPT SMP ARM
Modules linked in:
CPU: 2 PID: 1495 Comm: cat Tainted: G      D W 
4.8.0-rc2-00010-g22fe2db-dirty #159
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
task: ee596e00 task.stack: ee470000
PC is at down_read+0xc/0x48
LR is at totmaps_proc_show+0x2c/0x1e8
pc : [<c06c01f4>]    lr : [<c022a154>]    psr: 40000013
sp : ee471db8  ip : 00000000  fp : 00000000
r10: edfe1080  r9 : 00000001  r8 : 00000044
r7 : ee4abd00  r6 : edfe1080  r5 : edde0b80  r4 : 00000044
r3 : 00000000  r2 : 00000000  r1 : ffffffc8  r0 : 00000044
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 6e6e004a  DAC: 00000051
Process cat (pid: 1495, stack limit = 0xee470210)
Stack: (0xee471db8 to 0xee472000)
1da0:                                                       00000000 
c022a154
1dc0: ee596e00 024200ca 00000000 024200ca 00000000 00000081 c0b02594 
024200ca
1de0: 00000055 ee5b7e44 00000800 c019cad0 00000000 c06c1af0 00000001 
c032aa90
1e00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
1e20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
1e40: 00000000 00000000 c0a69764 c0a69758 0000000b c01afd60 eff4d000 
eff4d000
1e60: edc55f20 00000000 edfe10b0 0001c000 20000013 c06bfc9c 7ab80c7f 
c01bc060
1e80: 00000002 ef001b80 c0a695d0 024000c0 00008000 ee471ec0 00008000 
edfe1080
1ea0: ee4abd00 00000001 00000001 ee471f80 00000000 c01fe564 0001c000 
edfe10b0
1ec0: 00000000 00000000 00024e84 ee5b7e00 ee5b7e44 c0705348 0001c000 
ee4abd00
1ee0: ee471f80 00008000 ee470000 0001c000 00000000 c01dc850 c0b06aac 
ee471fb0
1f00: b6fbf220 b6fbf7c4 000001ff c0101308 386d6a0e 32e4d737 386d6a0e 
32e4d737
1f20: 00002838 00000000 ee4abd00 bec0eba0 00000000 bec0ed84 ee596e00 
00000000
1f40: ee4abd00 00008000 0001c000 00000000 ee471f80 c01ddca0 00000004 
ee478124
1f60: 00000001 00000000 00000000 ee4abd00 ee4abd00 00008000 0001c000 
c01ddd64
1f80: 00000000 00000000 00000000 00008000 0001c000 00000003 00000003 
c0107ac4
1fa0: 00000000 c0107900 00008000 0001c000 00000003 0001c000 00008000 
0001c000
1fc0: 00008000 0001c000 00000003 00000003 00008000 00000000 0000005e 
00000000
1fe0: 00000000 bec0eb0c 0000c694 b6f4248c 60000010 00000003 fdfffffb 
ffffffff
[<c06c01f4>] (down_read) from [<c022a154>] (totmaps_proc_show+0x2c/0x1e8)
[<c022a154>] (totmaps_proc_show) from [<c01fe564>] (seq_read+0x1c8/0x4b8)
[<c01fe564>] (seq_read) from [<c01dc850>] (__vfs_read+0x2c/0x110)
[<c01dc850>] (__vfs_read) from [<c01ddca0>] (vfs_read+0x8c/0x110)
[<c01ddca0>] (vfs_read) from [<c01ddd64>] (SyS_read+0x40/0x8c)
[<c01ddd64>] (SyS_read) from [<c0107900>] (ret_fast_syscall+0x0/0x3c)

It seems that some protection is needed for such processes, so that
totmaps would return empty string then, like in case of smaps.

-- 
Best regards,
Jacek Anaszewski
