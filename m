From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Fri, 21 Nov 2008 02:06:12 +0300
Message-ID: <20081120230612.GB6536@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081118131937.GC16944@lst.de> <20081119140500.GA25968@ioremap.net> <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222@mail.gmail.com> <20081119145351.GA2652@ioremap.net> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfec22b10811201434v2230d11dvc9797018e433fd20-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi John.

On Thu, Nov 20, 2008 at 02:34:11PM -0800, John McCutchan (john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org) wrote:
> I really don't like the idea of overloading the cookie field to store
> the pid for only the events that don't already use the cookie field.

Adding PID or whatever else will not be used most of the time either.
I agree, that having new protocol (which so far did not get any
extensions except what I described for my own application) looks
cleaner, but if no one will use it, and existing extension works for
everyone (nothing breaks), I'm trying to push this idea up.

So, except theoretical clearness of the unused-by-everyong idea,
what forces you to think, that new inotify should be implemented?

> Coming into this late, maybe I missed it but can you explain why you
> need the pid that caused the event?

I have a network server, which gets IO requests from different clients
and maintains coherency of the data between them, but if file is
modified locally I want to flush or invalidate remote data. I decided
not to dig into the kernel on the server node and use inotify to get
notifications about events, but there is no way to determine if given IO
was originated by server itself (and in this case nothing should be
done), or by external application which accesses exported directory (and
in this case I should send update messages to clients).

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
