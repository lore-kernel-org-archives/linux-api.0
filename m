From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Mon, 2 May 2011 13:57:10 +0200
Message-ID: <201105021357.10560.arnd@arndb.de>
References: <1304093980-12877-1-git-send-email-andrea@betterlinux.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304093980-12877-1-git-send-email-andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Friday 29 April 2011, Andrea Righi wrote:
> NOTE #1: to avoid potential DoS in the system the rate of calls to
> fadvise(POSIX_FADV_DONTNEED_FS) from non-privileged users are limited
> according to these settings:
> 
>  - /proc/sys/vm/drop_pagecache_ratelimit: the minimum length of time
>    allowed beetween two different bursts of fadvise(POSIX_FADV_DONTNEED_FS)
> 
>  - /proc/sys/vm/drop_pagecache_ratelimit_burst: the number of calls to
>    fadvise(POSIX_FADV_DONTNEED_FS) that can be issued before enforcing
>    the rate limiting

The ratelimiting interface does not give me the happy feeling I had with
the original extremely syscall and fadvise, or with strictly limiting it
to certain capabilities. The ratelimit bursts seem well suited for log
messages, but it's not like you would expect anyone to read the fadvise
man page describing these and think "oh, of course, that's obviously
why it has to be done this way".

I don't have a perfect solution myself, but there are a few things
that feel wrong about yours:

* The rules for /proc/sys/vm/drop_caches and the fadvise are different
* You need to tune two variables to set one thing
* The rate limit is independent of the number of file systems you
  operate on: When you have mounted 20 file systems, you need to
  sleep for five seconds after flushing half of them, but you can
  flush one ten times in a row without being throttled.
* Returning an error gives no feedback about how soon it can
  be retried, in case you really need to flush.

	Arnd
