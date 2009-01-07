From: hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Subject: Re: [patch 260/266] loop: add ioctl to resize a loop device
Date: Wed, 07 Jan 2009 15:13:46 +0900
Message-ID: <31718.1231308826@jrobl>
References: <200901062243.n06Mh7HR004493@imap1.linux-foundation.org> <alpine.LFD.2.00.0901061554140.8799@localhost.localdomain> <20090106160414.b165d452.akpm@linux-foundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090106160414.b165d452.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tomas-VOkecuvH9Oc@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org


Andrew Morton:
> > There is apparently no security checking here. No way can we allow this 
> > for any random user that can open the loopback device read-only and then 
> > just change its size.
> > 
> > It needs to use all the same security checks as "loop_set_status()" and 
> > friends, afaik.
> > 
> 
> oops, didn't think of that.

I will add some security checks and send a new patch. But it may not be
purely same to loop_set_status() since the checks for encrypt_key or
something is unnecessary.


> This can overflow if sector_t is 32-bit.  Fix with:
> 
> 	sz = (loff_t)sec << 9;

I will fix and send it too.


J. R. Okajima
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
