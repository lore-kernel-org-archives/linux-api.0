From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [1/1] Use pid in inotify events.
Date: Mon, 10 Nov 2008 20:20:18 +0300
Message-ID: <20081110172018.GA22332@ioremap.net>
References: <20081108114225.GA22674@ioremap.net> <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com> <20081108153545.GA3859@ioremap.net> <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com> <20081110152043.GB15796@ioremap.net> <cfd18e0f0811100915o8ea98a0s816921cee3163c1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811100915o8ea98a0s816921cee3163c1c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John McCutchan <ttb-/fF4VJJ1vBJctGpslLZhzA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 10, 2008 at 12:15:36PM -0500, Michael Kerrisk (mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org) wrote:
> > This may be a good idea for some serious ABI change. I think we could
> > extend it even more to include IO offset/size into events and attribute
> > changes.
> 
> Are you going to revise your patch to use this idea?

Not now, since it is not a two-minute hack to write on top of existing
interfaces :)

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
