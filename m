From: Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: only enable sys_pkey* when ARCH_HAS_PKEYS
Date: Tue, 8 Nov 2016 12:24:01 +0100
Message-ID: <20161108112400.GE3528@osiris>
References: <1477958904-9903-1-git-send-email-mark.rutland@arm.com>
 <c716d515-409f-4092-73d2-1a81db6c1ba3@linux.intel.com>
 <20161104234459.GA18760@remoulade>
 <20161108093042.GC3528@osiris>
 <20161108104112.GM1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161108104112.GM1041-l+eeeJia6m9URfEZ8mYm6t73F7V6hmMc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 08, 2016 at 10:41:12AM +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 08, 2016 at 10:30:42AM +0100, Heiko Carstens wrote:
> > Two architectures (arm, mips) have wired them up and thus allocated system
> > call numbers, even though they don't have ARCH_HAS_PKEYS set. Which seems a
> > bit pointless.
> 
> I don't think it's pointless at all.  First, read the LWN article for
> the userspace side of the interface: https://lwn.net/Articles/689395/
> 
> From reading this, it seems (at least to me) that these pkey syscalls
> are going to be the application level API - which means applications
> are probably going to want to make these calls.
> 
> Sure, they'll have to go through glibc, and glibc can provide stubs,
> but the problem with that is if we do get hardware pkey support (eg,
> due to pressure to increase security) then we're going to end up
> needing both kernel changes and glibc changes to add the calls.
> 
> Since one of the design goals of pkeys is to allow them to work when
> there is no underlying hardware support, I see no reason not to wire
> them up in architecture syscall tables today, so that we have a cross-
> architecture kernel version where the pkey syscalls become available.
> glibc (and other libcs) don't then have to mess around with per-
> architecture recording of which kernel version the pkey syscalls were
> added.
> 
> Not wiring up the syscalls doesn't really gain anything: the code
> present when !ARCH_HAS_PKEYS will still be part of the kernel image,
> it just won't be callable.

That can be easily solved (see below).

> So, on balance, I've decided to wire them up on ARM, even though the
> hardware doesn't support them, to avoid unnecessary pain in userspace
> from the ARM side of things.
> 
> Obviously what other architectures do is their own business.

It would make sense if this would be handled the same across architectures.

We could simply ifdef the small pkey block in mprotect.c and rely on the
pkey cond_syscalls added with e2753293ac4b. The result would actually be
the same what Mark proposed, except with less generated code.

Something like this:

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 11936526b08b..9fb86b107e49 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -484,6 +484,8 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 	return do_mprotect_pkey(start, len, prot, -1);
 }
 
+#ifdef CONFIG_ARCH_HAS_PKEYS
+
 SYSCALL_DEFINE4(pkey_mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot, int, pkey)
 {
@@ -534,3 +536,4 @@ SYSCALL_DEFINE1(pkey_free, int, pkey)
 	 */
 	return ret;
 }
+#endif /* CONFIG_ARCH_HAS_PKEYS */
