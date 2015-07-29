From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH -mm v9 0/8] idle memory tracking
Date: Wed, 29 Jul 2015 17:58:14 +0200
Message-ID: <20150729155814.GO15801@dhcp22.suse.cz>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <20150729123629.GI15801@dhcp22.suse.cz>
 <20150729135907.GT8100@esperanza>
 <CANN689HJX2ZL891uOd8TW9ct4PNH9d5odQZm86WMxkpkCWhA-w@mail.gmail.com>
 <20150729144539.GU8100@esperanza>
 <20150729150855.GM15801@dhcp22.suse.cz>
 <20150729153640.GX8100@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150729153640.GX8100@esperanza>
Sender: linux-doc-owner@vger.kernel.org
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michel Lespinasse <walken@google.com>, Andrew Morton <akpm@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>, Minchan Kim <minchan@kernel.org>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 29-07-15 18:36:40, Vladimir Davydov wrote:
> On Wed, Jul 29, 2015 at 05:08:55PM +0200, Michal Hocko wrote:
> > On Wed 29-07-15 17:45:39, Vladimir Davydov wrote:
[...]
> > > Page table scan approach has the inherent problem - it ignores unmapped
> > > page cache. If a workload does a lot of read/write or map-access-unmap
> > > operations, we won't be able to even roughly estimate its wss.
> > 
> > That page cache is trivially reclaimable if it is clean. If it needs
> > writeback then it is non-idle only until the next writeback. So why does
> > it matter for the estimation?
> 
> Because it might be a part of a workload's working set, in which case
> evicting it will make the workload lag.

My point was that no sane application will rely on the unmaped pagecache
being part of the working set. But you are right that you might have a
more complex load consisting of many applications each doing buffered
IO on the same set of files which might get evicted due to other memory
pressure in the meantime and have a higher latencies. This is where low
limit covering this memory as well might be helpful.

-- 
Michal Hocko
SUSE Labs
