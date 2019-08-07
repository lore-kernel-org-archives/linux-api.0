From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v4 1/5] mm/page_idle: Add per-pid idle page tracking
 using virtual indexing
Date: Wed, 7 Aug 2019 06:00:13 -0400
Message-ID: <20190807100013.GC169551@google.com>
References: <20190805170451.26009-1-joel@joelfernandes.org>
 <20190806151921.edec128271caccb5214fc1bd@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190806151921.edec128271caccb5214fc1bd@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.ibm.com>, minchan@kernel.org, namhyung@google.com, paulmck@linux.ibm.com, Robin Murphy <robin.murphy@arm.com>, Roman Gushchin <guro@fb.com>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2019 at 03:19:21PM -0700, Andrew Morton wrote:
> (cc Brendan's other email address, hoping for review input ;))

;)

> On Mon,  5 Aug 2019 13:04:47 -0400 "Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:
> 
> > The page_idle tracking feature currently requires looking up the pagemap
> > for a process followed by interacting with /sys/kernel/mm/page_idle.
> > Looking up PFN from pagemap in Android devices is not supported by
> > unprivileged process and requires SYS_ADMIN and gives 0 for the PFN.
> > 
> > This patch adds support to directly interact with page_idle tracking at
> > the PID level by introducing a /proc/<pid>/page_idle file.  It follows
> > the exact same semantics as the global /sys/kernel/mm/page_idle, but now
> > looking up PFN through pagemap is not needed since the interface uses
> > virtual frame numbers, and at the same time also does not require
> > SYS_ADMIN.
> > 
> > In Android, we are using this for the heap profiler (heapprofd) which
> > profiles and pin points code paths which allocates and leaves memory
> > idle for long periods of time. This method solves the security issue
> > with userspace learning the PFN, and while at it is also shown to yield
> > better results than the pagemap lookup, the theory being that the window
> > where the address space can change is reduced by eliminating the
> > intermediate pagemap look up stage. In virtual address indexing, the
> > process's mmap_sem is held for the duration of the access.
> 
> Quite a lot of changes to the page_idle code.  Has this all been
> runtime tested on architectures where
> CONFIG_HAVE_ARCH_PTE_SWP_PGIDLE=n?  That could be x86 with a little
> Kconfig fiddle-for-testing-purposes.

I will do this Kconfig fiddle test with CONFIG_HAVE_ARCH_PTE_SWP_PGIDLE=n and test
the patch as well.

In previous series, this flag was not there (which should have been
equivalent to the above test), and things are working fine.

> > 8 files changed, 376 insertions(+), 45 deletions(-)
> 
> Quite a lot of new code unconditionally added to major architectures. 
> Are we confident that everyone will want this feature?

I did not follow, could you clarify more? All of this diff stat is not to
architecture code:

 arch/Kconfig                  |   3 ++
 fs/proc/base.c                |   3 ++
 fs/proc/internal.h            |   1 +
 fs/proc/task_mmu.c            |  43 +++++++++++++++++++++
 include/asm-generic/pgtable.h |   6 +++
 include/linux/page_idle.h     |   4 ++
 mm/page_idle.c                | 359 +++++++++++++++++++++++++++++..
 mm/rmap.c                     |   2 +
 8 files changed, 376 insertions(+), 45 deletions(-)

The arcitecture change is in a later patch, and is not that many lines.

Also, I am planning to split the swap functionality of the patch into a
separate one for easier review.

> > +static int proc_page_idle_open(struct inode *inode, struct file *file)
> > +{
> > +	struct mm_struct *mm;
> > +
> > +	mm = proc_mem_open(inode, PTRACE_MODE_READ);
> > +	if (IS_ERR(mm))
> > +		return PTR_ERR(mm);
> > +	file->private_data = mm;
> > +	return 0;
> > +}
> > +
> > +static int proc_page_idle_release(struct inode *inode, struct file *file)
> > +{
> > +	struct mm_struct *mm = file->private_data;
> > +
> > +	if (mm)
> 
> I suspect the test isn't needed?  proc_page_idle_release) won't be
> called if proc_page_idle_open() failed?

Yes you are right, will remove the test.

thanks,

 - Joel
