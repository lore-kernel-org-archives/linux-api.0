From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/3] man2/fincore.2: document general description about
 fincore(2)
Date: Mon, 07 Jul 2014 12:08:12 -0700
Message-ID: <53BAF01C.8010700@intel.com>
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1404756006-23794-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404756006-23794-4-git-send-email-n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Andres Freund <andres-lJk9oCk3lhPBpgsEml150g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Naoya Horiguchi <nao.horiguchi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/07/2014 11:00 AM, Naoya Horiguchi wrote:
> +.SH RETURN VALUE
> +On success,
> +.BR fincore ()
> +returns 0.
> +On error, \-1 is returned, and
> +.I errno
> +is set appropriately.

Is this accurate?  From reading the syscall itself, it looked like it
did this:

> + * Return value is the number of pages whose data is stored in fc->buffer.
> + */
> +static long do_fincore(struct fincore_control *fc, int nr_pages)

and:

> +SYSCALL_DEFINE6(fincore, int, fd, loff_t, start, long, nr_pages,
...
> +	while (fc.nr_pages > 0) {
> +		memset(fc.buffer, 0, fc.buffer_size);
> +		ret = do_fincore(&fc, min(step, fc.nr_pages));
> +		/* Reached the end of the file */
> +		if (ret == 0)
> +			break;
> +		if (ret < 0)
> +			break;
...
> +	}
...
> +	return ret;
> +}

Which seems that for a given loop of do_fincore(), you might end up
returning the result of that *single* iteration of do_fincore() instead
of the aggregate of the entire syscall.

So, it can return <0 on failure, 0 on success, or also an essentially
random >0 number on success too.

Why not just use the return value for something useful instead of
hacking in the extras->nr_entries stuff?  Oh, and what if that

> +	if (extra)
> +		__put_user(nr, &extra->nr_entries);

fails?  It seems like we might silently forget to tell userspace how
many entries we filled.
