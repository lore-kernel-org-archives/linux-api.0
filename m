From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Thu, 18 Oct 2018 09:00:31 +0200
Message-ID: <20181018070031.GW18839@dhcp22.suse.cz>
References: <alpine.DEB.2.21.1810040209130.113459@chino.kir.corp.google.com>
 <20181004094637.GG22173@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810041130380.12951@chino.kir.corp.google.com>
 <20181009083326.GG8528@dhcp22.suse.cz>
 <20181015150325.GN18839@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810151519250.247641@chino.kir.corp.google.com>
 <20181016104855.GQ18839@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810161416540.83080@chino.kir.corp.google.com>
 <20181017070531.GC18839@dhcp22.suse.cz>
 <alpine.DEB.2.21.1810171256330.60837@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1810171256330.60837@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 17-10-18 12:59:18, David Rientjes wrote:
> On Wed, 17 Oct 2018, Michal Hocko wrote:
> 
> > Do you know of any other userspace except your usecase? Is there
> > anything fundamental that would prevent a proper API adoption for you?
> > 
> 
> Yes, it would require us to go back in time and build patched binaries. 

I read that as there is a fundamental problem to update existing
binaries. If that is the case then there surely is no way around it
and another sad page in the screwed up APIs book we provide.

But I was under impression that the SW stack which actually does the
monitoring is under your controll. Moreover I was under impression that
you do not use the current vanilla kernel so there is no need for an
immediate change on your end. It is trivial to come up with a backward
compatible way to check for the new flag (if it is not present then
fallback to vma flags).

I am sorry for pushing here but if this is just a matter of a _single_
user which _can_ be fixed with a reasonable effort then I would love to
see the future api unscrewed.
-- 
Michal Hocko
SUSE Labs
