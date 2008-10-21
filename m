From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Date: Tue, 21 Oct 2008 15:24:10 -0500
Message-ID: <20081021202410.GA10423@us.ibm.com>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu> <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu> <20081021124130.a002e838.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081021124130.a002e838.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Andrew Morton (akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org):
> On Mon, 20 Oct 2008 01:40:30 -0400
> Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org> wrote:
> >  asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
> >  {
> > -	pr_debug("sys_checkpoint not implemented yet\n");
> > -	return -ENOSYS;
> > +	struct cr_ctx *ctx;
> > +	int ret;
> > +
> > +	/* no flags for now */
> > +	if (flags)
> > +		return -EINVAL;
> > +
> > +	ctx = cr_ctx_alloc(pid, fd, flags | CR_CTX_CKPT);
> > +	if (IS_ERR(ctx))
> > +		return PTR_ERR(ctx);
> > +
> > +	ret = do_checkpoint(ctx);
> > +
> > +	if (!ret)
> > +		ret = ctx->crid;
> > +
> > +	cr_ctx_free(ctx);
> > +	return ret;
> >  }
> 
> Is it appropriate that this be an unprivileged operation?

Early versions checked capable(CAP_SYS_ADMIN), and we reasoned that we
would later attempt to remove the need for privilege so that all users
could safely use it.

Arnd Bergmann called us on that nonsense, pointing out that it'd make
more sense to let unprivileged users use them now, so that we'll be
more careful about the security as patches roll in.

So, Oren's patchset right now only checkpoints current, despite pid
being part of the API.  So the task can access its own data.  When
the patch supports checkpointing another task (which Oren says he's
doing right now), then our intent is to check for ptrace access to
the target task.  (Right, Oren?)

> What happens if I pass it a pid which isn't system-wide unique?

pid must be checked in the caller's pid namespace.  So if I've create a
container which I want to checkpoint, pid 1 in that pidns will be, say,
3497 in my pid_ns, and so 3497 is the pid I must use.  If I try to pass
1, I'll try to checkpoint my own container.  And, if I'm not privileged
and init is owned by root, the ptrace() check I mentioned above will
return -EPERM.

> What happens if I pass it a pid of a process which I don't own?  This
> is super security-sensitive and we need to go over the permission
> checking with a toothcomb.  It needs to be exhaustively described in
> the changelog.  It might have security/selinux implications - I don't
> know, I didn't look, but lights are flashing and bells are ringing over
> here.
> 
> What happens if I pass it a pid of a process which I _do_ own, but it
> does not refer to a container's init process?

I would assume that do_checkpoint() would return -EINVAL, but it's a
great question:  Oren, did you have another plan?

> If `pid' must refer to a container's init process, isn't it always
> equal to 1??

Not in the caller's pid_namespace.

> 
> >  /**
> >   * sys_restart - restart a container
> >   * @crid: checkpoint image identifier
> > @@ -36,6 +234,19 @@ asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
> >   */
> >  asmlinkage long sys_restart(int crid, int fd, unsigned long flags)
> >  {
> > -	pr_debug("sys_restart not implemented yet\n");
> > -	return -ENOSYS;
> > +	struct cr_ctx *ctx;
> > +	int ret;
> > +
> > +	/* no flags for now */
> > +	if (flags)
> > +		return -EINVAL;
> > +
> > +	ctx = cr_ctx_alloc(crid, fd, flags | CR_CTX_RSTR);
> > +	if (IS_ERR(ctx))
> > +		return PTR_ERR(ctx);
> > +
> > +	ret = do_restart(ctx);
> > +
> > +	cr_ctx_free(ctx);
> > +	return ret;
> >  }
> 
> Again, this is scary stuff.  We're allowing unprivileged userspace to
> feed random numbers into kernel data structures.

Yes, all of the file opens and mmaps must not skip the usual security
checks.  The task credentials are currently unsupported, meaning that
euid, etc, come from the caller, not the checkpoint image.  When the
restoration of credentials becomes supported, then definately the
caller (of sys_restore())'s ability to setresuid/setresgid to those
values must be checked.

So that's why we don't want CAP_SYS_ADMIN required up-front.  That way
we will be forced to more carefully review each of those features.

> I'd like to see the security guys take a real close look at all of
> this, and for them to do that effectively they should be provided with
> a full description of the security design of this feature.

Right, some of the above should be spelled out somewhere.  Should it be
in the patch description, in the Documentation/checkpoint.txt file,
or someplace else?  Oren, do you want to filter the above information
into the right place, or do you want me to do it and send you a patch?

> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 9ba495d..e2deded 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -324,12 +324,12 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
> >  
> >  EXPORT_SYMBOL(vfs_write);
> >  
> > -static inline loff_t file_pos_read(struct file *file)
> > +inline loff_t file_pos_read(struct file *file)
> >  {
> >  	return file->f_pos;
> >  }
> >  
> > -static inline void file_pos_write(struct file *file, loff_t pos)
> > +inline void file_pos_write(struct file *file, loff_t pos)
> >  {
> >  	file->f_pos = pos;
> >  }
> 
> Might as well move these to a header and inline them everywhere. 
> That'd be a separate leadin patch.
> 

thanks,
-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
