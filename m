From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCHv2 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Wed, 13 May 2015 16:25:07 -0700
Message-ID: <20150513232507.GA22262@cloud>
References: <20150511192918.GA11361@jtriplet-mobl1>
 <20150513155628.65dc253bea9485cb7910678b@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513155628.65dc253bea9485cb7910678b-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 03:56:28PM -0700, Andrew Morton wrote:
> On Mon, 11 May 2015 12:29:19 -0700 Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> 
> > clone with CLONE_SETTLS accepts an argument to set the thread-local
> > storage area for the new thread.  sys_clone declares an int argument
> > tls_val in the appropriate point in the argument list (based on the
> > various CLONE_BACKWARDS variants), but doesn't actually use or pass
> > along that argument.  Instead, sys_clone calls do_fork, which calls
> > copy_process, which calls the arch-specific copy_thread, and copy_thread
> > pulls the corresponding syscall argument out of the pt_regs captured at
> > kernel entry (knowing what argument of clone that architecture passes
> > tls in).
> > 
> > Apart from being awful and inscrutable, that also only works because
> > only one code path into copy_thread can pass the CLONE_SETTLS flag, and
> > that code path comes from sys_clone with its architecture-specific
> > argument-passing order.  This prevents introducing a new version of the
> > clone system call without propagating the same architecture-specific
> > position of the tls argument.
> > 
> > However, there's no reason to pull the argument out of pt_regs when
> > sys_clone could just pass it down via C function call arguments.
> > 
> > Introduce a new CONFIG_HAVE_COPY_THREAD_TLS for architectures to opt
> > into, and a new copy_thread_tls that accepts the tls parameter as an
> > additional unsigned long (syscall-argument-sized) argument.
> > Change sys_clone's tls argument to an unsigned long (which does
> > not change the ABI), and pass that down to copy_thread_tls.
> > 
> > Architectures that don't opt into copy_thread_tls will continue to
> > ignore the C argument to sys_clone in favor of the pt_regs captured at
> > kernel entry, and thus will be unable to introduce new versions of the
> > clone syscall.
> > 
> > Patch co-authored by Josh Triplett and Thiago Macieira.
> > 
> > ...
> >
> > @@ -1698,20 +1701,34 @@ long do_fork(unsigned long clone_flags,
> >  	return nr;
> >  }
> >  
> > +#ifndef CONFIG_HAVE_COPY_THREAD_TLS
> > +/* For compatibility with architectures that call do_fork directly rather than
> > + * using the syscall entry points below. */
> > +long do_fork(unsigned long clone_flags,
> > +	      unsigned long stack_start,
> > +	      unsigned long stack_size,
> > +	      int __user *parent_tidptr,
> > +	      int __user *child_tidptr)
> > +{
> > +	return _do_fork(clone_flags, stack_start, stack_size,
> > +			parent_tidptr, child_tidptr, 0);
> > +}
> > +#endif
> 
> drivers/misc/kgdbts.c:lookup_addr() has a reference to do_fork(). 
> Doesn't link, with a basic `make allmodconfig'.

Odd; not sure how it built with allyesconfig at the time (which I did
test).

However, dropping the #ifndef is the wrong fix.  do_fork will go away
*completely* once all architectures opt into
CONFIG_HAVE_COPY_THREAD_TLS, and architectures that opt in won't pass
through do_fork.  kgdb wants to capture forks, so it wants _do_fork.
The right fix is to make _do_fork non-static (which makes me sad, but oh
well), and make kgdb reference _do_fork instead of do_fork (though the
string should remain "do_fork" for compatibility):

Here's an incremental patch for that, to be squashed into the first of
the two patches per your standard procedure for -mm; does this fix the
issue you observed?

--- 8< ---
>From fd599319630b33b829dc50b4f3c88016e715cd76 Mon Sep 17 00:00:00 2001
From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Date: Wed, 13 May 2015 08:18:47 -0700
Subject: [PATCH] Fix "clone: Support passing tls argument via C rather than pt_regs magic" for kgdb

Should be squashed into "clone: Support passing tls argument via C
rather than pt_regs magic". kgdb wants to reference the real fork
function, which is now _do_fork.

Reported-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
---
 drivers/misc/kgdbts.c |  2 +-
 include/linux/sched.h |  1 +
 kernel/fork.c         | 13 ++++++-------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 36f5d52..9a60bd4 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -220,7 +220,7 @@ static unsigned long lookup_addr(char *arg)
 	else if (!strcmp(arg, "sys_open"))
 		addr = (unsigned long)do_sys_open;
 	else if (!strcmp(arg, "do_fork"))
-		addr = (unsigned long)do_fork;
+		addr = (unsigned long)_do_fork;
 	else if (!strcmp(arg, "hw_break_val"))
 		addr = (unsigned long)&hw_break_val;
 	addr = (unsigned long) dereference_function_descriptor((void *)addr);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2cc88c6..9686abe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2514,6 +2514,7 @@ extern int do_execveat(int, struct filename *,
 		       const char __user * const __user *,
 		       const char __user * const __user *,
 		       int);
+extern long _do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *, unsigned long);
 extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
diff --git a/kernel/fork.c b/kernel/fork.c
index b3dadf4..b493aba 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1629,13 +1629,12 @@ struct task_struct *fork_idle(int cpu)
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
  */
-static long _do_fork(
-		unsigned long clone_flags,
-		unsigned long stack_start,
-		unsigned long stack_size,
-		int __user *parent_tidptr,
-		int __user *child_tidptr,
-		unsigned long tls)
+long _do_fork(unsigned long clone_flags,
+	      unsigned long stack_start,
+	      unsigned long stack_size,
+	      int __user *parent_tidptr,
+	      int __user *child_tidptr,
+	      unsigned long tls)
 {
 	struct task_struct *p;
 	int trace = 0;
-- 
2.1.4
