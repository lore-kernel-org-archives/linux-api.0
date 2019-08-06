From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v4 3/5] [RFC] arm64: Add support for idle bit in swap PTE
Date: Tue, 6 Aug 2019 12:47:55 +0200
Message-ID: <20190806104755.GR11812@dhcp22.suse.cz>
References: <20190805170451.26009-1-joel@joelfernandes.org>
 <20190805170451.26009-3-joel@joelfernandes.org>
 <20190806084203.GJ11812@dhcp22.suse.cz>
 <20190806103627.GA218260@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190806103627.GA218260@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>, minchan@kernel.org, namhyung@google.com, paulmck@linux.ibm.com, Roman Gushchin <guro@fb.com>, Stephen Rothwell <sfr@canb.auug.org.>
List-Id: linux-api@vger.kernel.org

On Tue 06-08-19 06:36:27, Joel Fernandes wrote:
> On Tue, Aug 06, 2019 at 10:42:03AM +0200, Michal Hocko wrote:
> > On Mon 05-08-19 13:04:49, Joel Fernandes (Google) wrote:
> > > This bit will be used by idle page tracking code to correctly identify
> > > if a page that was swapped out was idle before it got swapped out.
> > > Without this PTE bit, we lose information about if a page is idle or not
> > > since the page frame gets unmapped.
> > 
> > And why do we need that? Why cannot we simply assume all swapped out
> > pages to be idle? They were certainly idle enough to be reclaimed,
> > right? Or what does idle actualy mean here?
> 
> Yes, but other than swapping, in Android a page can be forced to be swapped
> out as well using the new hints that Minchan is adding?

Yes and that is effectivelly making them idle, no?

> Also, even if they were idle enough to be swapped, there is a chance that they
> were marked as idle and *accessed* before the swapping. Due to swapping, the
> "page was accessed since we last marked it as idle" information is lost. I am
> able to verify this.
> 
> Idle in this context means the same thing as in page idle tracking terms, the
> page was not accessed by userspace since we last marked it as idle (using
> /proc/<pid>/page_idle).

Please describe a usecase and why that information might be useful.

-- 
Michal Hocko
SUSE Labs
