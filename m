From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v3 1/2] mm/page_idle: Add per-pid idle page tracking
 using virtual indexing
Date: Mon, 5 Aug 2019 09:10:52 -0400
Message-ID: <20190805131052.GA208558@google.com>
References: <20190726152319.134152-1-joel@joelfernandes.org>
 <20190731085335.GD155569@google.com>
 <20190731171937.GA75376@google.com>
 <20190805075547.GA196934@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190805075547.GA196934@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Brendan Gregg <bgregg@netflix.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, joaodias@google.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.ibm.com>, namhyung@google.com, Roman Gushchin <guro@fb.com>, Stephen Rothwell <sfr@canb.auug.org.au>, surenb@google.com, tkjos@google.com, Vladimir Davydov <vdavydov.dev@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, wvw@google.com
List-Id: linux-api@vger.kernel.org

On Mon, Aug 05, 2019 at 04:55:47PM +0900, Minchan Kim wrote:
> Hi Joel,

Hi Minchan,

> On Wed, Jul 31, 2019 at 01:19:37PM -0400, Joel Fernandes wrote:
> > > > -static struct page *page_idle_get_page(unsigned long pfn)
> > > > +static struct page *page_idle_get_page(struct page *page_in)
> > > 
> > > Looks weird function name after you changed the argument.
> > > Maybe "bool check_valid_page(struct page *page)"?
> > 
> > 
> > I don't think so, this function does a get_page_unless_zero() on the page as well.
> > 
> > > >  {
> > > >  	struct page *page;
> > > >  	pg_data_t *pgdat;
> > > >  
> > > > -	if (!pfn_valid(pfn))
> > > > -		return NULL;
> > > > -
> > > > -	page = pfn_to_page(pfn);
> > > > +	page = page_in;
> > > >  	if (!page || !PageLRU(page) ||
> > > >  	    !get_page_unless_zero(page))
> > > >  		return NULL;
> > > > @@ -51,6 +49,18 @@ static struct page *page_idle_get_page(unsigned long pfn)
> > > >  	return page;
> > > >  }
> > > >  
> > > > +/*
> > > > + * This function tries to get a user memory page by pfn as described above.
> > > > + */
> > > > +static struct page *page_idle_get_page_pfn(unsigned long pfn)
> > > 
> > > So we could use page_idle_get_page name here.
> > 
> > 
> > Based on above comment, I prefer to keep same name. Do you agree?
> 
> Yes, I agree. Just please add a comment about refcount in the description
> on page_idle_get_page.

Ok.


> > > > +	return page_idle_get_page(pfn_to_page(pfn));
> > > > +}
> > > > +
> > > >  static bool page_idle_clear_pte_refs_one(struct page *page,
> > > >  					struct vm_area_struct *vma,
> > > >  					unsigned long addr, void *arg)
> > > > @@ -118,6 +128,47 @@ static void page_idle_clear_pte_refs(struct page *page)
> > > >  		unlock_page(page);
> > > >  }
> > > >  
> > > > +/* Helper to get the start and end frame given a pos and count */
> > > > +static int page_idle_get_frames(loff_t pos, size_t count, struct mm_struct *mm,
> > > > +				unsigned long *start, unsigned long *end)
> > > > +{
> > > > +	unsigned long max_frame;
> > > > +
> > > > +	/* If an mm is not given, assume we want physical frames */
> > > > +	max_frame = mm ? (mm->task_size >> PAGE_SHIFT) : max_pfn;
> > > > +
> > > > +	if (pos % BITMAP_CHUNK_SIZE || count % BITMAP_CHUNK_SIZE)
> > > > +		return -EINVAL;
> > > > +
> > > > +	*start = pos * BITS_PER_BYTE;
> > > > +	if (*start >= max_frame)
> > > > +		return -ENXIO;
> > > > +
> > > > +	*end = *start + count * BITS_PER_BYTE;
> > > > +	if (*end > max_frame)
> > > > +		*end = max_frame;
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static bool page_really_idle(struct page *page)
> > > 
> > > Just minor:
> > > Instead of creating new API, could we combine page_is_idle with
> > > introducing furthere argument pte_check?
> > 
> > 
> > I cannot see in the code where pte_check will be false when this is called? I
> > could rename the function to page_idle_check_ptes() if that's Ok with you.
> 
> What I don't like is _*really*_ part of the funcion name.
> 
> I see several page_is_idle calls in huge_memory.c, migration.c, swap.c.
> They could just check only page flag so they could use "false" with pte_check.

I will rename it to page_idle_check_ptes(). If you want pte_check argument,
that can be a later patch if/when there are other users for it in other
files. Hope that's reasonable.


> > > > +ssize_t page_idle_proc_generic(struct file *file, char __user *ubuff,
> > > > +			       size_t count, loff_t *pos,
> > > > +			       struct task_struct *tsk, int write)
> > > > +{
> > > > +	int ret;
> > > > +	char *buffer;
> > > > +	u64 *out;
> > > > +	unsigned long start_addr, end_addr, start_frame, end_frame;
> > > > +	struct mm_struct *mm = file->private_data;
> > > > +	struct mm_walk walk = { .pmd_entry = pte_page_idle_proc_range, };
> > > > +	struct page_node *cur;
> > > > +	struct page_idle_proc_priv priv;
> > > > +	bool walk_error = false;
> > > > +	LIST_HEAD(idle_page_list);
> > > > +
> > > > +	if (!mm || !mmget_not_zero(mm))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (count > PAGE_SIZE)
> > > > +		count = PAGE_SIZE;
> > > > +
> > > > +	buffer = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > > > +	if (!buffer) {
> > > > +		ret = -ENOMEM;
> > > > +		goto out_mmput;
> > > > +	}
> > > > +	out = (u64 *)buffer;
> > > > +
> > > > +	if (write && copy_from_user(buffer, ubuff, count)) {
> > > > +		ret = -EFAULT;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	ret = page_idle_get_frames(*pos, count, mm, &start_frame, &end_frame);
> > > > +	if (ret)
> > > > +		goto out;
> > > > +
> > > > +	start_addr = (start_frame << PAGE_SHIFT);
> > > > +	end_addr = (end_frame << PAGE_SHIFT);
> > > > +	priv.buffer = buffer;
> > > > +	priv.start_addr = start_addr;
> > > > +	priv.write = write;
> > > > +
> > > > +	priv.idle_page_list = &idle_page_list;
> > > > +	priv.cur_page_node = 0;
> > > > +	priv.page_nodes = kzalloc(sizeof(struct page_node) *
> > > > +				  (end_frame - start_frame), GFP_KERNEL);
> > > > +	if (!priv.page_nodes) {
> > > > +		ret = -ENOMEM;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	walk.private = &priv;
> > > > +	walk.mm = mm;
> > > > +
> > > > +	down_read(&mm->mmap_sem);
> > > > +
> > > > +	/*
> > > > +	 * idle_page_list is needed because walk_page_vma() holds ptlock which
> > > > +	 * deadlocks with page_idle_clear_pte_refs(). So we have to collect all
> > > > +	 * pages first, and then call page_idle_clear_pte_refs().
> > > > +	 */
> > > 
> > > Thanks for the comment, I was curious why you want to have
> > > idle_page_list and the reason is here.
> > > 
> > > How about making this /proc/<pid>/page_idle per-process granuariy,
> > > unlike system level /sys/xxx/page_idle? What I meant is not to check
> > > rmap to see any reference from random process but just check only
> > > access from the target process. It would be more proper as /proc/
> > > <pid>/ interface and good for per-process tracking as well as
> > > fast.
> > 
> > 
> > I prefer not to do this for the following reasons:
> > (1) It makes a feature lost, now accesses to shared pages will not be
> > accounted properly. 
> 
> Do you really want to check global attribute by per-process interface?

Pages are inherrently not per-process, they are global. A page does not
necessarily belong to a process. An anonymous page can be shared. We are
operating on pages in the end of the day.

I think you are confusing the per-process file interface with the core
mechanism. The core mechanism always operations on physical PAGES.


> That would be doable with existing idle page tracking feature and that's
> the one of reasons page idle tracking was born(e.g. even, page cache
> for non-mapped) unlike clear_refs.

I think you are misunderstanding the patch, the patch does not want to change
the core mechanism. That is a bit out of scope for the patch. Page
idle-tracking at the core of it looks at PTE of all processes. We are just
using the VFN (virtual frame) interface to skip the need for separate pagemap
look up -- that's it.


> Once we create a new interface by per-process, just checking the process
> -granuariy access check sounds more reasonable to me.

It sounds reasonable but there is no reason to not do the full and proper
page tracking for now, including shared pages. Otherwise it makes it
inconsistent with the existing mechanism and can confuse the user about what
to expect (especially for shared pages).


> With that, we could catch only idle pages of the target process even though
> the page was touched by several other processes.
> If the user want to know global level access point, they could use
> exisint interface(If there is a concern(e.g., security) to use existing
> idle page tracking, let's discuss it as other topic how we could make
> existing feature more useful).
> 
> IOW, my point is that we already have global access check(1. from ptes
> among several processes, 2. from page flag for non-mapped pages) feature
> from from existing idle page tracking interface and now we are about to create
> new interface for per-process wise so I wanted to create a particular
> feature which cannot be covered by existing iterface.

Yes, it sounds like you want to create a different feature. Then that can be
a follow-up different patch, and that is out of scope for this patch.


> > (2) It makes it inconsistent with other idle page tracking mechanism. I
> 
> That's the my comment to create different idle page tracking we couldn't
> do with existing interface.

Yes, sure. But that can be a different patch and we can weigh the benefits of
it at that time. I don't want to introduce a new page tracking mechanism, I
am just trying to reuse the existing one.


> > prefer if post per-process. At the heart of it, the tracking is always at the
> 
> What does it mean "post per-process"?

Sorry it was a typo, I meant "the core mechanism should not be a per-process
one, but a global one". We are just changing the interface in this patch, we
are not changing the existing core mechanism. That gives us all the benefits
of the existing code such as non-interference with page reclaim code, without
introducing any new bugs. By the way I did fix a bug in the existing original
code as well!


> > physical page level -- I feel that is how it should be. Other drawback, is
> > also we have to document this subtlety.
> 
> Sorry, Could you elaborate it a bit?

I meant, with a new mechanism as the one you are proposing, we have to
document that now shared pages will not be tracked properly. That is a
'subtle difference' and will have to be documented appropriated in the
'internals' section of the idle page tracking document.

thanks,

 - Joel
