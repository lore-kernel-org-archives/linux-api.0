From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 21:52:10 +0100
Message-ID: <20171127205210.zmah36uliajnbjon@dhcp22.suse.cz>
References: <23066.59196.909026.689706@gargle.gargle.HOWL>
 <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
 <87vahv8whv.fsf@linux.intel.com>
 <20171127183218.33zm666jw3uqkxdq@dhcp22.suse.cz>
 <20171127195732.3hkfx57d3ytyccvp@dhcp22.suse.cz>
 <20171127202121.GB3070@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171127202121.GB3070@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: Mikael Pettersson <mikpelinux@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 27-11-17 12:21:21, Andi Kleen wrote:
> On Mon, Nov 27, 2017 at 08:57:32PM +0100, Michal Hocko wrote:
> > On Mon 27-11-17 19:32:18, Michal Hocko wrote:
> > > On Mon 27-11-17 09:25:16, Andi Kleen wrote:
> > [...]
> > > > The reason the limit was there originally because it allows a DoS
> > > > attack against the kernel by filling all unswappable memory up with VMAs.
> > > 
> > > We can reduce the effect by accounting vmas to memory cgroups.
> > 
> > As it turned out we already do.
> > 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);
> 
> That only helps if you have memory cgroups enabled. It would be a regression
> to break the accounting on all the systems that don't.

I agree. And I didn't say we should remove the existing limit. I am just
saying that we can reduce existing problems by increasing the limit and
relying on memcg accounting where possible.
-- 
Michal Hocko
SUSE Labs
