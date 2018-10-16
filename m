From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Tue, 16 Oct 2018 12:48:55 +0200
Message-ID: <20181016104855.GQ18839@dhcp22.suse.cz>
References: <alpine.DEB.2.21.1810021329260.87409@chino.kir.corp.google.com>
 <20181003073640.GF18290@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810031547150.202532@chino.kir.corp.google.com>
 <20181004055842.GA22173@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810040209130.113459@chino.kir.corp.google.com>
 <20181004094637.GG22173@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810041130380.12951@chino.kir.corp.google.com>
 <20181009083326.GG8528@dhcp22.suse.cz>
 <20181015150325.GN18839@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810151519250.247641@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1810151519250.247641@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 15-10-18 15:25:14, David Rientjes wrote:
> On Mon, 15 Oct 2018, Michal Hocko wrote:
> 
> > > > No, because the offending commit actually changed the precedence itself: 
> > > > PR_SET_THP_DISABLE used to be honored for future mappings and the commit 
> > > > changed that for all current mappings.
> > > 
> > > Which is the actual and the full point of the fix as described in the
> > > changelog. The original implementation was poor and inconsistent.
> > > 
> > > > So as a result of the commit 
> > > > itself we would have had to change the documentation and userspace can't 
> > > > be expected to keep up with yet a fourth variable: kernel version.  It 
> > > > really needs to be simpler, just a per-mapping specifier.
> > > 
> > > As I've said, if you really need a per-vma granularity then make it a
> > > dedicated line in the output with a clear semantic. Do not make VMA
> > > flags even more confusing.
> > 
> > Can we settle with something please?
> 
> I don't understand the point of extending smaps with yet another line.  

Because abusing a vma flag part is just wrong. What are you going to do
when a next bug report states that the flag is set even though no
userspace has set it and that leads to some malfunctioning? Can you rule
that out? Even your abuse of the flag is surprising so why others
wouldn't be?

> The only way for a different process to determine if a single vma from 
> another process is thp disabled is by the "nh" flag, so it is reasonable 
> that userspace reads this.  My patch fixes that.  If smaps is extended 
> with another line per your patch, it doesn't change the fact that previous 
> binaries are built to check for "nh" so it does not deprecate that.  
> ("THP_Enabled" is also ambiguous since it only refers to prctl and not the 
> default thp setting or madvise.)

As I've said there are two things. Exporting PR_SET_THP_DISABLE to
userspace so that a 3rd party process can query it. I've already
explained why that might be useful. If you really insist on having
a per-vma field then let's do it properly now. Are you going to agree on
that? If yes, I am willing to spend my time on that but I am not going
to bother if this will lead to "I want my vma field abuse anyway".
-- 
Michal Hocko
SUSE Labs
