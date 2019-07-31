From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v3 1/2] mm/page_idle: Add per-pid idle page tracking
 using virtual indexing
Date: Wed, 31 Jul 2019 13:19:37 -0400
Message-ID: <20190731171937.GA75376@google.com>
References: <20190726152319.134152-1-joel@joelfernandes.org>
 <20190731085335.GD155569@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190731085335.GD155569@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Brendan Gregg <bgregg@netflix.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, joaodias@google.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.ibm.com>, namhyung@google.com, Roman Gushchin <guro@fb.com>, Stephen Rothwell <sfr@canb.auug.org.au>, surenb@google.com, tkjos@google.com, Vladimir Davydov <vdavydov.dev@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, wvw@google.com
List-Id: linux-api@vger.kernel.org

On Wed, Jul 31, 2019 at 05:53:35PM +0900, Minchan Kim wrote:
> Hi Joel,
> 
> On Fri, Jul 26, 2019 at 11:23:18AM -0400, Joel Fernandes (Google) wrote:
> > The page_idle tracking feature currently requires looking up the pagemap
> > for a process followed by interacting with /sys/kernel/mm/page_idle.
> > Looking up PFN from pagemap in Android devices is not supported by
> > unprivileged process and requires SYS_ADMIN and gives 0 for the PFN.
> > 
[snip]
> > index 77eb628ecc7f..a58dd74606e9 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -3021,6 +3021,9 @@ static const struct pid_entry tgid_base_stuff[] = {
> >  	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
> >  	REG("smaps_rollup", S_IRUGO, proc_pid_smaps_rollup_operations),
> >  	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
> > +#ifdef CONFIG_IDLE_PAGE_TRACKING
> > +	REG("page_idle", S_IRUSR|S_IWUSR, proc_page_idle_operations),
> > +#endif
> >  #endif
> >  #ifdef CONFIG_SECURITY
> >  	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> > diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> > index cd0c8d5ce9a1..bc9371880c63 100644
> > --- a/fs/proc/internal.h
> > +++ b/fs/proc/internal.h
> > @@ -293,6 +293,7 @@ extern const struct file_operations proc_pid_smaps_operations;
> >  extern const struct file_operations proc_pid_smaps_rollup_operations;
> >  extern const struct file_operations proc_clear_refs_operations;
> >  extern const struct file_operations proc_pagemap_operations;
> > +extern const struct file_operations proc_page_idle_operations;
> >  
> >  extern unsigned long task_vsize(struct mm_struct *);
> >  extern unsigned long task_statm(struct mm_struct *,
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 4d2b860dbc3f..11ccc53da38e 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1642,6 +1642,63 @@ const struct file_operations proc_pagemap_operations = {
> >  	.open		= pagemap_open,
> >  	.release	= pagemap_release,
> >  };
> > +
> > +#ifdef CONFIG_IDLE_PAGE_TRACKING
> > +static ssize_t proc_page_idle_read(struct file *file, char __user *buf,
> > +				   size_t count, loff_t *ppos)
> > +{
> > +	int ret;
> > +	struct task_struct *tsk = get_proc_task(file_inode(file));
> > +
> > +	if (!tsk)
> > +		return -EINVAL;
> > +	ret = page_idle_proc_read(file, buf, count, ppos, tsk);
> > +	put_task_struct(tsk);
> 
> Why do you need task_struct here? You already got the task in open
> and got mm there so you could pass the MM here instead of task.

Good point, will just use mm.

[snip]
> > diff --git a/include/linux/page_idle.h b/include/linux/page_idle.h
> > index 1e894d34bdce..f1bc2640d85e 100644
> > --- a/include/linux/page_idle.h
> > +++ b/include/linux/page_idle.h
> > @@ -106,6 +106,10 @@ static inline void clear_page_idle(struct page *page)
> >  }
> >  #endif /* CONFIG_64BIT */
> >  
> > +ssize_t page_idle_proc_write(struct file *file,
> > +	char __user *buf, size_t count, loff_t *ppos, struct task_struct *tsk);
> > +ssize_t page_idle_proc_read(struct file *file,
> > +	char __user *buf, size_t count, loff_t *ppos, struct task_struct *tsk);
> >  #else /* !CONFIG_IDLE_PAGE_TRACKING */
> >  
> >  static inline bool page_is_young(struct page *page)
> > diff --git a/mm/page_idle.c b/mm/page_idle.c
> > index 295512465065..86244f7f1faa 100644
> > --- a/mm/page_idle.c
> > +++ b/mm/page_idle.c
> > @@ -5,12 +5,15 @@
> >  #include <linux/sysfs.h>
> >  #include <linux/kobject.h>
> >  #include <linux/mm.h>
> > -#include <linux/mmzone.h>
> > -#include <linux/pagemap.h>
> > -#include <linux/rmap.h>
> >  #include <linux/mmu_notifier.h>
> > +#include <linux/mmzone.h>
> >  #include <linux/page_ext.h>
> >  #include <linux/page_idle.h>
> > +#include <linux/pagemap.h>
> > +#include <linux/rmap.h>
> > +#include <linux/sched/mm.h>
> > +#include <linux/swap.h>
> > +#include <linux/swapops.h>
> >  
> >  #define BITMAP_CHUNK_SIZE	sizeof(u64)
> >  #define BITMAP_CHUNK_BITS	(BITMAP_CHUNK_SIZE * BITS_PER_BYTE)
> > @@ -25,18 +28,13 @@
> >   * page tracking. With such an indicator of user pages we can skip isolated
> >   * pages, but since there are not usually many of them, it will hardly affect
> >   * the overall result.
> > - *
> > - * This function tries to get a user memory page by pfn as described above.
> >   */
> > -static struct page *page_idle_get_page(unsigned long pfn)
> > +static struct page *page_idle_get_page(struct page *page_in)
> 
> Looks weird function name after you changed the argument.
> Maybe "bool check_valid_page(struct page *page)"?


I don't think so, this function does a get_page_unless_zero() on the page as well.

> >  {
> >  	struct page *page;
> >  	pg_data_t *pgdat;
> >  
> > -	if (!pfn_valid(pfn))
> > -		return NULL;
> > -
> > -	page = pfn_to_page(pfn);
> > +	page = page_in;
> >  	if (!page || !PageLRU(page) ||
> >  	    !get_page_unless_zero(page))
> >  		return NULL;
> > @@ -51,6 +49,18 @@ static struct page *page_idle_get_page(unsigned long pfn)
> >  	return page;
> >  }
> >  
> > +/*
> > + * This function tries to get a user memory page by pfn as described above.
> > + */
> > +static struct page *page_idle_get_page_pfn(unsigned long pfn)
> 
> So we could use page_idle_get_page name here.


Based on above comment, I prefer to keep same name. Do you agree?


> > +	return page_idle_get_page(pfn_to_page(pfn));
> > +}
> > +
> >  static bool page_idle_clear_pte_refs_one(struct page *page,
> >  					struct vm_area_struct *vma,
> >  					unsigned long addr, void *arg)
> > @@ -118,6 +128,47 @@ static void page_idle_clear_pte_refs(struct page *page)
> >  		unlock_page(page);
> >  }
> >  
> > +/* Helper to get the start and end frame given a pos and count */
> > +static int page_idle_get_frames(loff_t pos, size_t count, struct mm_struct *mm,
> > +				unsigned long *start, unsigned long *end)
> > +{
> > +	unsigned long max_frame;
> > +
> > +	/* If an mm is not given, assume we want physical frames */
> > +	max_frame = mm ? (mm->task_size >> PAGE_SHIFT) : max_pfn;
> > +
> > +	if (pos % BITMAP_CHUNK_SIZE || count % BITMAP_CHUNK_SIZE)
> > +		return -EINVAL;
> > +
> > +	*start = pos * BITS_PER_BYTE;
> > +	if (*start >= max_frame)
> > +		return -ENXIO;
> > +
> > +	*end = *start + count * BITS_PER_BYTE;
> > +	if (*end > max_frame)
> > +		*end = max_frame;
> > +	return 0;
> > +}
> > +
> > +static bool page_really_idle(struct page *page)
> 
> Just minor:
> Instead of creating new API, could we combine page_is_idle with
> introducing furthere argument pte_check?


I cannot see in the code where pte_check will be false when this is called? I
could rename the function to page_idle_check_ptes() if that's Ok with you.

[snip]
> +
> > +static int pte_page_idle_proc_range(pmd_t *pmd, unsigned long addr,
> > +				    unsigned long end,
> > +				    struct mm_walk *walk)
> > +{
> > +	struct vm_area_struct *vma = walk->vma;
> > +	pte_t *pte;
> > +	spinlock_t *ptl;
> > +	struct page *page;
> > +
> > +	ptl = pmd_trans_huge_lock(pmd, vma);
> > +	if (ptl) {
> > +		if (pmd_present(*pmd)) {
> > +			page = follow_trans_huge_pmd(vma, addr, pmd,
> > +						     FOLL_DUMP|FOLL_WRITE);
> > +			if (!IS_ERR_OR_NULL(page))
> > +				add_page_idle_list(page, addr, walk);
> > +		}
> > +		spin_unlock(ptl);
> > +		return 0;
> > +	}
> > +
> > +	if (pmd_trans_unstable(pmd))
> > +		return 0;
> > +
> > +	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > +	for (; addr != end; pte++, addr += PAGE_SIZE) {
> > +		/*
> > +		 * We add swapped pages to the idle_page_list so that we can
> > +		 * reported to userspace that they are idle.
> > +		 */
> > +		if (is_swap_pte(*pte)) {
> 
> I suggested "let's consider every swapped out pages as IDLE" but
> let's think about this case:
> 
> 1. mark heap of the process as IDLE
> 2. process touch working set
> 3. process's heap pages are swap out by meory spike or madvise
> 4. heap profiler investigates the process's IDLE page and surprised all of
> heap are idle.
> 
> It's the good scenario for other purpose because non-idle pages(IOW,
> workingset) could be readahead when the app will restart.
> 
> Maybe, squeeze the idle bit in the swap pte to check it.


Ok, I will look more into this. Konstantin had similar ideas here too.


> > +ssize_t page_idle_proc_generic(struct file *file, char __user *ubuff,
> > +			       size_t count, loff_t *pos,
> > +			       struct task_struct *tsk, int write)
> > +{
> > +	int ret;
> > +	char *buffer;
> > +	u64 *out;
> > +	unsigned long start_addr, end_addr, start_frame, end_frame;
> > +	struct mm_struct *mm = file->private_data;
> > +	struct mm_walk walk = { .pmd_entry = pte_page_idle_proc_range, };
> > +	struct page_node *cur;
> > +	struct page_idle_proc_priv priv;
> > +	bool walk_error = false;
> > +	LIST_HEAD(idle_page_list);
> > +
> > +	if (!mm || !mmget_not_zero(mm))
> > +		return -EINVAL;
> > +
> > +	if (count > PAGE_SIZE)
> > +		count = PAGE_SIZE;
> > +
> > +	buffer = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +	if (!buffer) {
> > +		ret = -ENOMEM;
> > +		goto out_mmput;
> > +	}
> > +	out = (u64 *)buffer;
> > +
> > +	if (write && copy_from_user(buffer, ubuff, count)) {
> > +		ret = -EFAULT;
> > +		goto out;
> > +	}
> > +
> > +	ret = page_idle_get_frames(*pos, count, mm, &start_frame, &end_frame);
> > +	if (ret)
> > +		goto out;
> > +
> > +	start_addr = (start_frame << PAGE_SHIFT);
> > +	end_addr = (end_frame << PAGE_SHIFT);
> > +	priv.buffer = buffer;
> > +	priv.start_addr = start_addr;
> > +	priv.write = write;
> > +
> > +	priv.idle_page_list = &idle_page_list;
> > +	priv.cur_page_node = 0;
> > +	priv.page_nodes = kzalloc(sizeof(struct page_node) *
> > +				  (end_frame - start_frame), GFP_KERNEL);
> > +	if (!priv.page_nodes) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	walk.private = &priv;
> > +	walk.mm = mm;
> > +
> > +	down_read(&mm->mmap_sem);
> > +
> > +	/*
> > +	 * idle_page_list is needed because walk_page_vma() holds ptlock which
> > +	 * deadlocks with page_idle_clear_pte_refs(). So we have to collect all
> > +	 * pages first, and then call page_idle_clear_pte_refs().
> > +	 */
> 
> Thanks for the comment, I was curious why you want to have
> idle_page_list and the reason is here.
> 
> How about making this /proc/<pid>/page_idle per-process granuariy,
> unlike system level /sys/xxx/page_idle? What I meant is not to check
> rmap to see any reference from random process but just check only
> access from the target process. It would be more proper as /proc/
> <pid>/ interface and good for per-process tracking as well as
> fast.


I prefer not to do this for the following reasons:
(1) It makes a feature lost, now accesses to shared pages will not be
accounted properly. 

(2) It makes it inconsistent with other idle page tracking mechanism. I
prefer if post per-process. At the heart of it, the tracking is always at the
physical page level -- I feel that is how it should be. Other drawback, is
also we have to document this subtlety.

Another reason is the performance is pretty good already with this mechanism
with rmap. I did idle tracking on 512MB range in about 15ms for read and 15ms
for write.

In the future if it is an issue, we can consider it.

thanks,

 - Joel
