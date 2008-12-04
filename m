From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take2] Inotify: nested attributes support.
Date: Thu, 4 Dec 2008 12:09:00 +0300
Message-ID: <20081204090900.GA4615@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net> <20081204084309.GA2072@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081204084309.GA2072-I/5MKhXcvmPrBKCeMvbIDA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 04, 2008 at 09:43:10AM +0100, Pavel Machek (pavel-AlSwsSmVLrQ@public.gmane.org) wrote:
> Actually, does the kernel even know who initiated the i/o?
> 
> Take two threads, both mapping /etc/something , both of them writing
> through the mmap. Kernel sees dirty pages so it writes them back, but
> which thread is repsonsible for the write?

It depends. If write will be done with write() syscall, caller will be
stored. Otherwise inotify does not hook into page fault code afaics.

> > > And how does this work give that pids are (no longer) system-wide unique?
> > 
> > It gets pids from the caller's task_struct (via current), so its data is
> > as unique as process calling getpid() or syscall(__NR_gettid).
> 
> What happens on mmap()?

mmap() syscall is not processed by inotify.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
