From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v4 4/5] page_idle: Drain all LRU pagevec before idle
 tracking
Date: Tue, 6 Aug 2019 06:45:54 -0400
Message-ID: <20190806104554.GB218260@google.com>
References: <20190805170451.26009-1-joel@joelfernandes.org>
 <20190805170451.26009-4-joel@joelfernandes.org>
 <20190806084357.GK11812@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190806084357.GK11812@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>, minchan@kernel.org, namhyung@google.com, paulmck@linux.ibm.com, Robin Murphy <robin.murphy@arm.com>, Roman Gushchin <guro@fb.com>, Stephen Rothwell <sfr@canb.a>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2019 at 10:43:57AM +0200, Michal Hocko wrote:
> On Mon 05-08-19 13:04:50, Joel Fernandes (Google) wrote:
> > During idle tracking, we see that sometimes faulted anon pages are in
> > pagevec but are not drained to LRU. Idle tracking considers pages only
> > on LRU. Drain all CPU's LRU before starting idle tracking.
> 
> Please expand on why does this matter enough to introduce a potentially
> expensinve draining which has to schedule a work on each CPU and wait
> for them to finish.

Sure, I can expand. I am able to find multiple issues involving this. One
issue looks like idle tracking is completely broken. It shows up in my
testing as if a page that is marked as idle is always "accessed" -- because
it was never marked as idle (due to not draining of pagevec).

The other issue shows up as a failure in my "swap test", with the following
sequence:
1. Allocate some pages
2. Write to them
3. Mark them as idle                                    <--- fails
4. Introduce some memory pressure to induce swapping.
5. Check the swap bit I introduced in this series.      <--- fails to set idle
                                                             bit in swap PTE.

Draining the pagevec in advance fixes both of these issues.

This operation even if expensive is only done once during the access of the
page_idle file. Did you have a better fix in mind?

thanks,

 - Joel


> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> >  mm/page_idle.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/mm/page_idle.c b/mm/page_idle.c
> > index a5b00d63216c..2972367a599f 100644
> > --- a/mm/page_idle.c
> > +++ b/mm/page_idle.c
> > @@ -180,6 +180,8 @@ static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
> >  	unsigned long pfn, end_pfn;
> >  	int bit, ret;
> >  
> > +	lru_add_drain_all();
> > +
> >  	ret = page_idle_get_frames(pos, count, NULL, &pfn, &end_pfn);
> >  	if (ret == -ENXIO)
> >  		return 0;  /* Reads beyond max_pfn do nothing */
> > @@ -211,6 +213,8 @@ static ssize_t page_idle_bitmap_write(struct file *file, struct kobject *kobj,
> >  	unsigned long pfn, end_pfn;
> >  	int bit, ret;
> >  
> > +	lru_add_drain_all();
> > +
> >  	ret = page_idle_get_frames(pos, count, NULL, &pfn, &end_pfn);
> >  	if (ret)
> >  		return ret;
> > @@ -428,6 +432,8 @@ ssize_t page_idle_proc_generic(struct file *file, char __user *ubuff,
> >  	walk.private = &priv;
> >  	walk.mm = mm;
> >  
> > +	lru_add_drain_all();
> > +
> >  	down_read(&mm->mmap_sem);
> >  
> >  	/*
> > -- 
> > 2.22.0.770.g0f2c4a37fd-goog
> 
> -- 
> Michal Hocko
> SUSE Labs
