From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v9 0/8] idle memory tracking
Date: Wed, 29 Jul 2015 16:59:07 +0300
Message-ID: <20150729135907.GT8100@esperanza>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <20150729123629.GI15801@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150729123629.GI15801-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 29, 2015 at 02:36:30PM +0200, Michal Hocko wrote:
> On Sun 19-07-15 15:31:09, Vladimir Davydov wrote:
> [...]
> > ---- USER API ----
> > 
> > The user API consists of two new proc files:
> 
> I was thinking about this for a while. I dislike the interface.  It is
> quite awkward to use - e.g. you have to read the full memory to check a
> single memcg idleness. This might turn out being a problem especially on
> large machines.

Yes, with this API estimating the wss of a single memory cgroup will
cost almost as much as doing this for the whole system.

Come to think of it, does anyone really need to estimate idleness of one
particular cgroup? If we are doing this for finding an optimal memcg
limits configuration or while considering a load move within a cluster
(which I think are the primary use cases for the feature), we must do it
system-wide to see the whole picture.

> It also provides a very low level information (per-pfn idleness) which
> is inherently racy. Does anybody really require this level of detail?

Well, one might want to do it per-process, obtaining PFNs from
/proc/pid/pagemap.

> 
> I would assume that most users are interested only in a single number
> which tells the idleness of the system/memcg.

Yes, that's what I need it for - estimating containers' wss for setting
their limits accordingly.

> Well, you have mentioned a per-process reclaim but I am quite
> skeptical about this.

This is what Minchan mentioned initially. Personally, I'm not going to
use it per-process, but I wouldn't rule out this use case either.

> 
> I guess the primary reason to rely on the pfn rather than the LRU walk,
> which would be more targeted (especially for memcg cases), is that we
> cannot hold lru lock for the whole LRU walk and we cannot continue
> walking after the lock is dropped. Maybe we can try to address that
> instead? I do not think this is easy to achieve but have you considered
> that as an option?

Yes, I have, and I've come to a conclusion it's not doable, because LRU
lists can be constantly rotating at an arbitrary rate. If you have an
idea in mind how this could be done, please share.

Speaking of LRU-vs-PFN walk, iterating over PFNs has its own advantages:
 - You can distribute a walk in time to avoid CPU bursts.
 - You are free to parallelize the scanner as you wish to decrease the
   scan time.

Thanks,
Vladimir
