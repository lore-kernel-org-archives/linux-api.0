From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] generic syscalls: kill cruft from removed pkey syscalls
Date: Mon, 17 Oct 2016 17:37:29 +0200
Message-ID: <5993847.hpzj164ak1@wuerfel>
References: <20161017151814.1CE8B6C3@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017151814.1CE8B6C3-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Monday, October 17, 2016 8:18:15 AM CEST Dave Hansen wrote:
> 
> pkey_set() and pkey_get() were syscalls present in older versions
> of the protection keys patches.  They were fully excised from the
> x86 code, but some cruft was left in the generic syscall code.  The
> C++ comments were intended to help to make it more glaring to me to
> fix them before actually submitting them.  That technique worked,
> but later than I would have liked.
> 
> I test-compiled this for arm64.
> 
> Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
> Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
> Fixes: a60f7b69d92c0 ("generic syscalls: Wire up memory protection keys syscalls")

Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
