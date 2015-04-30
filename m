From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/3] proc: add kpageidle file
Date: Thu, 30 Apr 2015 15:55:33 +0900
Message-ID: <20150430065533.GC21771@blaptop>
References: <cover.1430217477.git.vdavydov@parallels.com>
 <4c24a6bf2c9711dd4dbb72a43a16eba6867527b7.1430217477.git.vdavydov@parallels.com>
 <20150429045759.GA27051@blaptop>
 <20150429083148.GA11497@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150429083148.GA11497@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On Wed, Apr 29, 2015 at 11:31:49AM +0300, Vladimir Davydov wrote:
> On Wed, Apr 29, 2015 at 01:57:59PM +0900, Minchan Kim wrote:
> > On Tue, Apr 28, 2015 at 03:24:42PM +0300, Vladimir Davydov wrote:
> > > @@ -69,6 +69,14 @@ There are four components to pagemap:
> > >     memory cgroup each page is charged to, indexed by PFN. Only available when
> > >     CONFIG_MEMCG is set.
> > >  
> > > + * /proc/kpageidle.  For each page this file contains a 64-bit number, which
> > > +   equals 1 if the page is idle or 0 otherwise, indexed by PFN. A page is
> > > +   considered idle if it has not been accessed since it was marked idle. To
> > > +   mark a page idle one should write 1 to this file at the offset corresponding
> > > +   to the page. Only user memory pages can be marked idle, for other page types
> > > +   input is silently ignored. Writing to this file beyond max PFN results in
> > > +   the ENXIO error. Only available when CONFIG_IDLE_PAGE_TRACKING is set.
> > > +
> > 
> > How about using kpageflags for reading part?
> > 
> > I mean PG_idle is one of the page flags and we already have a feature to
> > parse of each PFN flag so we could reuse existing feature for reading
> > idleness.
> 
> Reading PG_idle implies clearing all pte references to make sure the
> page was not referenced via a pte. This means that exporting it via
> /proc/kpageflags would increase the cost of reading this file, even for
> users that don't care about PG_idle. I'm not sure all users of
> /proc/kpageflags will be fine with it.

It triggers rmap traverse so it would be horrible overhead sometime
so I agree every kpageflags users don't want it but I didn't mean
reading of PG_idle via kpageflags should clear all pte references.
Reset should be still part of kpageidle but we can just read idlenss
without reset by kpageflags(IOW, Reset and reading is orthogoal)

A benefit via reading kpageflags, we could parse it's idle page
and not dirty page so we could reclaim it easy.
Anyway, it could be further improvement.

> 
> Thanks,
> Vladimir

-- 
Kind regards,
Minchan Kim
