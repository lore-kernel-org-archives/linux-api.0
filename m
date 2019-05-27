From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC] mm/madvise: implement MADV_STOCKPILE (kswapd from
 user space)
Date: Mon, 27 May 2019 16:21:56 +0200
Message-ID: <20190527142156.GE1658@dhcp22.suse.cz>
References: <155895155861.2824.318013775811596173.stgit@buzz>
 <20190527141223.GD1658@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190527141223.GD1658@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Roman Gushchin <guro@fb.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 27-05-19 16:12:23, Michal Hocko wrote:
> [Cc linux-api. Please always cc this list when proposing a new user
>  visible api. Keeping the rest of the email intact for reference]
> 
> On Mon 27-05-19 13:05:58, Konstantin Khlebnikov wrote:
[...]
> > This implements manual kswapd-style memory reclaim initiated by userspace.
> > It reclaims both physical memory and cgroup pages. It works in context of
> > task who calls syscall madvise thus cpu time is accounted correctly.

I do not follow. Does this mean that the madvise always reclaims from
the memcg the process is member of?
-- 
Michal Hocko
SUSE Labs
