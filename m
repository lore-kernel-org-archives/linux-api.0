From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] reintroduce accept4
Date: Mon, 27 Oct 2008 20:41:35 -0700
Message-ID: <20081027204135.a139704e.akpm@linux-foundation.org>
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200810261641.m9QGfotr024285-sQhldQRnEDHy+ZiRM8QlFPXAX3CI6PSWQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

(cc linux-api)

(cc linux-arch)

On Sun, 26 Oct 2008 12:41:50 -0400 Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> This patch reintroduces accept4, replacing paccept.  It's easy to see that
> the patch only removes code and then redirects existing code away from the
> removed functions.  Since the paccept code sans signal handling was never
> in question I think there is no reason to quarantine the patch first.

I'll confess to not having a clue what's going on here.

What is accept4() and why do I want one?  Sigh.  Hopefully others have
been following more closely and have some context.

> I've updated the test program which now looks as follows:

> 
> #include <fcntl.h>
> #include <pthread.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <netinet/in.h>
> #include <sys/socket.h>
> #include <sys/syscall.h>
> 
> #ifdef __x86_64__
> #define __NR_accept4 288
> #define SOCK_CLOEXEC O_CLOEXEC
> #elif __i386__
> #define SYS_ACCEPT4     18
> #define USE_SOCKETCALL 1
> #define SOCK_CLOEXEC O_CLOEXEC
> #else

Well.  This doesn't actually agree with the kernel patch.

>
> ...
>
>  arch/x86/include/asm/unistd_64.h |    4 -
>  include/linux/net.h              |    6 --
>  include/linux/syscalls.h         |    3 -
>  kernel/sys_ni.c                  |    2 
>  net/compat.c                     |   50 ++----------------------
>  net/socket.c                     |   80 ++++-----------------------------------

I'd suggest that i386 is sufficiently common to warrant its inclusion
in the initial patch.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
