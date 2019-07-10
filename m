From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 4/5] mm: introduce MADV_PAGEOUT
Date: Wed, 10 Jul 2019 13:16:22 +0200
Message-ID: <20190710111622.GI29695@dhcp22.suse.cz>
References: <20190627115405.255259-1-minchan@kernel.org>
 <20190627115405.255259-5-minchan@kernel.org>
 <20190709095518.GF26380@dhcp22.suse.cz>
 <20190710104809.GA186559@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190710104809.GA186559@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, Dave Hansen <dave.hansen@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed 10-07-19 19:48:09, Minchan Kim wrote:
> On Tue, Jul 09, 2019 at 11:55:19AM +0200, Michal Hocko wrote:
[...]
> > I am still not convinced about the SWAP_CLUSTER_MAX batching and the
> > udnerlying OOM argument. Is one pmd worth of pages really an OOM risk?
> > Sure you can have many invocations in parallel and that would add on
> > but the same might happen with SWAP_CLUSTER_MAX. So I would just remove
> > the batching for now and think of it only if we really see this being a
> > problem for real. Unless you feel really strong about this, of course.
> 
> I don't have the number to support SWAP_CLUSTER_MAX batching for hinting
> operations. However, I wanted to be consistent with other LRU batching
> logic so that it could affect altogether if someone try to increase
> SWAP_CLUSTER_MAX which is more efficienty for batching operation, later.
> (AFAIK, someone tried it a few years ago but rollback soon, I couldn't
> rebemeber what was the reason at that time, anyway).

Then please drop this part. It makes the code more complex while any
benefit is not demonstrated.

> > Anyway the patch looks ok to me otherwise.
> > 
> > Acked-by: Michal Hocko <mhocko@suse.co>
> 
> Thanks!

-- 
Michal Hocko
SUSE Labs
