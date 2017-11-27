From: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 12:21:21 -0800
Message-ID: <20171127202121.GB3070@tassilo.jf.intel.com>
References: <23066.59196.909026.689706@gargle.gargle.HOWL>
 <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
 <87vahv8whv.fsf@linux.intel.com>
 <20171127183218.33zm666jw3uqkxdq@dhcp22.suse.cz>
 <20171127195732.3hkfx57d3ytyccvp@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171127195732.3hkfx57d3ytyccvp-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 08:57:32PM +0100, Michal Hocko wrote:
> On Mon 27-11-17 19:32:18, Michal Hocko wrote:
> > On Mon 27-11-17 09:25:16, Andi Kleen wrote:
> [...]
> > > The reason the limit was there originally because it allows a DoS
> > > attack against the kernel by filling all unswappable memory up with VMAs.
> > 
> > We can reduce the effect by accounting vmas to memory cgroups.
> 
> As it turned out we already do.
> 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);

That only helps if you have memory cgroups enabled. It would be a regression
to break the accounting on all the systems that don't.

-Andi
