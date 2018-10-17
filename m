From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Wed, 17 Oct 2018 09:05:31 +0200
Message-ID: <20181017070531.GC18839@dhcp22.suse.cz>
References: <alpine.DEB.2.21.1810031547150.202532@chino.kir.corp.google.com>
 <20181004055842.GA22173@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810040209130.113459@chino.kir.corp.google.com>
 <20181004094637.GG22173@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810041130380.12951@chino.kir.corp.google.com>
 <20181009083326.GG8528@dhcp22.suse.cz>
 <20181015150325.GN18839@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810151519250.247641@chino.kir.corp.google.com>
 <20181016104855.GQ18839@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810161416540.83080@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1810161416540.83080@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 16-10-18 14:24:19, David Rientjes wrote:
> On Tue, 16 Oct 2018, Michal Hocko wrote:
> 
> > > I don't understand the point of extending smaps with yet another line.  
> > 
> > Because abusing a vma flag part is just wrong. What are you going to do
> > when a next bug report states that the flag is set even though no
> > userspace has set it and that leads to some malfunctioning? Can you rule
> > that out? Even your abuse of the flag is surprising so why others
> > wouldn't be?
> > 
> 
> The flag has taken on the meaning of "thp disabled for this vma", how it 
> is set is not the scope of the flag.  If a thp is explicitly disabled from 
> being eligible for thp, whether by madvise, prctl, or any future 
> mechanism, it should use VM_NOHUGEPAGE or show_smap_vma_flags() needs to 
> be modified.

No, this is not the meaning which is documented

nh  - no-huge page advise flag

and as far as I know it is only you who has complained so far.
 
> > As I've said there are two things. Exporting PR_SET_THP_DISABLE to
> > userspace so that a 3rd party process can query it. I've already
> > explained why that might be useful. If you really insist on having
> > a per-vma field then let's do it properly now. Are you going to agree on
> > that? If yes, I am willing to spend my time on that but I am not going
> > to bother if this will lead to "I want my vma field abuse anyway".
> 
> I think what you and I want is largely irrelevant :)  What's important is 
> that there are userspace implementations that query this today so 
> continuing to support it as the way to determine if a vma has been thp 
> disabled doesn't seem problematic and guarantees that userspace doesn't 
> break.

Do you know of any other userspace except your usecase? Is there
anything fundamental that would prevent a proper API adoption for you?

-- 
Michal Hocko
SUSE Labs
