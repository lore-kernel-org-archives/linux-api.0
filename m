From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/9] x86, pkeys: add pkey set/get syscalls
Date: Mon, 18 Jul 2016 13:12:17 -0700
Message-ID: <578D3821.4050705@intel.com>
References: <20160707124719.3F04C882@viggo.jf.intel.com>
 <20160707124728.C1116BB1@viggo.jf.intel.com>
 <20160707144508.GZ11498@techsingularity.net> <577E924C.6010406@sr71.net>
 <20160708071810.GA27457@gmail.com> <577FD587.6050101@sr71.net>
 <20160709083715.GA29939@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160709083715.GA29939-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/09/2016 01:37 AM, Ingo Molnar wrote:
>  - There are 16 pkey indices on x86 currently. We already use index 15 for the 
>    true PROT_EXEC implementation. Let's set aside another pkey index for the 
>    kernel's potential future use (index 14), and clear it explicitly in the 
>    FPU context on every context switch if CONFIG_X86_DEBUG_FPU is enabled to make 
>    sure it remains unallocated.

After mulling over this for a week: I really don't think we want to
pre-reserve any keys.

The one bit of consistent feedback I've heard from the folks that are
going to use this is that they want more keys.  The current code does
not reserve any keys (except 0 of course).

Virtually every feature that we've talked about adding on top of this
_requires_ having this allocation mechanism and kernel knowledge of
which keys are in use.  Even having kernel-reserved keys requires
telling userspace about allocation, whether we use pkey_mprotect() for
it or not.

I'd like to resubmit this set with pkey_get/set() removed, but with
pkey_alloc/free() still in place.

Why are folks so sensitive to the number of keys?  There are a few modes
this will get used in when folks want more pkeys that hardware provides.
 Both of them are harmed in a meaningful way if we take some of their
keys away.  Here's how they will use pkeys:
1. As an accelerator for existing mprotect()-provided guarantees.
   Let's say you want 100 pieces of data, but you only get 15 pkeys in
   hardware.  The app picks the 15 most-frequently accessed pieces, and
   uses pkeys to control access to them, and uses mprotect() for the
   other 85.  Each pkey you remove means a smaller "working set"
   covered by pkeys, more mprotect()s and lower performance.
2. To provide stronger access guarantees.  Let's say you have 100
   pieces of data.  To access a given piece of data, you hash its key
   in to a pkey: hash(92)%NR_PKEYS.  Accessing a random bit of data,
   you have a 1/NR_PKEYS chance of a hash collision and access to data
   you should not have access to.  Fewer keys means more data
   corruption.  Losing 2/16 keys means a 15% greater chance of a
   collision on a given access.
