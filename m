From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Mon, 20 Jan 2020 16:44:47 +0100
Message-ID: <20200120154447.GL18451@dhcp22.suse.cz>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <f57fb198-4070-d3b4-b6bd-43b29ff40a2c@virtuozzo.com>
 <20200120112722.GY18451@dhcp22.suse.cz>
 <20200120123935.onlls7enjtzenbvt@box>
 <20200120132405.GF18451@dhcp22.suse.cz>
 <20200120142132.srf4igph4zmecu7b@box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200120142132.srf4igph4zmecu7b@box>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, sjpark-ebkRAfMGSJGzQB+pC5nmwQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 20-01-20 17:21:32, Kirill A. Shutemov wrote:
> On Mon, Jan 20, 2020 at 02:24:05PM +0100, Michal Hocko wrote:
> > On Mon 20-01-20 15:39:35, Kirill A. Shutemov wrote:
> > > On Mon, Jan 20, 2020 at 12:27:22PM +0100, Michal Hocko wrote:
> > > > On Mon 20-01-20 13:24:35, Kirill Tkhai wrote:
> > [...]
> > > > > Even two threads on common memory need a synchronization
> > > > > to manage mappings in a sane way. Managing memory from two processes
> > > > > is the same in principle, and the only difference is that another level
> > > > > of synchronization is required.
> > > > 
> > > > Well, not really. The operation might simply attempt to perform an
> > > > operation on a specific memory area and get a failure if it doesn't
> > > > reference the same object anymore. What I think we need is some form of
> > > > a handle to operate on. In the past we have discussed several
> > > > directions. I was proposing /proc/self/map_anon/ (analogous to
> > > > map_files) where you could inspect anonymous memory and get a file
> > > > handle for it. madvise would then operate on the fd and then there
> > > > shouldn't be a real problem to revalidate that the object is still
> > > > valid. But there was no general enthusiasm about that approach. There
> > > > are likely some land mines on the way.
> > > 
> > > Converting anon memory to file-backed is bad idea and going to backfire.
> > 
> > I didn't mean to convert. I meant to expose that information via proc
> > the same way we do for file backed mappings. That shouldn't really
> > require to re-design the way how anonymous vma work IMO. But I haven't
> > tried that so there might be many gotchas there.
> > 
> > There are obvious things to think about though. Such fd cannot be sent
> > to other processes (SCM stuff), mmap of the file would have to be
> > disallowed and many others I am not aware of. I am not even pushing this
> > direction because I am not convinced about how viable it is myself. But
> > it would sound like a nice extension of the existing mechanism we have
> > and a file based madvise sounds attractive to me as well because we
> > already have that.
> 
> If the fd cannot be passed around or mmaped what does it represent?

Because it is a cookie maintained by the kernel.

> And how is it different from plain address?

Kernel can revalidate that the given fd is denoting the vma it was
created for and simply fail with ENOENT or whatever suits if somebody
did unmap and mmap to the same address.
-- 
Michal Hocko
SUSE Labs
