From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 260/266] loop: add ioctl to resize a loop device
Date: Tue, 6 Jan 2009 15:58:19 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901061554140.8799@localhost.localdomain>
References: <200901062243.n06Mh7HR004493@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200901062243.n06Mh7HR004493-AB4EexQrvXRQetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tomas-VOkecuvH9Oc@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On Tue, 6 Jan 2009, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> 
> Add the ability to 'resize' the loop device on the fly.

Hell no.

There is apparently no security checking here. No way can we allow this 
for any random user that can open the loopback device read-only and then 
just change its size.

It needs to use all the same security checks as "loop_set_status()" and 
friends, afaik.

Maybe I'm missing something, but I'm not going to apply it without 
somebody explaining why this isn't a total piece of shit.

I also don't want to have copyright licenses in changelogs. If it's a test 
app, anybody should be able to use it, no restrictions.

		Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
