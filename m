From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCHv2 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Wed, 13 May 2015 15:56:28 -0700
Message-ID: <20150513155628.65dc253bea9485cb7910678b@linux-foundation.org>
References: <20150511192918.GA11361@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511192918.GA11361@jtriplet-mobl1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 11 May 2015 12:29:19 -0700 Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:

> clone with CLONE_SETTLS accepts an argument to set the thread-local
> storage area for the new thread.  sys_clone declares an int argument
> tls_val in the appropriate point in the argument list (based on the
> various CLONE_BACKWARDS variants), but doesn't actually use or pass
> along that argument.  Instead, sys_clone calls do_fork, which calls
> copy_process, which calls the arch-specific copy_thread, and copy_thread
> pulls the corresponding syscall argument out of the pt_regs captured at
> kernel entry (knowing what argument of clone that architecture passes
> tls in).
> 
> Apart from being awful and inscrutable, that also only works because
> only one code path into copy_thread can pass the CLONE_SETTLS flag, and
> that code path comes from sys_clone with its architecture-specific
> argument-passing order.  This prevents introducing a new version of the
> clone system call without propagating the same architecture-specific
> position of the tls argument.
> 
> However, there's no reason to pull the argument out of pt_regs when
> sys_clone could just pass it down via C function call arguments.
> 
> Introduce a new CONFIG_HAVE_COPY_THREAD_TLS for architectures to opt
> into, and a new copy_thread_tls that accepts the tls parameter as an
> additional unsigned long (syscall-argument-sized) argument.
> Change sys_clone's tls argument to an unsigned long (which does
> not change the ABI), and pass that down to copy_thread_tls.
> 
> Architectures that don't opt into copy_thread_tls will continue to
> ignore the C argument to sys_clone in favor of the pt_regs captured at
> kernel entry, and thus will be unable to introduce new versions of the
> clone syscall.
> 
> Patch co-authored by Josh Triplett and Thiago Macieira.
> 
> ...
>
> @@ -1698,20 +1701,34 @@ long do_fork(unsigned long clone_flags,
>  	return nr;
>  }
>  
> +#ifndef CONFIG_HAVE_COPY_THREAD_TLS
> +/* For compatibility with architectures that call do_fork directly rather than
> + * using the syscall entry points below. */
> +long do_fork(unsigned long clone_flags,
> +	      unsigned long stack_start,
> +	      unsigned long stack_size,
> +	      int __user *parent_tidptr,
> +	      int __user *child_tidptr)
> +{
> +	return _do_fork(clone_flags, stack_start, stack_size,
> +			parent_tidptr, child_tidptr, 0);
> +}
> +#endif

drivers/misc/kgdbts.c:lookup_addr() has a reference to do_fork(). 
Doesn't link, with a basic `make allmodconfig'.
