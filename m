From: Balbir Singh <balbir-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v12][PATCH 01/14] Create syscalls: sys_checkpoint,
	sys_restart
Date: Wed, 14 Jan 2009 23:34:41 +0530
Message-ID: <20090114180441.GD21516@balbir.in.ibm.com>
References: <1230542187-10434-1-git-send-email-orenl@cs.columbia.edu> <1230542187-10434-2-git-send-email-orenl@cs.columbia.edu>
Reply-To: balbir-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1230542187-10434-2-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org> [2008-12-29 04:16:14]:

> Create trivial sys_checkpoint and sys_restore system calls. They will
> enable to checkpoint and restart an entire container, to and from a
> checkpoint image file descriptor.
> 
> The syscalls take a file descriptor (for the image file) and flags as
> arguments. For sys_checkpoint the first argument identifies the target
> container; for sys_restart it will identify the checkpoint image.
> 
> A checkpoint, much like a process coredump, dumps the state of multiple
> processes at once, including the state of the container. The checkpoint
> image is written to (and read from) the file descriptor directly from
> the kernel. This way the data is generated and then pushed out naturally
> as resources and tasks are scanned to save their state. This is the
> approach taken by, e.g., Zap and OpenVZ.
> 
> By using a return value and not a file descriptor, we can distinguish
> between a return from checkpoint, a return from restart (in case of a
> checkpoint that includes self, i.e. a task checkpointing its own
> container, or itself), and an error condition, in a manner analogous
> to a fork() call.
> 
> We don't use copyin()/copyout() because it requires holding the entire

              ^^^^^^^^^^^^^^^^^^^ Do you mean get_user_pages(),
copy_to/from_user()?

> image in user space, and does not make sense for restart.  Also, we
> don't use a pipe, pseudo-fs file and the like, because they work by
> generating data on demand as the user pulls it (unless the entire
> image is buffered in the kernel) and would require more complex logic.
> They also would significantly complicate checkpoint that includes self.
> 
> Changelog[v5]:
>   - Config is 'def_bool n' by default
> 
> Signed-off-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
> Acked-by: Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  arch/x86/include/asm/unistd_32.h   |    2 +
>  arch/x86/kernel/syscall_table_32.S |    2 +
>  checkpoint/Kconfig                 |   11 +++++++++
>  checkpoint/Makefile                |    5 ++++
>  checkpoint/sys.c                   |   41 ++++++++++++++++++++++++++++++++++++
>  include/linux/syscalls.h           |    2 +
>  init/Kconfig                       |    2 +
>  kernel/sys_ni.c                    |    4 +++
>  8 files changed, 69 insertions(+), 0 deletions(-)
>  create mode 100644 checkpoint/Kconfig
>  create mode 100644 checkpoint/Makefile
>  create mode 100644 checkpoint/sys.c
> 
> diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
> index f2bba78..a5f9e09 100644
> --- a/arch/x86/include/asm/unistd_32.h
> +++ b/arch/x86/include/asm/unistd_32.h
> @@ -338,6 +338,8 @@
>  #define __NR_dup3		330
>  #define __NR_pipe2		331
>  #define __NR_inotify_init1	332
> +#define __NR_checkpoint		333
                           ^^^ extra tab
> +#define __NR_restart		334

-- 
	Balbir
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
