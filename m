From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC v17][PATCH 22/60] c/r: external checkpoint of a task
	other than ourself
Date: Wed, 22 Jul 2009 12:52:23 -0500
Message-ID: <20090722175223.GA19389@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1248256822-23416-23-git-send-email-orenl@librato.com>
Sender: owner-linux-mm@kvack.org
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@openvz.org>, Alexey Dobriyan <adobriyan@gmail.com>, Oren Laadan <orenl@cs.columbia.edu>
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> Now we can do "external" checkpoint, i.e. act on another task.

...

>  long do_checkpoint(struct ckpt_ctx *ctx, pid_t pid)
>  {
>  	long ret;
> 
> +	ret = init_checkpoint_ctx(ctx, pid);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ctx->root_freezer) {
> +		ret = cgroup_freezer_begin_checkpoint(ctx->root_freezer);
> +		if (ret < 0)
> +			return ret;
> +	}

Self-checkpoint of a task in root freezer is now denied, though.

Was that intentional?

-serge

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
