From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 260/266] loop: add ioctl to resize a loop device
Date: Tue, 6 Jan 2009 16:04:14 -0800
Message-ID: <20090106160414.b165d452.akpm@linux-foundation.org>
References: <200901062243.n06Mh7HR004493@imap1.linux-foundation.org>
	<alpine.LFD.2.00.0901061554140.8799@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0901061554140.8799-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tomas-VOkecuvH9Oc@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 6 Jan 2009 15:58:19 -0800 (PST)
Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> 
> 
> On Tue, 6 Jan 2009, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> > 
> > Add the ability to 'resize' the loop device on the fly.
> 
> Hell no.
> 
> There is apparently no security checking here. No way can we allow this 
> for any random user that can open the loopback device read-only and then 
> just change its size.
> 
> It needs to use all the same security checks as "loop_set_status()" and 
> friends, afaik.
> 

oops, didn't think of that.

There's a bug, too:

> +static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
> +{
> +	int err;
> +	sector_t sec;
> +	loff_t sz;
> +
> +	err = -ENXIO;
> +	if (unlikely(lo->lo_state != Lo_bound))
> +		goto out;
> +	err = figure_loop_size(lo);
> +	if (unlikely(err))
> +		goto out;
> +	sec = get_capacity(lo->lo_disk);
> +	sz = sec << 9;

This can overflow if sector_t is 32-bit.  Fix with:

	sz = (loff_t)sec << 9;

> +	mutex_lock(&bdev->bd_mutex);
> +	bd_set_size(bdev, sz);
> +	mutex_unlock(&bdev->bd_mutex);
> +
> + out:
> +	return err;
> +}

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
