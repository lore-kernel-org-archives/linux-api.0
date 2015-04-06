From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 7/7] clone4: Add a CLONE_FD flag to get task exit
 notification via fd
Date: Mon, 6 Apr 2015 17:30:35 +0900
Message-ID: <20150406083035.GA16373@swordfish>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <fdec4b70c7cd34e2eacf6a0e41d36f606a696da1.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fdec4b70c7cd34e2eacf6a0e41d36f606a696da1.1426376419.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On (03/15/15 01:00), Josh Triplett wrote:
[..]
> +
> +/* Handle the CLONE_FD case for copy_process. */
> +int clonefd_do_clone(u64 clone_flags, struct task_struct *p,
> +		     struct clone4_args *args, struct clonefd_setup *setup)
> +{
> +	int flags;
> +	struct file *file;
> +	int fd;
> +
> +	p->clonefd = !!(clone_flags & CLONE_FD);
> +	if (!p->clonefd)
> +		return 0;
> +
> +	if (args->clonefd_flags & ~(O_CLOEXEC | O_NONBLOCK))
> +		return -EINVAL;
> +
> +	init_waitqueue_head(&p->clonefd_wqh);
> +
> +	get_task_struct(p);
> +	flags = O_RDONLY | FMODE_ATOMIC_POS | args->clonefd_flags;
> +	file = anon_inode_getfile("[process]", &clonefd_fops, p, flags);
> +	if (IS_ERR(file)) {
> +		put_task_struct(p);
> +		return PTR_ERR(file);
> +	}
> +
> +	fd = get_unused_fd_flags(flags);
> +	if (fd < 0) {

+		put_task_struct(p); ?

> +		fput(file);
> +		return fd;
> +	}
> +
> +	setup->fd = fd;
> +	setup->file = file;
> +	return 0;
> +}
[..]

	-ss
