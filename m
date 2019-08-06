From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v4 3/5] [RFC] arm64: Add support for idle bit in swap PTE
Date: Tue, 6 Aug 2019 13:14:52 +0200
Message-ID: <20190806111452.GW11812@dhcp22.suse.cz>
References: <20190805170451.26009-1-joel@joelfernandes.org>
 <20190805170451.26009-3-joel@joelfernandes.org>
 <20190806084203.GJ11812@dhcp22.suse.cz>
 <20190806103627.GA218260@google.com>
 <20190806104755.GR11812@dhcp22.suse.cz>
 <20190806110737.GB32615@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190806110737.GB32615@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>, linux-kernel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>, namhyung@google.com, paulmck@linux.ibm.com, Roman Gushchin <guro@fb.com>, Stephen
List-Id: linux-api@vger.kernel.org

On Tue 06-08-19 20:07:37, Minchan Kim wrote:
> On Tue, Aug 06, 2019 at 12:47:55PM +0200, Michal Hocko wrote:
> > On Tue 06-08-19 06:36:27, Joel Fernandes wrote:
> > > On Tue, Aug 06, 2019 at 10:42:03AM +0200, Michal Hocko wrote:
> > > > On Mon 05-08-19 13:04:49, Joel Fernandes (Google) wrote:
> > > > > This bit will be used by idle page tracking code to correctly identify
> > > > > if a page that was swapped out was idle before it got swapped out.
> > > > > Without this PTE bit, we lose information about if a page is idle or not
> > > > > since the page frame gets unmapped.
> > > > 
> > > > And why do we need that? Why cannot we simply assume all swapped out
> > > > pages to be idle? They were certainly idle enough to be reclaimed,
> > > > right? Or what does idle actualy mean here?
> > > 
> > > Yes, but other than swapping, in Android a page can be forced to be swapped
> > > out as well using the new hints that Minchan is adding?
> > 
> > Yes and that is effectivelly making them idle, no?
> 
> 1. mark page-A idle which was present at that time.
> 2. run workload
> 3. page-A is touched several times
> 4. *sudden* memory pressure happen so finally page A is finally swapped out
> 5. now see the page A idle - but it's incorrect.

Could you expand on what you mean by idle exactly? Why pageout doesn't
really qualify as "mark-idle and reclaim"? Also could you describe a
usecase where the swapout distinction really matters and it would lead
to incorrect behavior?

-- 
Michal Hocko
SUSE Labs
