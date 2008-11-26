From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take2] Inotify: nested attributes support.
Date: Wed, 26 Nov 2008 11:29:36 +0300
Message-ID: <20081126082936.GB17525@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081126001538.4b1c7c99.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pavel-AlSwsSmVLrQ@public.gmane.org, davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 26, 2008 at 12:15:38AM -0800, Andrew Morton (akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org) wrote:
> OK, so we have a super-duper framework which will allow us to add pids
> (and other things) to inotify messages.

Yup :)

> This still doesn't provide a reason for anyone to be interested in the
> code!  Why do we want pids in inotify messages?
 
I actually cared only about myself :)
I started the thread and implementation, because my application has to
differentiate IO made by itself and any IO made by system (another
users, crons, whatever else), inotify did not give me that info, so I
extended it. As of others: PID/TID may be used by watching applications
to reduce own load to not process own IO, things like beagle may show
who actually made changes into the file.

> And how does this work give that pids are (no longer) system-wide unique?

It gets pids from the caller's task_struct (via current), so its data is
as unique as process calling getpid() or syscall(__NR_gettid).

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
