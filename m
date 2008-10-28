From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] reintroduce accept4
Date: Mon, 27 Oct 2008 21:52:49 -0700
Message-ID: <20081027215249.dca00b6b.akpm@linux-foundation.org>
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
	<20081027204135.a139704e.akpm@linux-foundation.org>
	<490693A3.9070805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <490693A3.9070805-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

(really does cc linux-arch this time)

On Mon, 27 Oct 2008 21:22:59 -0700 Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Andrew Morton wrote:
> > I'll confess to not having a clue what's going on here.
> 
> It has been discussed at length.

That's of little use to people trying to understand the git commit.

And it's of little use to people who write the documentation. 
Hopefully Michael has been following this closely enough to get by with
what we have here (ie: nothing).

And it's of little use to people who are trying to review this patch
and who haven't followed this alleged lengthy discussion. (ie: me)

And it's of little use to people who write for sites such as lwn.net,
http://kernelnewbies.org/LinuxChanges etc.

This is not some personal weekend hack project.  It is the Linux
kernel, used by millions around the world.

>  accept created file descriptors and we
> need flags for tis.
> 
> >> #elif __i386__
> >> #define SYS_ACCEPT4     18
> >> #define USE_SOCKETCALL 1
> >> #define SOCK_CLOEXEC O_CLOEXEC
> >> #else
> > 
> > Well.  This doesn't actually agree with the kernel patch.
> 
> What doesn't agree?
> 
> 
> > I'd suggest that i386 is sufficiently common to warrant its inclusion
> > in the initial patch.
> 
> The x86 code is included.  x86 uses socketcall instead of a syscall.

<wonders why arch/x86/include/asm/unistd_64.h defines
__ARCH_WANT_SYS_SOCKETCALL but doesn't wire up sys_socketcall()>

> I changed all paccept occurrences in the tree, not just x86-64.

OK, that covered a lot of architectures.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
