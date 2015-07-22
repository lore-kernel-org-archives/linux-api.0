From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v9 7/8] proc: export idle flag via kpageflags
Date: Wed, 22 Jul 2015 19:25:28 +0300
Message-ID: <20150722162528.GN23374@esperanza>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <4c1eb396150ee14d7c3abf1a6f36ec8cc9dd9435.1437303956.git.vdavydov@parallels.com>
 <20150721163500.528bd39bbbc71abc3c8d429b@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150721163500.528bd39bbbc71abc3c8d429b-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 04:35:00PM -0700, Andrew Morton wrote:
> On Sun, 19 Jul 2015 15:31:16 +0300 Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
> > As noted by Minchan, a benefit of reading idle flag from
> > /proc/kpageflags is that one can easily filter dirty and/or unevictable
> > pages while estimating the size of unused memory.
> > 
> > Note that idle flag read from /proc/kpageflags may be stale in case the
> > page was accessed via a PTE, because it would be too costly to iterate
> > over all page mappings on each /proc/kpageflags read to provide an
> > up-to-date value. To make sure the flag is up-to-date one has to read
> > /proc/kpageidle first.
> 
> Is there any value in teaching the regular old page scanner to update
> these flags?  If it's doing an rmap scan anyway...

I don't understand what you mean by "regular old page scanner". Could
you please elaborate?

Thanks,
Vladimir
