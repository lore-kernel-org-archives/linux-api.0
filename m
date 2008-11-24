From: "John McCutchan" <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Sun, 23 Nov 2008 21:08:05 -0800
Message-ID: <cfec22b10811232108u3ade8b66w58999054c03549fc@mail.gmail.com>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com>
	 <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de>
	 <20081122093749.GA12543@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081122093749.GA12543-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

At this point I don't really want to see changes made to inotify. But,
for arguments sake, why not something like inotify_init1 that takes a
flag EXTENDED_EVENT which causes a larger event structure to be used.
Something like,

struct inotify_event_extended
{
  s32 wd;
  u32 mask;
  u32 cookie;
  u32 data[4];
  char path[0];
}

The data array could be used to store arbitrary extra information,
specified by flags.

On Sat, Nov 22, 2008 at 1:37 AM, Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org> wrote:
> On Fri, Nov 21, 2008 at 07:39:45PM +0100, Arnd Bergmann (arnd-r2nGTMty4D4@public.gmane.org) wrote:
>> The how about an inotify_init1 flag telling the kernel to ignore
>> changes done by the current PID? That sounds like it is potentially
>> useful to other applications that want to monitor the whole file system
>> and also write to it. It also doesn't need to change the ABI in
>> incompatible ways or introduce a security relevant side channel.
>
> That's a good idea. Robert, John, Michael - comments?
>
> --
>        Evgeniy Polyakov
>



-- 
John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
