From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 2/4] mm: introduce external memory hinting API
Date: Tue, 14 Jan 2020 11:12:39 -0800
Message-ID: <20200114191239.GB178589@google.com>
References: <20200110213433.94739-1-minchan@kernel.org>
 <20200110213433.94739-3-minchan@kernel.org>
 <56ea0927-ad2e-3fbd-3366-3813330f6cec@virtuozzo.com>
 <CAKOZuevwbQvrFWqy5GOm4RXuGszKLBvRs9i-KbAi3nPcHhwvSw@mail.gmail.com>
 <3eec2097-75a3-1e1d-06d9-44ee5eaf1312@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3eec2097-75a3-1e1d-06d9-44ee5eaf1312@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Daniel Colascione <dancol@google.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 14, 2020 at 11:39:28AM +0300, Kirill Tkhai wrote:
> On 13.01.2020 22:18, Daniel Colascione wrote:
> > On Mon, Jan 13, 2020, 12:47 AM Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> >>> +SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
> >>> +             size_t, len_in, int, behavior, unsigned long, flags)
> >>
> >> I don't like the interface. The fact we have pidfd does not mean,
> >> we have to use it for new syscalls always. A user may want to set
> >> madvise for specific pid from console and pass pid as argument.
> >> pidfd would be an overkill in this case.
> >> We usually call "kill -9 pid" from console. Why shouldn't process_madvise()
> >> allow this?
> > 
> > All new APIs should use pidfds: they're better than numeric PIDs
> 
> Yes
> 
> > in every way.
> 
> No
> 
> > If a program wants to allow users to specify processes by
> > numeric PID, it can parse that numeric PID, open the corresponding
> > pidfd, and then use that pidfd with whatever system call it wants.
> > It's not necessary to support numeric PIDs at the system call level to
> > allow a console program to identify a process by numeric PID.
> 
> No. It is overkill. Ordinary pid interfaces also should be available.
> There are a lot of cases, when they are more comfortable. Say, a calling
> of process_madvise() from tracer, when a tracee is stopped. In this moment
> the tracer knows everything about tracee state, and pidfd brackets
> pidfd_open() and close() around actual action look just stupid, and this
> is cpu time wasting.
> 
> Another example is a parent task, which manages parameters of its children.
> It knows everything about them, whether they are alive or not. Pidfd interface
> will just utilize additional cpu time here.
> 
> So, no. Both interfaces should be available.

Sounds like that you want to support both options for every upcoming API
which deals with pid. I'm not sure how it's critical for process_madvise
API this case. In general, we sacrifice some performance for the nicer one
and later, once it's reported as hurdle for some workload, we could fix it
via introducing new flag. What I don't like at this moment is to make
syscall complicated with potential scenarios without real workload.
