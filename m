From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v3 0/5] Introduce MADV_COLD and MADV_PAGEOUT
Date: Fri, 28 Jun 2019 08:12:11 +0900
Message-ID: <20190627231211.GA33052@google.com>
References: <20190627115405.255259-1-minchan@kernel.org>
 <20190627180601.xcppuzia3gk57lq2@box>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190627180601.xcppuzia3gk57lq2@box>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, Dave Hansen <dave.hansen@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 27, 2019 at 09:06:01PM +0300, Kirill A. Shutemov wrote:
> On Thu, Jun 27, 2019 at 08:54:00PM +0900, Minchan Kim wrote:
> > - Problem
> > 
> > Naturally, cached apps were dominant consumers of memory on the system.
> > However, they were not significant consumers of swap even though they are
> > good candidate for swap. Under investigation, swapping out only begins
> > once the low zone watermark is hit and kswapd wakes up, but the overall
> > allocation rate in the system might trip lmkd thresholds and cause a cached
> > process to be killed(we measured performance swapping out vs. zapping the
> > memory by killing a process. Unsurprisingly, zapping is 10x times faster
> > even though we use zram which is much faster than real storage) so kill
> > from lmkd will often satisfy the high zone watermark, resulting in very
> > few pages actually being moved to swap.
> 
> Maybe we should look if we do The Right Thing™ at system-wide level before
> introducing new API? How changing swappiness affects your workloads? What
> is swappiness value in your setup?

It was 100. Even, I tried 150 and 200 with simple hack of swappiness.
However, it caused too excessive swpout.

Anyway, systen-level tune is generally good but if process has hint, that
should work better and that's why advise API is.
