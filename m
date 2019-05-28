From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC 7/7] mm: madvise support MADV_ANONYMOUS_FILTER and MADV_FILE_FILTER
Date: Tue, 28 May 2019 02:39:03 -0700
Message-ID: <CAKOZueux3T4_dMOUK6R=ZHhCFaSSstOCPh_KSwSMCW_yp=jdSg@mail.gmail.com>
References: <20190520092801.GA6836@dhcp22.suse.cz> <20190521025533.GH10039@google.com>
 <20190521062628.GE32329@dhcp22.suse.cz> <20190527075811.GC6879@google.com>
 <20190527124411.GC1658@dhcp22.suse.cz> <20190528032632.GF6879@google.com>
 <20190528062947.GL1658@dhcp22.suse.cz> <20190528081351.GA159710@google.com>
 <CAKOZuesnS6kBFX-PKJ3gvpkv8i-ysDOT2HE2Z12=vnnHQv0FDA@mail.gmail.com>
 <20190528084927.GB159710@google.com> <20190528090821.GU1658@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528090821.GU1658@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 2:08 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 28-05-19 17:49:27, Minchan Kim wrote:
> > On Tue, May 28, 2019 at 01:31:13AM -0700, Daniel Colascione wrote:
> > > On Tue, May 28, 2019 at 1:14 AM Minchan Kim <minchan@kernel.org> wrote:
> > > > if we went with the per vma fd approach then you would get this
> > > > > feature automatically because map_files would refer to file backed
> > > > > mappings while map_anon could refer only to anonymous mappings.
> > > >
> > > > The reason to add such filter option is to avoid the parsing overhead
> > > > so map_anon wouldn't be helpful.
> > >
> > > Without chiming on whether the filter option is a good idea, I'd like
> > > to suggest that providing an efficient binary interfaces for pulling
> > > memory map information out of processes.  Some single-system-call
> > > method for retrieving a binary snapshot of a process's address space
> > > complete with attributes (selectable, like statx?) for each VMA would
> > > reduce complexity and increase performance in a variety of areas,
> > > e.g., Android memory map debugging commands.
> >
> > I agree it's the best we can get *generally*.
> > Michal, any opinion?
>
> I am not really sure this is directly related. I think the primary
> question that we have to sort out first is whether we want to have
> the remote madvise call process or vma fd based. This is an important
> distinction wrt. usability. I have only seen pid vs. pidfd discussions
> so far unfortunately.

I don't think the vma fd approach is viable. We have some processes
with a *lot* of VMAs --- system_server had 4204 when I checked just
now (and that's typical) --- and an FD operation per VMA would be
excessive. VMAs also come and go pretty easily depending on changes in
protections and various faults. It's also not entirely clear what the
semantics of vma FDs should be over address space mutations, while the
semantics of address ranges are well-understood. I would much prefer
an interface operating on address ranges to one operating on VMA FDs,
both for efficiency and for consistency with other memory management
APIs.

> An interface to query address range information is a separate but
> although a related topic. We have /proc/<pid>/[s]maps for that right
> now and I understand it is not a general win for all usecases because
> it tends to be slow for some. I can see how /proc/<pid>/map_anons could
> provide per vma information in a binary form via a fd based interface.
> But I would rather not conflate those two discussions much - well except
> if it could give one of the approaches more justification but let's
> focus on the madvise part first.

I don't think it's a good idea to focus on one feature in a
multi-feature change when the interactions between features can be
very important for overall design of the multi-feature system and the
design of each feature.

Here's my thinking on the high-level design:

I'm imagining an address-range system that would work like this: we'd
create some kind of process_vm_getinfo(2) system call [1] that would
accept a statx-like attribute map and a pid/fd parameter as input and
return, on output, two things: 1) an array [2] of VMA descriptors
containing the requested information, and 2) a VMA configuration
sequence number. We'd then have process_madvise() and other
cross-process VM interfaces accept both address ranges and this
sequence number; they'd succeed only if the VMA configuration sequence
number is still current, i.e., the target process hasn't changed its
VMA configuration (implicitly or explicitly) since the call to
process_vm_getinfo().

This way, a process A that wants to perform some VM operation on
process B can slurp B's VMA configuration using process_vm_getinfo(),
figure out what it wants to do, and attempt to do it. If B modifies
its memory map in the meantime, If A finds that its local knowledge of
B's memory map has become invalid between the process_vm_getinfo() and
A taking some action based on the result, A can retry [3]. While A
could instead ptrace or otherwise suspend B, *then* read B's memory
map (knowing B is quiescent), *then* operate on B, the optimistic
approach I'm describing would be much lighter-weight in the typical
case. It's also pretty simple, IMHO. If the "operate on B" step is
some kind of vectorized operation over multiple address ranges, this
approach also gets us all-or-nothing semantics.

Or maybe the whole sequence number thing is overkill and we don't need
atomicity? But if there's a concern  that A shouldn't operate on B's
memory without knowing what it's operating on, then the scheme I've
proposed above solves this knowledge problem in a pretty lightweight
way.

[1] or some other interface
[2] or something more complicated if we want the descriptors to
contain variable-length elements, e.g., strings
[3] or override the sequence number check if it's feeling bold?
