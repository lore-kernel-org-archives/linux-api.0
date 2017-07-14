From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/9] mm, page_alloc: rip out ZONELIST_ORDER_ZONE
Date: Fri, 14 Jul 2017 15:08:42 +0200
Message-ID: <20170714130841.GR2618@dhcp22.suse.cz>
References: <20170714080006.7250-1-mhocko@kernel.org>
 <20170714080006.7250-2-mhocko@kernel.org>
 <20170714093650.l67vbem2g4typkta@suse.de>
 <20170714104756.GD2618@dhcp22.suse.cz>
 <20170714111633.gk5rpu2d5ghkbrrd@suse.de>
 <20170714113840.GI2618@dhcp22.suse.cz>
 <20170714125616.clbp4ezgtoon6cmk@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170714125616.clbp4ezgtoon6cmk@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri 14-07-17 13:56:16, Mel Gorman wrote:
> Also strongly suggest you continue using proc_dostring because it
> catches all the corner-cases that can occur.

proc_dostring would need a data in sysctl table and I found that more
confusing than having a simplistic read/write. I can do that if you
insist though.
-- 
Michal Hocko
SUSE Labs
