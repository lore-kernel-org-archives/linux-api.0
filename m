From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Mon, 20 Jan 2020 17:21:32 +0300
Message-ID: <20200120142132.srf4igph4zmecu7b@box>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <f57fb198-4070-d3b4-b6bd-43b29ff40a2c@virtuozzo.com>
 <20200120112722.GY18451@dhcp22.suse.cz>
 <20200120123935.onlls7enjtzenbvt@box>
 <20200120132405.GF18451@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200120132405.GF18451@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, christian.brauner@ubuntu.com, sjpark@amazon.de
List-Id: linux-api@vger.kernel.org

On Mon, Jan 20, 2020 at 02:24:05PM +0100, Michal Hocko wrote:
> On Mon 20-01-20 15:39:35, Kirill A. Shutemov wrote:
> > On Mon, Jan 20, 2020 at 12:27:22PM +0100, Michal Hocko wrote:
> > > On Mon 20-01-20 13:24:35, Kirill Tkhai wrote:
> [...]
> > > > Even two threads on common memory need a synchronization
> > > > to manage mappings in a sane way. Managing memory from two processes
> > > > is the same in principle, and the only difference is that another level
> > > > of synchronization is required.
> > > 
> > > Well, not really. The operation might simply attempt to perform an
> > > operation on a specific memory area and get a failure if it doesn't
> > > reference the same object anymore. What I think we need is some form of
> > > a handle to operate on. In the past we have discussed several
> > > directions. I was proposing /proc/self/map_anon/ (analogous to
> > > map_files) where you could inspect anonymous memory and get a file
> > > handle for it. madvise would then operate on the fd and then there
> > > shouldn't be a real problem to revalidate that the object is still
> > > valid. But there was no general enthusiasm about that approach. There
> > > are likely some land mines on the way.
> > 
> > Converting anon memory to file-backed is bad idea and going to backfire.
> 
> I didn't mean to convert. I meant to expose that information via proc
> the same way we do for file backed mappings. That shouldn't really
> require to re-design the way how anonymous vma work IMO. But I haven't
> tried that so there might be many gotchas there.
> 
> There are obvious things to think about though. Such fd cannot be sent
> to other processes (SCM stuff), mmap of the file would have to be
> disallowed and many others I am not aware of. I am not even pushing this
> direction because I am not convinced about how viable it is myself. But
> it would sound like a nice extension of the existing mechanism we have
> and a file based madvise sounds attractive to me as well because we
> already have that.

If the fd cannot be passed around or mmaped what does it represent?
And how is it different from plain address?

-- 
 Kirill A. Shutemov
