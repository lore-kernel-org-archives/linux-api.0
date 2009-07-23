From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v17][PATCH 22/60] c/r: external checkpoint of a task
	other than ourself
Date: Thu, 23 Jul 2009 09:54:38 -0500
Message-ID: <20090723145438.GA12945@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com> <20090722175223.GA19389@us.ibm.com> <4A67E7D7.9060800@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4A67E7D7.9060800-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org):
> 
> 
> Serge E. Hallyn wrote:
> > Quoting Oren Laadan (orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org):
> >> Now we can do "external" checkpoint, i.e. act on another task.
> > 
> > ...
> > 
> >>  long do_checkpoint(struct ckpt_ctx *ctx, pid_t pid)
> >>  {
> >>  	long ret;
> >>
> >> +	ret = init_checkpoint_ctx(ctx, pid);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	if (ctx->root_freezer) {
> >> +		ret = cgroup_freezer_begin_checkpoint(ctx->root_freezer);
> >> +		if (ret < 0)
> >> +			return ret;
> >> +	}
> > 
> > Self-checkpoint of a task in root freezer is now denied, though.
> > 
> > Was that intentional?
> 
> Yes.
> 
> "root freezer" is an arbitrary task in the checkpoint subtree or
> container. It is used to verify that all checkpointed tasks - except
> for current, if doing self-checkpoint - belong to the same freezer
> group.
> 
> Since current is busy calling checkpoint(2), and since we only permit
> checkpoint of (cgroup-) frozen tasks, then - by definition - it cannot
> possibly belong to the same group. If it did, it would itself be frozen
> like its fellows and unable to call checkpoint(2).
> 
> Oren.

Ok, well I don't know what was happening yesterday.  Today it's
restart that is failing, and as you pointed out on irc that's
on s390 only.  I'll send out a patch this afternoon to fix that.

Yesterday I must not have read the output right I guess...

thanks,
-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
