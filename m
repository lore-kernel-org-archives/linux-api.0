From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC 6/7] mm: extend process_madvise syscall to support vector arrary
Date: Wed, 29 May 2019 03:08:32 -0700
Message-ID: <CAKOZuesK-8zrm1zua4dzqh4TEMivsZKiccySMvfBjOyDkg-MEw@mail.gmail.com>
References: <20190520035254.57579-1-minchan@kernel.org> <20190520035254.57579-7-minchan@kernel.org>
 <20190520092258.GZ6836@dhcp22.suse.cz> <20190521024820.GG10039@google.com>
 <20190521062421.GD32329@dhcp22.suse.cz> <20190521102613.GC219653@google.com>
 <20190521103726.GM32329@dhcp22.suse.cz> <20190527074940.GB6879@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527074940.GB6879@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 27, 2019 at 12:49 AM Minchan Kim <minchan@kernel.org> wrote:
>
> On Tue, May 21, 2019 at 12:37:26PM +0200, Michal Hocko wrote:
> > On Tue 21-05-19 19:26:13, Minchan Kim wrote:
> > > On Tue, May 21, 2019 at 08:24:21AM +0200, Michal Hocko wrote:
> > > > On Tue 21-05-19 11:48:20, Minchan Kim wrote:
> > > > > On Mon, May 20, 2019 at 11:22:58AM +0200, Michal Hocko wrote:
> > > > > > [Cc linux-api]
> > > > > >
> > > > > > On Mon 20-05-19 12:52:53, Minchan Kim wrote:
> > > > > > > Currently, process_madvise syscall works for only one address range
> > > > > > > so user should call the syscall several times to give hints to
> > > > > > > multiple address range.
> > > > > >
> > > > > > Is that a problem? How big of a problem? Any numbers?
> > > > >
> > > > > We easily have 2000+ vma so it's not trivial overhead. I will come up
> > > > > with number in the description at respin.
> > > >
> > > > Does this really have to be a fast operation? I would expect the monitor
> > > > is by no means a fast path. The system call overhead is not what it used
> > > > to be, sigh, but still for something that is not a hot path it should be
> > > > tolerable, especially when the whole operation is quite expensive on its
> > > > own (wrt. the syscall entry/exit).
> > >
> > > What's different with process_vm_[readv|writev] and vmsplice?
> > > If the range needed to be covered is a lot, vector operation makes senese
> > > to me.
> >
> > I am not saying that the vector API is wrong. All I am trying to say is
> > that the benefit is not really clear so far. If you want to push it
> > through then you should better get some supporting data.
>
> I measured 1000 madvise syscall vs. a vector range syscall with 1000
> ranges on ARM64 mordern device. Even though I saw 15% improvement but
> absoluate gain is just 1ms so I don't think it's worth to support.
> I will drop vector support at next revision.

Please do keep the vector support. Absolute timing is misleading,
since in a tight loop, you're not going to contend on mmap_sem. We've
seen tons of improvements in things like camera start come from
coalescing mprotect calls, with the gains coming from taking and
releasing various locks a lot less often and bouncing around less on
the contended lock paths. Raw throughput doesn't tell the whole story,
especially on mobile.
