From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Mon, 24 Nov 2008 10:30:19 +0300
Message-ID: <20081124073018.GC10119@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de> <20081122093749.GA12543@ioremap.net> <cfec22b10811232108u3ade8b66w58999054c03549fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfec22b10811232108u3ade8b66w58999054c03549fc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi John.

On Sun, Nov 23, 2008 at 09:08:05PM -0800, John McCutchan (john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org) wrote:
> At this point I don't really want to see changes made to inotify. But,
> for arguments sake, why not something like inotify_init1 that takes a
> flag EXTENDED_EVENT which causes a larger event structure to be used.
> Something like,
> 
> struct inotify_event_extended
> {
>   s32 wd;
>   u32 mask;
>   u32 cookie;
>   u32 data[4];
>   char path[0];
> }
> 
> The data array could be used to store arbitrary extra information,
> specified by flags.

What will happen when above array is not enough to store needed info?
Although I do not see any reason to send start/offset for the IO itself,
but if it will be decided to do so, above array already is not large
enough. I think I will cook up preliminary patch to add nested
attributes into event structure like I described previously in the
thread to get people involved with working example.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
