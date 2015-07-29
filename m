From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v9 0/8] idle memory tracking
Date: Wed, 29 Jul 2015 17:45:39 +0300
Message-ID: <20150729144539.GU8100@esperanza>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <20150729123629.GI15801@dhcp22.suse.cz>
 <20150729135907.GT8100@esperanza>
 <CANN689HJX2ZL891uOd8TW9ct4PNH9d5odQZm86WMxkpkCWhA-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANN689HJX2ZL891uOd8TW9ct4PNH9d5odQZm86WMxkpkCWhA-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 29, 2015 at 07:12:13AM -0700, Michel Lespinasse wrote:
> On Wed, Jul 29, 2015 at 6:59 AM, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> wrote:
> >> I guess the primary reason to rely on the pfn rather than the LRU walk,
> >> which would be more targeted (especially for memcg cases), is that we
> >> cannot hold lru lock for the whole LRU walk and we cannot continue
> >> walking after the lock is dropped. Maybe we can try to address that
> >> instead? I do not think this is easy to achieve but have you considered
> >> that as an option?
> >
> > Yes, I have, and I've come to a conclusion it's not doable, because LRU
> > lists can be constantly rotating at an arbitrary rate. If you have an
> > idea in mind how this could be done, please share.
> >
> > Speaking of LRU-vs-PFN walk, iterating over PFNs has its own advantages:
> >  - You can distribute a walk in time to avoid CPU bursts.
> >  - You are free to parallelize the scanner as you wish to decrease the
> >    scan time.
> 
> There is a third way: one could go through every MM in the system and scan
> their page tables. Doing things that way turns out to be generally faster
> than scanning by physical address, because you don't have to go through
> RMAP for every page. But, you end up needing to take the mmap_sem lock of
> every MM (in turn) while scanning them, and that degrades quickly under
> memory load, which is exactly when you most need this feature. So, scan by
> address is still what we use here.

Page table scan approach has the inherent problem - it ignores unmapped
page cache. If a workload does a lot of read/write or map-access-unmap
operations, we won't be able to even roughly estimate its wss.

Thanks,
Vladimir
