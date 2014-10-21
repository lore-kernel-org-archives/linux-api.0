From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Tue, 21 Oct 2014 12:36:22 +0200
Message-ID: <20141021103622.GB23161@amd>
References: <20141016124741.GA3832@kroah.com>
 <CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
 <20141016231221.GA13592@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141016231221.GA13592-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-l0cyMroinI0@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rebecca Schultz Zavin <rebecca-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anup Patel <anup.patel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 2014-10-17 01:12:21, Greg Kroah-Hartman wrote:
> On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
> > On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
> > <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > > From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

> > Are the Android guys comfortable with the ABI stability rules they'll
> > now face?
> 
> Just because something is in staging, doesn't mean you don't have to
> follow the same ABI stability rules as the rest of the kernel.  If a
> change had happened to this code that broke userspace in the past, I
> would have reverted it.  So this should not be anything different from
> what has been happening inthe past.

Actually, there's big difference.

If Al Viro changes core filesystem in a way that breaks
staging/binder, binder is broken, and if it can't be fixed... well it
can't be fixed.

If Al Viro changes core filesystem in a way that breaks
drivers/binder, Al's change is going to be reverted.

It is really hard to review without API documentation. Normally, API
documentation is required for stuff like this.

For example: does it add new files in /proc?

Given that it is stable, can we get rid of binder_debug() and
especially BINDER_DEBUG_ENTRY stuff?

Checkpatch warns about 98 too long lines. Some of them could be fixed
easily.

This looks scary:

                        trace_binder_transaction_fd(t, fp->handle,
                        target_fd);
			                binder_debug(BINDER_DEBUG_TRANSACTION,
                                     "        fd %d -> %d\n",
                        fp->handle, target_fd);
                        /* TODO: fput? */
                        fp->handle = target_fd;
			        } break;

Could binder_transcation() be split to smaller functions according to
CodingStyle? 17 goto targets at the end of function are not exactly
easy to read.

ginder_thread_read/write also needs splitting.

binder_ioctl_write_read: just use direct return, no need to goto out
if it just returns.

   proc->user_buffer_offset = vma->vm_start - (uintptr_t)proc->buffer;
        mutex_unlock(&binder_mmap_lock);

#ifdef CONFIG_CPU_CACHE_VIPT
        if (cache_is_vipt_aliasing()) {
                while (CACHE_COLOUR((vma->vm_start ^
        (uint32_t)proc->buffer))) {

Should this be (uintptr_t)?

        /*pr_info("binder_mmap: %d %lx-%lx maps %p\n",                                   

Delete the code, don't comment it out. It is on more than one place.

static void print_binder_thread(struct seq_file *m,
                                struct binder_thread *thread,
                                int print_always)
{
        struct binder_transaction *t;
	struct binder_work *w;
        size_t start_pos = m->count;
	size_t header_pos;

        seq_printf(m, "  thread %d: l %02x\n", thread->pid,
        thread->looper);
        header_pos = m->count;
        t = thread->transaction_stack;
	while (t) {
 	        if (t->from == thread) {
                        print_binder_transaction(m,
				                                 "
        outgoing transaction", t);
                        t = t->from_parent;

Is anyone depending on the debugfs files? Can it be deleted?

Code indentation is "interesting" in binder_thread_read(). See the "}
break;" lines. {}s should not be needed...?

I don't think this code would get merged if it was submitted for
normal inclusion in kernel. I don't think it is good idea to push it
through the back door, without documenting what it does and without
patches even going to the lists.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
