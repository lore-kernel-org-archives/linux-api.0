From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [1/1] Use pid in inotify events.
Date: Sat, 8 Nov 2008 21:40:13 +0300
Message-ID: <20081108184013.GA11888@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>
Cc: John McCutchan <ttb-/fF4VJJ1vBJctGpslLZhzA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Nov 08, 2008 at 01:35:07PM -0500, Robert Love (rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org) wrote:
> Pointing out some other information leak doesn't lessen the pid problem.

I just wanted to show that this is not a security problem.
Since there are others probably even more important.

But I really do not want to start to discuss this, since I already see
that result will be effectively zero, so returning to the original
problem with putting pid into events: if inotify_init() caller has 0
(e)uid or if IO origin has the same (e)uid, are you ok to put pid into
the event?

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
