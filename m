From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
	dequeuing signals (v2)
Date: Thu, 7 Feb 2013 18:34:47 +0100
Message-ID: <20130207173447.GA5888@redhat.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <1359486181-29088-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1359486181-29088-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrey, sorry for delay.

As for API, I leave this to you and Michael. Not that I like these
new flags, but I agree that pread() hack was not pretty too.

On 01/29, Andrey Vagin wrote:
> +static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
> +				siginfo_t *info, loff_t *ppos, int queue_mask)
> +{
> +	loff_t seq = *ppos / sizeof(struct signalfd_siginfo);
> +	int signr = 0;
> +
> +	if (queue_mask & SIGQUEUE_PRIVATE)
> +		signr = peek_signal(&current->pending,
> +					&ctx->sigmask, info, &seq);
> +	else if (queue_mask & SIGQUEUE_SHARED)
> +		signr = peek_signal(&current->signal->shared_pending,
> +					 &ctx->sigmask, info, &seq);
> +	(*ppos) += sizeof(struct signalfd_siginfo);

Now that this can work even with normal read(), we will actually change
f_pos. Then perhaps signalfd_fops->llseek() should work too. But this
is minor...

Hmm. but since it works with read(), we shouldn't increment *ppos unless
signalfd_copyinfo() succeeds?

Btw, why do you pass seq by reference? Looks unneeded.

Oleg.
