From: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Subject: Re: [PATCH 6/9] x86, pkeys: add pkey set/get syscalls
Date: Fri, 8 Jul 2016 11:22:28 +0100
Message-ID: <20160708102228.GF11498@techsingularity.net>
References: <20160707124719.3F04C882@viggo.jf.intel.com>
 <20160707124728.C1116BB1@viggo.jf.intel.com>
 <20160707144508.GZ11498@techsingularity.net>
 <577E924C.6010406@sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <577E924C.6010406-gkUM19QKKo4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 07, 2016 at 10:33:00AM -0700, Dave Hansen wrote:
> On 07/07/2016 07:45 AM, Mel Gorman wrote:
> > On Thu, Jul 07, 2016 at 05:47:28AM -0700, Dave Hansen wrote:
> >> > 
> >> > From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >> > 
> >> > This establishes two more system calls for protection key management:
> >> > 
> >> > 	unsigned long pkey_get(int pkey);
> >> > 	int pkey_set(int pkey, unsigned long access_rights);
> >> > 
> >> > The return value from pkey_get() and the 'access_rights' passed
> >> > to pkey_set() are the same format: a bitmask containing
> >> > PKEY_DENY_WRITE and/or PKEY_DENY_ACCESS, or nothing set at all.
> >> > 
> >> > These can replace userspace's direct use of the new rdpkru/wrpkru
> >> > instructions.
> ...
> > This one feels like something that can or should be implemented in
> > glibc.
> 
> I generally agree, except that glibc doesn't have any visibility into
> whether a pkey is currently valid or not.
> 

Well, it could if it tracked the pkey_alloc/pkey_free calls too. I accept
that's not perfect as nothing prevents the syscalls being used directly.

> > Applications that frequently get
> > called will get hammed into the ground with serialisation on mmap_sem
> > not to mention the cost of the syscall entry/exit.
> 
> I think we can do both of them without mmap_sem, as long as we resign
> ourselves to this just being fundamentally racy (which it is already, I
> think).  But, is it worth performance-tuning things that we don't expect
> performance-sensitive apps to be using in the first place?  They'll just
> use the RDPKRU/WRPKRU instructions directly.
> 

I accept the premature optimisation arguement but I think it'll eventually
bite us. Why this red-flagged for me was because so many people have
complained about just system call overhead when using particular types of
hardware -- DAX springs to mind with the MAP_PMEM_AWARE discussions. Using
mmap_sem means that pkey operations stop parallel faults, mmaps and so on. If
the applications that care are trying to minimise page table operations,
TLB flushes and so on, they might not be that happy if parallel faults
are stalled.

I think whether you serialise pkey_get/pkey_set operations or not, it's
going to be inherently racy with different sized windows. A sequence counter
would be sufficient to protect it to prevent partial reads. If userspace
cares about the race, then userspace is going to have to serialise its
threads access to the keys anyway.

-- 
Mel Gorman
SUSE Labs
