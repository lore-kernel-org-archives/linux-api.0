From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Tue, 21 Jan 2020 10:32:12 -0800
Message-ID: <20200121183212.GF140922@google.com>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <20200117155837.bowyjpndfiym6cgs@box>
 <20200117173239.GB140922@google.com>
 <20200117212653.7uftw3lk35oykkmb@box>
 <20200119161431.GA94410@google.com>
 <20200120075825.GH18451@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200120075825.GH18451@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: sspatil@google.com, kirill@shutemov.name, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, oleksandr@redhat.com, surenb@google.com, timmurray@google.com, dancol@google.com, sonnyrao@google.com, bgeffon@google.com, hannes@cmpxchg.org, shakeelb@google.com, joaodias@google.com, ktkhai@virtuozzo.com, christian.brauner@ubuntu.com, sjpark@amazon.de
List-Id: linux-api@vger.kernel.org

On Mon, Jan 20, 2020 at 08:58:25AM +0100, Michal Hocko wrote:
> On Sun 19-01-20 08:14:31, sspatil@google.com wrote:
> > On Sat, Jan 18, 2020 at 12:26:53AM +0300, Kirill A. Shutemov wrote:
> > > On Fri, Jan 17, 2020 at 09:32:39AM -0800, Minchan Kim wrote:
> > > > On Fri, Jan 17, 2020 at 06:58:37PM +0300, Kirill A. Shutemov wrote:
> > > > > On Fri, Jan 17, 2020 at 12:52:25PM +0100, Michal Hocko wrote:
> > > > > > On Thu 16-01-20 15:59:50, Minchan Kim wrote:
> > > > > > > There is usecase that System Management Software(SMS) want to give
> > > > > > > a memory hint like MADV_[COLD|PAGEEOUT] to other processes and
> > > > > > > in the case of Android, it is the ActivityManagerService.
> > > > > > > 
> > > > > > > It's similar in spirit to madvise(MADV_WONTNEED), but the information
> > > > > > > required to make the reclaim decision is not known to the app. Instead,
> > > > > > > it is known to the centralized userspace daemon(ActivityManagerService),
> > > > > > > and that daemon must be able to initiate reclaim on its own without
> > > > > > > any app involvement.
> > > > > > > 
> > > > > > > To solve the issue, this patch introduces new syscall process_madvise(2).
> > > > > > > It uses pidfd of an external processs to give the hint.
> > > > > > > 
> > > > > > >  int process_madvise(int pidfd, void *addr, size_t length, int advise,
> > > > > > > 			unsigned long flag);
> > > > > > > 
> > > > > > > Since it could affect other process's address range, only privileged
> > > > > > > process(CAP_SYS_PTRACE) or something else(e.g., being the same UID)
> > > > > > > gives it the right to ptrace the process could use it successfully.
> > > > > > > The flag argument is reserved for future use if we need to extend the
> > > > > > > API.
> > > > > > > 
> > > > > > > I think supporting all hints madvise has/will supported/support to
> > > > > > > process_madvise is rather risky. Because we are not sure all hints make
> > > > > > > sense from external process and implementation for the hint may rely on
> > > > > > > the caller being in the current context so it could be error-prone.
> > > > > > > Thus, I just limited hints as MADV_[COLD|PAGEOUT] in this patch.
> > > > > > > 
> > > > > > > If someone want to add other hints, we could hear hear the usecase and
> > > > > > > review it for each hint. It's more safe for maintainace rather than
> > > > > > > introducing a buggy syscall but hard to fix it later.
> > > > > > 
> > > > > > I have brought this up when we discussed this in the past but there is
> > > > > > no reflection on that here so let me bring that up again. 
> > > > > > 
> > > > > > I believe that the interface has an inherent problem that it is racy.
> > > > > > The external entity needs to know the address space layout of the target
> > > > > > process to do anyhing useful on it. The address space is however under
> > > > > > the full control of the target process though and the external entity
> > > > > > has no means to find out that the layout has changed. So
> > > > > > time-to-check-time-to-act is an inherent problem.
> > > > > > 
> > > > > > This is a serious design flaw and it should be explained why it doesn't
> > > > > > matter or how to use the interface properly to prevent that problem.
> > > > > 
> > > > > I agree, it looks flawed.
> > > > > 
> > > > > Also I don't see what System Management Software can generically do on
> > > > > sub-process level. I mean how can it decide which part of address space is
> > > > > less important than other.
> > > > > 
> > > > > I see how a manager can indicate that this process (or a group of
> > > > > processes) is less important than other, but on per-addres-range basis?
> > > > 
> > > > For example, memory ranges shared by several processes or critical for the
> > > > latency, we could avoid those ranges to be cold/pageout to prevent
> > > > unncecessary CPU burning/paging.
> > > 
> > > Hmm.. I still don't see why any external entity has a better (or any)
> > > knowledge about the matter. The process has to do this, no?
> > 
> > FWIW, I totally agree with the time-to-check-time-to-react problem. However,
> > I'd like to clarify the ActivityManager/SystemServer case (I'll call it
> > SystemServer from now on)
> > 
> > For Android, every application (including the special SystemServer) are forked
> > from Zygote. The reason ofcourse is to share as many libraries and classes between
> > the two as possible to benefit from the preloading during boot.
> > 
> > After applications start, (almost) all of the APIs  end up calling into this
> > SystemServer process over IPC (binder) and back to the application.
> > 
> > In a fully running system, the SystemServer monitors every single process
> > periodically to calculate their PSS / RSS and also decides which process is
> > "important" to the user for interactivity.
> > 
> > So, because of how these processes start _and_ the fact that the SystemServer
> > is looping to monitor each process, it does tend to *know* which address
> > range of the application is not used / useful.
> > 
> > Besides, we can never rely on applications to clean things up themselves.
> > We've had the "hey app1, the system is low on memory, please trim your
> > memory usage down" notifications for a long time[1]. They rely on
> > applications honoring the broadcasts and very few do.
> > 
> > So, if we want to avoid the inevitable killing of the application and
> > restarting it, some way to be able to tell the OS about unimportant memory in
> > these applications will be useful.

Thanks for adding more useful description, Sandeep.

> 
> This is a useful information that should be a part of the changelog. I

I will incldue it in next respin.

> do see how the current form of the API might fit into Android model
> without many problems. But we are not designing an API for a single
> usecase, right? In a highly cooperative environments you can use ptrace
> code injection as mentioned by Kirill. Or is there any fundamental
> problem about that?

I replied it at Kirill's thread so let's discuss there.

> 
> The interface really has to be robust to future potential usecases.

I do understand your concern but for me, it's chicken and egg problem.
We usually do best effort to make something perfect as far as possible
but we also don't do over-engineering without real usecase from the
beginning.

I already told you how we could synchronize among processes and potential
way to be extended Daniel suggested(That's why current API has extra field
for the cookie) even though we don't need it right now.

If you want to suggest the other way, please explain why your idea is
better and why we need it at this moment. I don't think that is a
blocker for the progress of this API since we already have several ways
to synchronize processes.
