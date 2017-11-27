From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 19:32:18 +0100
Message-ID: <20171127183218.33zm666jw3uqkxdq@dhcp22.suse.cz>
References: <23066.59196.909026.689706@gargle.gargle.HOWL>
 <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
 <87vahv8whv.fsf@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87vahv8whv.fsf-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 27-11-17 09:25:16, Andi Kleen wrote:
> Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> >
> > Could you be more explicit about _why_ we need to remove this tunable?
> > I am not saying I disagree, the removal simplifies the code but I do not
> > really see any justification here.
> 
> It's an arbitrary scaling limit on the how many mappings the process
> has. The more memory you have the bigger a problem it is. We've
> ran into this problem too on larger systems.

Why cannot you increase the limit?

> The reason the limit was there originally because it allows a DoS
> attack against the kernel by filling all unswappable memory up with VMAs.

We can reduce the effect by accounting vmas to memory cgroups.
-- 
Michal Hocko
SUSE Labs
