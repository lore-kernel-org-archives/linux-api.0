From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v4 4/5] page_idle: Drain all LRU pagevec before idle
 tracking
Date: Tue, 6 Aug 2019 09:48:53 -0400
Message-ID: <20190806134853.GB15167@google.com>
References: <20190805170451.26009-1-joel@joelfernandes.org>
 <20190805170451.26009-4-joel@joelfernandes.org>
 <20190806084357.GK11812@dhcp22.suse.cz>
 <20190806104554.GB218260@google.com>
 <20190806105149.GT11812@dhcp22.suse.cz>
 <20190806111921.GB117316@google.com>
 <20190806114402.GX11812@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190806114402.GX11812@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>, minchan@kernel.org, namhyung@google.com, paulmck@linux.ibm.com, Robin Murphy <robin.murphy@arm.com>, Roman Gushchin <guro@fb.com>, Stephen Rothwell <sfr@canb.a>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2019 at 01:44:02PM +0200, Michal Hocko wrote:
[snip]
> > > > This operation even if expensive is only done once during the access of the
> > > > page_idle file. Did you have a better fix in mind?
> > > 
> > > Can we set the idle bit also for non-lru pages as long as they are
> > > reachable via pte?
> > 
> > Not at the moment with the current page idle tracking code. PageLRU(page)
> > flag is checked in page_idle_get_page().
> 
> yes, I am aware of the current code. I strongly suspect that the PageLRU
> check was there to not mark arbitrary page looked up by pfn with the
> idle bit because that would be unexpected. But I might be easily wrong
> here.

Yes, quite possible.

> > Even if we could set it for non-LRU, the idle bit (page flag) would not be
> > cleared if page is not on LRU because page-reclaim code (page_referenced() I
> > believe) would not clear it.
> 
> Yes, it is either reclaim when checking references as you say but also
> mark_page_accessed. I believe the later might still have the page on the
> pcp LRU add cache. Maybe I am missing something something but it seems
> that there is nothing fundamentally requiring the user mapped page to be
> on the LRU list when seting the idle bit.
> 
> That being said, your big hammer approach will work more reliable but if
> you do not feel like changing the underlying PageLRU assumption then
> document that draining should be removed longterm.

Yes, at the moment I am in preference of keeping the underlying assumption
same. I am Ok with adding of a comment on the drain call that it is to be
removed longterm.

thanks,

 - Joel
