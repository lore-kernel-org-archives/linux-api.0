From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH 0/3] idle memory tracking
Date: Tue, 24 Mar 2015 10:45:45 +0300
Message-ID: <20150324074545.GA4963@esperanza>
References: <cover.1426706637.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1426706637.git.vdavydov@parallels.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 18, 2015 at 11:44:33PM +0300, Vladimir Davydov wrote:
> Usage:
> 
>  1. Write 1 to /proc/sys/vm/set_idle.
> 
>     This will set the IDLE flag for all user pages. The IDLE flag is cleared
>     when the page is read or the ACCESS/YOUNG bit is cleared in any PTE pointing
>     to the page. It is also cleared when the page is freed.
> 
>  2. Wait some time.
> 
>  3. Write 6 to /proc/PID/clear_refs for each PID of interest.
> 
>     This will clear the IDLE flag for recently accessed pages.
> 
>  4. Count the number of idle pages as reported by /proc/kpageflags. One may use
>     /proc/PID/pagemap and/or /proc/kpagecgroup to filter pages that belong to a
>     certain application/container.

Any more thoughts on this? I am particularly interested in the user
interface. I think that /proc/kpagecgroup is OK, but I have my
reservations about using /proc/sys/vm/set_idle and /proc/PID/clear_refs
for setting and clearing the idle flag. The point is it is impossible to
scan memory for setting/clearing page idle flags in the background with
some predefined rate - one has to scan it all at once, which might
result in CPU load spikes on huge machines with TBs of RAM. May be, we'd
better introduce /proc/sys/vm/{set_idle,clear_refs_idle}, which would
receive pfn range to set/clear idle flags?

Any thoughts/ideas are more than welcome.

Thanks,
Vladimir
