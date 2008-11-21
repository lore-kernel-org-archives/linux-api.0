From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Fri, 21 Nov 2008 19:39:45 +0100
Message-ID: <200811211939.46812.arnd@arndb.de>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081120230612.GB6536-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Friday 21 November 2008, Evgeniy Polyakov wrote:
> I have a network server, which gets IO requests from different clients
> and maintains coherency of the data between them, but if file is
> modified locally I want to flush or invalidate remote data. I decided
> not to dig into the kernel on the server node and use inotify to get
> notifications about events, but there is no way to determine if given IO
> was originated by server itself (and in this case nothing should be
> done), or by external application which accesses exported directory (and
> in this case I should send update messages to clients).

The how about an inotify_init1 flag telling the kernel to ignore
changes done by the current PID? That sounds like it is potentially
useful to other applications that want to monitor the whole file system
and also write to it. It also doesn't need to change the ABI in
incompatible ways or introduce a security relevant side channel.

	Arnd <><
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
