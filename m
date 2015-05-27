From: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] fbcon: use the cursor blink interval provided by vt
Date: Wed, 27 May 2015 08:57:47 +0300
Message-ID: <CANaxB-zX4GkExeCzwgYZVDVZE47DHOCnRiYe86difk4fRMK=9A@mail.gmail.com>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
	<alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
	<20150225094946.GA24627@amd>
	<alpine.LNX.2.11.1502252319330.276@localhost>
	<20150226220243.GC9935@amd>
	<alpine.LNX.2.11.1502271905580.4212@localhost>
	<alpine.LNX.2.11.1502271914040.4248@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.11.1502271914040.4248@localhost>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Cc: Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-02-27 22:15 GMT+03:00 Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>:
> vt now provides a cursor blink interval via vc_data. Use this
> interval instead of the currently hardcoded 200 msecs. Store it in
> fbcon_ops to avoid locking the console in cursor_timer_handler().

I regularly execute criu tests on linux-next. For this, I use virtual
machine from the digitalocean clould. The current version of
linux-next hangs after a few seconds. I use git bisect to find the
commit where the problem is appeaed. And it looks like the problem is
in this patch.

When the kernel hangs, it doesn't report anything on the screen and
there is nothing suspicious in logs after reboot.

I will try to reproduce the problem in my local enviroment to get more
information.

There is my config file:
https://github.com/avagin/criu-jenkins-digitalocean/blob/d95d9e30a7da8755c47b290630bac7ee1fe7132d/jenkins-scripts/config

Thanks,
Andrew
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
