From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v17][PATCH 52/60] c/r: support semaphore sysv-ipc
Date: Wed, 22 Jul 2009 21:25:02 +0400
Message-ID: <20090722172502.GA15805@lenovo>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-53-git-send-email-orenl@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1248256822-23416-53-git-send-email-orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[Oren Laadan - Wed, Jul 22, 2009 at 06:00:14AM -0400]
...
| +static struct sem *restore_sem_array(struct ckpt_ctx *ctx, int nsems)
| +{
| +	struct sem *sma;
| +	int i, ret;
| +
| +	sma = kmalloc(nsems * sizeof(*sma), GFP_KERNEL);

Forgot to

	if (!sma)
		return -ENOMEM;

right?

| +	ret = _ckpt_read_buffer(ctx, sma, nsems * sizeof(*sma));
| +	if (ret < 0)
| +		goto out;
| +
| +	/* validate sem array contents */
| +	for (i = 0; i < nsems; i++) {
| +		if (sma[i].semval < 0 || sma[i].sempid < 0) {
| +			ret = -EINVAL;
| +			break;
| +		}
| +	}
| + out:
| +	if (ret < 0) {
| +		kfree(sma);
| +		sma = ERR_PTR(ret);
| +	}
| +	return sma;
| +}
...

	-- Cyrill
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
