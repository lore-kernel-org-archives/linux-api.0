From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3 3/3] proc: add kpageidle file
Date: Wed, 29 Apr 2015 11:31:49 +0300
Message-ID: <20150429083148.GA11497@esperanza>
References: <cover.1430217477.git.vdavydov@parallels.com>
 <4c24a6bf2c9711dd4dbb72a43a16eba6867527b7.1430217477.git.vdavydov@parallels.com>
 <20150429045759.GA27051@blaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150429045759.GA27051@blaptop>
Sender: linux-doc-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 01:57:59PM +0900, Minchan Kim wrote:
> On Tue, Apr 28, 2015 at 03:24:42PM +0300, Vladimir Davydov wrote:
> > @@ -69,6 +69,14 @@ There are four components to pagemap:
> >     memory cgroup each page is charged to, indexed by PFN. Only available when
> >     CONFIG_MEMCG is set.
> >  
> > + * /proc/kpageidle.  For each page this file contains a 64-bit number, which
> > +   equals 1 if the page is idle or 0 otherwise, indexed by PFN. A page is
> > +   considered idle if it has not been accessed since it was marked idle. To
> > +   mark a page idle one should write 1 to this file at the offset corresponding
> > +   to the page. Only user memory pages can be marked idle, for other page types
> > +   input is silently ignored. Writing to this file beyond max PFN results in
> > +   the ENXIO error. Only available when CONFIG_IDLE_PAGE_TRACKING is set.
> > +
> 
> How about using kpageflags for reading part?
> 
> I mean PG_idle is one of the page flags and we already have a feature to
> parse of each PFN flag so we could reuse existing feature for reading
> idleness.

Reading PG_idle implies clearing all pte references to make sure the
page was not referenced via a pte. This means that exporting it via
/proc/kpageflags would increase the cost of reading this file, even for
users that don't care about PG_idle. I'm not sure all users of
/proc/kpageflags will be fine with it.

Thanks,
Vladimir
