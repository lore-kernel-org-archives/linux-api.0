From: David Newall <davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org>
Subject: Re: [take2] Inotify: nested attributes support.
Date: Wed, 26 Nov 2008 23:17:28 +1030
Message-ID: <492D4560.8000302@davidnewall.com>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081126082936.GB17525-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pavel-AlSwsSmVLrQ@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Evgeniy Polyakov wrote:
> On Wed, Nov 26, 2008 at 12:15:38AM -0800, Andrew Morton (akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org) wrote:
>   
>> This still doesn't provide a reason for anyone to be interested in the
>> code!  Why do we want pids in inotify messages?
>>     
>  
> my application has to
> differentiate IO made by itself and any IO made by system (another
> users, crons, whatever else)

I don't think so.  As discussed,
(http://marc.info/?l=linux-kernel&m=122735413932519), you already can
differentiate I/O made by local users, so you don't need to modify inotify.

This change violates my first rule of programming: If there's two or
more ways of solving a problem, pick one; don't pick them all.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
