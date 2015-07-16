From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v8 0/7] idle memory tracking
Date: Thu, 16 Jul 2015 13:02:11 +0300
Message-ID: <20150716100211.GC2001@esperanza>
References: <cover.1436967694.git.vdavydov@parallels.com>
 <CAJu=L59MjY4F4G2bZh+hrt7aqw3R9mWPeYK65smQWUvMhz85aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJu=L59MjY4F4G2bZh+hrt7aqw3R9mWPeYK65smQWUvMhz85aA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 15, 2015 at 01:47:15PM -0700, Andres Lagar-Cavilla wrote:
> I think the remaining question here is performance.
> 
> Have you conducted any studies where
> - there is a workload
> - a daemon is poking kpageidle every N seconds/minutes
> - what is the daemon cpu consumption?
> - what is the workload degradation if any?
> 
> N candidates include 30 seconds, 1 minute, 2 minutes, 5 minutes....
> 
> Workload candidates include TPC, spec int memory intensive things like
> 429.mcf, stream (http://www.cs.virginia.edu/stream/ "sustainable
> memory bandwidth" vs floating point performance)
> 
> I'm not asking for a research paper, but if, say, a 2 minute-period
> daemon introduces no degradation and adds up to a minute of cpu per
> hour, then we're golden.

Fair enough. Will do that soon and report back.

Thanks a lot for the review, it was really helpful!

Vladimir
