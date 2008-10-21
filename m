From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
 restart
Date: Tue, 21 Oct 2008 12:41:30 -0700
Message-ID: <20081021124130.a002e838.akpm@linux-foundation.org>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
	<1224481237-4892-3-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1224481237-4892-3-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 20 Oct 2008 01:40:30 -0400
Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org> wrote:

> Add those interfaces, as well as helpers needed to easily manage the
> file format. The code is roughly broken out as follows:
> 
> checkpoint/sys.c - user/kernel data transfer, as well as setup of the
> checkpoint/restart context (a per-checkpoint data structure for
> housekeeping)
> 
> checkpoint/checkpoint.c - output wrappers and basic checkpoint handling
> 
> checkpoint/restart.c - input wrappers and basic restart handling
> 
> Patches to add the per-architecture support as well as the actual
> work to do the memory checkpoint follow in subsequent patches.
> 
>
> ...
>
> +int cr_kwrite(struct cr_ctx *ctx, void *buf, int count)
> +{
> +	mm_segment_t oldfs;
> +	int ret;
> +
> +	oldfs = get_fs();
> +	set_fs(KERNEL_DS);
> +	ret = cr_uwrite(ctx, buf, count);
> +	set_fs(oldfs);
> +
> +	return ret;
> +}

The decision to write files direct from within the kernel is a bit
unusual and needs discussion and justification in the changelog,
please.

Other schemes would be to make the data available to userspace via a
pseudo-fs file, netlink, a pipe, blah, blah.

>
> ...
>
> +/*
> + * During checkpoint and restart the code writes outs/reads in data
> + * to/from the chekcpoint image from/to a temporary buffer (ctx->hbuf).

Yuo cnat tpye.

> + * Because operations can be nested, one should call cr_hbuf_get() to
> + * reserve space in the buffer, and then cr_hbuf_put() when no longer
> + * needs that space.

Mangled grammar.

> + */
> +
> +/*
> + * ctx->hbuf is used to hold headers and data of known (or bound),
> + * static sizes. In some cases, multiple headers may be allocated in
> + * a nested manner. The size should accommodate all headers, nested
> + * or not, on all archs.
> + */
> +#define CR_HBUF_TOTAL  (8 * 4096)
> +
>
> ...
>
> +/*
> + * helpers to manage CR contexts: allocated for each checkpoint and/or
> + * restart operation, and persists until the operation is completed.
> + */
> +
> +/* unique checkpoint identifier (FIXME: should be per-container) */
> +static atomic_t cr_ctx_count;

This never gets initialised.  Use ATOMIC_INIT() here.  (It doesn't
matter, but one day it might!)

>
> ...
>
>  asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
>  {
> -	pr_debug("sys_checkpoint not implemented yet\n");
> -	return -ENOSYS;
> +	struct cr_ctx *ctx;
> +	int ret;
> +
> +	/* no flags for now */
> +	if (flags)
> +		return -EINVAL;
> +
> +	ctx = cr_ctx_alloc(pid, fd, flags | CR_CTX_CKPT);
> +	if (IS_ERR(ctx))
> +		return PTR_ERR(ctx);
> +
> +	ret = do_checkpoint(ctx);
> +
> +	if (!ret)
> +		ret = ctx->crid;
> +
> +	cr_ctx_free(ctx);
> +	return ret;
>  }

Is it appropriate that this be an unprivileged operation?

What happens if I pass it a pid which isn't system-wide unique?

What happens if I pass it a pid of a process which I don't own?  This
is super security-sensitive and we need to go over the permission
checking with a toothcomb.  It needs to be exhaustively described in
the changelog.  It might have security/selinux implications - I don't
know, I didn't look, but lights are flashing and bells are ringing over
here.

What happens if I pass it a pid of a process which I _do_ own, but it
does not refer to a container's init process?

If `pid' must refer to a container's init process, isn't it always
equal to 1??

>  /**
>   * sys_restart - restart a container
>   * @crid: checkpoint image identifier
> @@ -36,6 +234,19 @@ asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
>   */
>  asmlinkage long sys_restart(int crid, int fd, unsigned long flags)
>  {
> -	pr_debug("sys_restart not implemented yet\n");
> -	return -ENOSYS;
> +	struct cr_ctx *ctx;
> +	int ret;
> +
> +	/* no flags for now */
> +	if (flags)
> +		return -EINVAL;
> +
> +	ctx = cr_ctx_alloc(crid, fd, flags | CR_CTX_RSTR);
> +	if (IS_ERR(ctx))
> +		return PTR_ERR(ctx);
> +
> +	ret = do_restart(ctx);
> +
> +	cr_ctx_free(ctx);
> +	return ret;
>  }

Again, this is scary stuff.  We're allowing unprivileged userspace to
feed random numbers into kernel data structures.

I'd like to see the security guys take a real close look at all of
this, and for them to do that effectively they should be provided with
a full description of the security design of this feature.

> diff --git a/fs/read_write.c b/fs/read_write.c
> index 9ba495d..e2deded 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -324,12 +324,12 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
>  
>  EXPORT_SYMBOL(vfs_write);
>  
> -static inline loff_t file_pos_read(struct file *file)
> +inline loff_t file_pos_read(struct file *file)
>  {
>  	return file->f_pos;
>  }
>  
> -static inline void file_pos_write(struct file *file, loff_t pos)
> +inline void file_pos_write(struct file *file, loff_t pos)
>  {
>  	file->f_pos = pos;
>  }

Might as well move these to a header and inline them everywhere. 
That'd be a separate leadin patch.


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
