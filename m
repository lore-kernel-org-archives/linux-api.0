From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 17/19] y2038: use __kernel_timespec in sys_futex
Date: Tue, 19 May 2015 11:24:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505191124490.4225@nanos>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de> <1430929826-318934-18-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430929826-318934-18-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 6 May 2015, Arnd Bergmann wrote:

> Conversion for sys_futex is particularly easy, we can use the unmodified
> compat_sys_futex on 32-bit systems to provide compatibility for 32-bit
> time_t, and change sys_futex to pass a __kernel_timespec, which matches
> what future libc implementations will use as their struct timespec.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
