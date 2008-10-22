From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Date: Wed, 22 Oct 2008 10:28:04 -0500
Message-ID: <20081022152804.GA23821@us.ibm.com>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu> <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu> <20081021124130.a002e838.akpm@linux-foundation.org> <20081021202410.GA10423@us.ibm.com> <48FE82DF.6030005@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <48FE82DF.6030005-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org):
> 
> 
> Serge E. Hallyn wrote:
> > Quoting Andrew Morton (akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org):
> >> On Mon, 20 Oct 2008 01:40:30 -0400
> >> Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org> wrote:
> >>>  asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
> >>>  {
> >>> -	pr_debug("sys_checkpoint not implemented yet\n");
> >>> -	return -ENOSYS;
> >>> +	struct cr_ctx *ctx;
> >>> +	int ret;
> >>> +
> >>> +	/* no flags for now */
> >>> +	if (flags)
> >>> +		return -EINVAL;
> >>> +
> >>> +	ctx = cr_ctx_alloc(pid, fd, flags | CR_CTX_CKPT);
> >>> +	if (IS_ERR(ctx))
> >>> +		return PTR_ERR(ctx);
> >>> +
> >>> +	ret = do_checkpoint(ctx);
> >>> +
> >>> +	if (!ret)
> >>> +		ret = ctx->crid;
> >>> +
> >>> +	cr_ctx_free(ctx);
> >>> +	return ret;
> >>>  }
> >> Is it appropriate that this be an unprivileged operation?
> > 
> > Early versions checked capable(CAP_SYS_ADMIN), and we reasoned that we
> > would later attempt to remove the need for privilege so that all users
> > could safely use it.
> > 
> > Arnd Bergmann called us on that nonsense, pointing out that it'd make
> > more sense to let unprivileged users use them now, so that we'll be
> > more careful about the security as patches roll in.
> > 
> > So, Oren's patchset right now only checkpoints current, despite pid
> > being part of the API.  So the task can access its own data.  When
> > the patch supports checkpointing another task (which Oren says he's
> > doing right now), then our intent is to check for ptrace access to
> > the target task.  (Right, Oren?)
> 
> Correct. That's already in the additional patch in the git tree - first
> I locate the task and if found, I check ptrace_may_access() (read mode).

Just thinking aloud...

Is read mode appropriate?  The user can edit the statefile and restart
it.  Admittedly the restart code should then do all the appropriate
checks for recreating resources, but I'm having a hard time thinking
through this straight.

Let's say hallyn is running passwd.  ruid=500,euid=0.  He quickly
checkpoints.  Then he restarts.  Will restart say "ok, the /bin/passwd
binary is setuid 0 so let hallyn take euid=0 for this?"  I guess not.
But are there other resources for which this is harder to get right?

...

> This should be covered by ptrace_may_access() test.
> 
> In the longer run, I suppose SElinux people would want a security hook
> there to approve or disapprove the operation.

I think we'll find the ptrace() checks to be so like what we're doing
that no new check will be needed.  But we should definately ask them.

Now may be too early to ask, though.  The answer will be clearer once
more resources are supported.
 
> 
> >>
> >> What happens if I pass it a pid of a process which I _do_ own, but it
> >> does not refer to a container's init process?
> > 
> > I would assume that do_checkpoint() would return -EINVAL, but it's a
> > great question:  Oren, did you have another plan?
> 
> Since we intentional provide minimal functionality to keep the patchset
> simple and allow easy review - we only checkpoint one task; it doesn't
> really matter because we don't deal with the entire container.
> 
> With the ability to checkpoint multiple process we will have to ensure
> that we checkpoint an entire container. I planned to return -EINVAL if
> the target task isn't a container init(1). Another option, if people
> prefer, is to use any task in a container to "represent" the entire
> container.

Except we support nested containers, so unless we only support
checkpoint of the deepest container, that doesn't work.

...

> >> Again, this is scary stuff.  We're allowing unprivileged userspace to
> >> feed random numbers into kernel data structures.
> > 
> > Yes, all of the file opens and mmaps must not skip the usual security
> > checks.  The task credentials are currently unsupported, meaning that
> > euid, etc, come from the caller, not the checkpoint image.  When the
> 
> Actually, the fact that task credentials are not restored makes it
> more secure, because the user can't do anything beyond her current
> capabilities.

Hmm, so do you think we just always use the caller's credentials?

If we were to use some sort of tpm-signing of statefiles, then
hallyn restarting a checkpointed /bin/passwd may become doable.

> For the same reason, however, unless we agree on a secure way to
> elevate credentials, there are various things that we cannot restore,
> even though it may be something we would want to permit.
> 
> > restoration of credentials becomes supported, then definately the
> > caller (of sys_restore())'s ability to setresuid/setresgid to those
> > values must be checked.
> > 
> > So that's why we don't want CAP_SYS_ADMIN required up-front.  That way
> > we will be forced to more carefully review each of those features.
> > 
> >> I'd like to see the security guys take a real close look at all of
> >> this, and for them to do that effectively they should be provided with
> >> a full description of the security design of this feature.
> > 
> > Right, some of the above should be spelled out somewhere.  Should it be
> > in the patch description, in the Documentation/checkpoint.txt file,
> > or someplace else?  Oren, do you want to filter the above information
> > into the right place, or do you want me to do it and send you a patch?
> 
> I'll add something to the Documentation/checkpoint.txt.

Cool, thanks Oren.

-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
