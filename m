From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v4 1/5] mm/page_idle: Add per-pid idle page tracking
 using virtual indexing
Date: Wed, 7 Aug 2019 16:44:49 -0400
Message-ID: <20190807204449.GA90900@google.com>
References: <20190805170451.26009-1-joel@joelfernandes.org>
 <20190806151921.edec128271caccb5214fc1bd@linux-foundation.org>
 <20190807100013.GC169551@google.com>
 <20190807130122.f148548c05ec07e7b716457e@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190807130122.f148548c05ec07e7b716457e@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.ibm.com>, minchan@kernel.org, namhyung@google.com, paulmck@linux.ibm.com, Robin Murphy <robin.murphy@arm.com>, Roman Gushchin <guro@fb.com>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 07, 2019 at 01:01:22PM -0700, Andrew Morton wrote:
> On Wed, 7 Aug 2019 06:00:13 -0400 Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > > > 8 files changed, 376 insertions(+), 45 deletions(-)
> > > 
> > > Quite a lot of new code unconditionally added to major architectures. 
> > > Are we confident that everyone will want this feature?
> > 
> > I did not follow, could you clarify more? All of this diff stat is not to
> > architecture code:
> 
> 
> My point is that the patchset adds a lot of new code with no way in
> which users can opt out.  Almost everyone gets a fatter kernel - how
> many of those users will actually benefit from it?
> 
> If "not many" then shouldn't we be making it Kconfigurable?

Almost all of this code is already configurable with
CONFIG_IDLE_PAGE_TRACKING. If you disable it, then all of this code gets
disabled.

Or are you referring to something else that needs to be made configurable?

> Are there userspace tools which present this info to users or which
> provide monitoring of some form?  Do major distros ship those tools? 
> Do people use them?  etcetera.
> 

Android's heapprofd is what I was working on which is already using it (patch
is not yet upstreamed). There is working set tracking which Sandeep (also
from Android) said he wants to use. Minchan plans to use this in combination
with ZRAM-based idle tracking. Mike Rappoport also showed some interest, but
I am not sure where/how he is using it. These are just some of the usecases I
am aware off. I am pretty sure more will come as well.

thanks,

 - Joel
