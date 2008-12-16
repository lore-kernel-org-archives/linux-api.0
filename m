From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, RESEND] getrusage: fill ru_maxrss value
Date: Tue, 16 Dec 2008 16:20:54 +0100
Message-ID: <20081216152054.GA17012@redhat.com>
References: <20081216155641.1411f8a7@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081216155641.1411f8a7-YzwxZg+R7evSU73v1vjTzyO4YDw3rz4rAInAS/Ez/D0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hugh-DTz5qymZ9yRBDgjK7y7TUQ@public.gmane.org>, jlim-sJ/iWh9BUns@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/16, Jiri Pirko wrote:
>
> This patch makes ->ru_maxrss value in struct rusage filled accordingly to
> rss hiwater mark. This struct is filled as a parameter to
> getrusage syscall. ->ru_maxrss value is set to pages which might be correct
> as "time" application converts it to KBs.
>
> To make this happen we extend struct signal_struct by two fields. The
> first one is ->maxrss which we use to store rss hiwater of the task. The
> second one is ->cmaxrss which we use to store highest rss hiwater of all
> task childs. These values are used in k_getrusage() to actually fill
> ->ru_maxrss. k_getrusage() uses current rss hiwater value directly
> if mm struct exists.
>
> We clear the ->maxrss as a part of flush_old_exec() to be consistent
> because bprm_mm_init() does not copy ->hiwater_rss.

Imho the patch is fine, but

> @@ -1598,6 +1601,15 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>  out:
>  	cputime_to_timeval(utime, &r->ru_utime);
>  	cputime_to_timeval(stime, &r->ru_stime);
> +
> +	task_lock(p);
> +	if (p->mm) {
> +		unsigned long maxrss = get_mm_hiwater_rss(p->mm);
> +
> +		if (r->ru_maxrss < maxrss)
> +			r->ru_maxrss = maxrss;
> +	}
> +	task_unlock(p);

I think the code above should check "if (who != RUSAGE_CHILDREN) ?

Oleg.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
