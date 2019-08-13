From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v5 1/6] mm/page_idle: Add per-pid idle page tracking
 using virtual index
Date: Tue, 13 Aug 2019 15:18:11 -0400
Message-ID: <20190813191811.GA117503@google.com>
References: <20190807171559.182301-1-joel@joelfernandes.org>
 <CAG48ez0ysprvRiENhBkLeV9YPTN_MB18rbu2HDa2jsWo5FYR8g@mail.gmail.com>
 <20190813100856.GF17933@dhcp22.suse.cz>
 <CAG48ez2cuqe_VYhhaqw8Hcyswv47cmz2XmkqNdvkXEhokMVaXg@mail.gmail.com>
 <d6ae7f06-f0ef-ec00-a020-98e7cfada281@iaik.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d6ae7f06-f0ef-ec00-a020-98e7cfada281@iaik.tugraz.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: Jann Horn <jannh@google.com>, Michal Hocko <mhocko@kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, Daniel Colascione <dancol@google.com>, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team <kernel-team@android.com>, Linux API <linux-api@vger.kernel.org>, linux-doc@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 13, 2019 at 05:34:16PM +0200, Daniel Gruss wrote:
> On 8/13/19 5:29 PM, Jann Horn wrote:
> > On Tue, Aug 13, 2019 at 12:09 PM Michal Hocko <mhocko@kernel.org> wrote:
> >> On Mon 12-08-19 20:14:38, Jann Horn wrote:
> >>> On Wed, Aug 7, 2019 at 7:16 PM Joel Fernandes (Google)
> >>> <joel@joelfernandes.org> wrote:
> >>>> The page_idle tracking feature currently requires looking up the pagemap
> >>>> for a process followed by interacting with /sys/kernel/mm/page_idle.
> >>>> Looking up PFN from pagemap in Android devices is not supported by
> >>>> unprivileged process and requires SYS_ADMIN and gives 0 for the PFN.
> >>>>
> >>>> This patch adds support to directly interact with page_idle tracking at
> >>>> the PID level by introducing a /proc/<pid>/page_idle file.  It follows
> >>>> the exact same semantics as the global /sys/kernel/mm/page_idle, but now
> >>>> looking up PFN through pagemap is not needed since the interface uses
> >>>> virtual frame numbers, and at the same time also does not require
> >>>> SYS_ADMIN.
> >>>>
> >>>> In Android, we are using this for the heap profiler (heapprofd) which
> >>>> profiles and pin points code paths which allocates and leaves memory
> >>>> idle for long periods of time. This method solves the security issue
> >>>> with userspace learning the PFN, and while at it is also shown to yield
> >>>> better results than the pagemap lookup, the theory being that the window
> >>>> where the address space can change is reduced by eliminating the
> >>>> intermediate pagemap look up stage. In virtual address indexing, the
> >>>> process's mmap_sem is held for the duration of the access.
> >>>
> >>> What happens when you use this interface on shared pages, like memory
> >>> inherited from the zygote, library file mappings and so on? If two
> >>> profilers ran concurrently for two different processes that both map
> >>> the same libraries, would they end up messing up each other's data?
> >>
> >> Yup PageIdle state is shared. That is the page_idle semantic even now
> >> IIRC.
> >>
> >>> Can this be used to observe which library pages other processes are
> >>> accessing, even if you don't have access to those processes, as long
> >>> as you can map the same libraries? I realize that there are already a
> >>> bunch of ways to do that with side channels and such; but if you're
> >>> adding an interface that allows this by design, it seems to me like
> >>> something that should be gated behind some sort of privilege check.
> >>
> >> Hmm, you need to be priviledged to get the pfn now and without that you
> >> cannot get to any page so the new interface is weakening the rules.
> >> Maybe we should limit setting the idle state to processes with the write
> >> status. Or do you think that even observing idle status is useful for
> >> practical side channel attacks? If yes, is that a problem of the
> >> profiler which does potentially dangerous things?
> > 
> > I suppose read-only access isn't a real problem as long as the
> > profiler isn't writing the idle state in a very tight loop... but I
> > don't see a usecase where you'd actually want that? As far as I can
> > tell, if you can't write the idle state, being able to read it is
> > pretty much useless.
> > 
> > If the profiler only wants to profile process-private memory, then
> > that should be implementable in a safe way in principle, I think, but
> > since Joel said that they want to profile CoW memory as well, I think
> > that's inherently somewhat dangerous.
> 
> I agree that allowing profiling of shared pages would leak information.

Will think more about it. If we limit it to private pages, then it could
become useless. Consider a scenario where:
A process allocates a some memory, then forks a bunch of worker processes
that read that memory and perform some work with them. Per-PID page idle
tracking is now run on the parent processes. Now it should appear that the
pages are actively accessed (not-idle). If we don't track shared pages, then
we cannot detect if those pages are really due to memory leaking, or if they
are there for a purpose and are actively used.

> To me the use case is not entirely clear. This is not a feature that
> would normally be run in everyday computer usage, right?

Generally, this to be used as a debugging feature that helps developers
detect memory leaks in their programs.

thanks,

 - Joel
