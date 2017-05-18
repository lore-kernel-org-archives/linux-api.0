From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race
 with cpuset update
Date: Thu, 18 May 2017 14:07:45 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1705181351120.29348@east.gentwo.org>
References: <fda99ddc-94f5-456e-6560-d4991da452a6@suse.cz> <alpine.DEB.2.20.1704301628460.21533@east.gentwo.org> <20170517092042.GH18247@dhcp22.suse.cz> <alpine.DEB.2.20.1705170855430.7925@east.gentwo.org> <20170517140501.GM18247@dhcp22.suse.cz>
 <alpine.DEB.2.20.1705170943090.8714@east.gentwo.org> <20170517145645.GO18247@dhcp22.suse.cz> <alpine.DEB.2.20.1705171021570.9487@east.gentwo.org> <20170518090846.GD25462@dhcp22.suse.cz> <alpine.DEB.2.20.1705181154450.27641@east.gentwo.org>
 <20170518172424.GB30148@dhcp22.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518172424.GB30148-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 18 May 2017, Michal Hocko wrote:

> > See above. OOM Kill in a cpuset does not kill an innocent task but a task
> > that does an allocation in that specific context meaning a task in that
> > cpuset that also has a memory policty.
>
> No, the oom killer will chose the largest task in the specific NUMA
> domain. If you just fail such an allocation then a page fault would get
> VM_FAULT_OOM and pagefault_out_of_memory would kill a task regardless of
> the cpusets.

Ok someone screwed up that code. There still is the determination that we
have a constrained alloc:

oom_kill:
	/*
         * Check if there were limitations on the allocation (only relevant for
         * NUMA and memcg) that may require different handling.
         */
        constraint = constrained_alloc(oc);
        if (constraint != CONSTRAINT_MEMORY_POLICY)
                oc->nodemask = NULL;
        check_panic_on_oom(oc, constraint);

-- Ok. A constrained failing alloc used to terminate the allocating
	process here. But it falls through to selecting a "bad process"


        if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
            current->mm && !oom_unkillable_task(current, NULL, oc->nodemask) &&
            current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
                get_task_struct(current);
                oc->chosen = current;
                oom_kill_process(oc, "Out of memory (oom_kill_allocating_task)");
                return true;
        }

--  A constrained allocation should not get here but fail the process that
	attempts the alloc.

        select_bad_process(oc);


Can we restore the old behavior? If I just specify the right memory policy
I can cause other processes to just be terminated?


> > Regardless of that the point earlier was that the moving logic can avoid
> > creating temporary situations of empty sets of nodes by analysing the
> > memory policies etc and only performing moves when doing so is safe.
>
> How are you going to do that in a raceless way? Moreover the whole
> discussion is about _failing_ allocations on an empty cpuset and
> mempolicy intersection.

Again this is only working for processes that are well behaved and it
never worked in a different way before. There was always the assumption
that a process does not allocate in the areas that have allocation
constraints and that the process does not change memory policies nor
store them somewhere for late etc etc. HPC apps typically allocate memory
on startup and then go through long times of processing and I/O.

The idea that cpuset node to node migration will work with a running
process that does abitrary activity is a pipe dream that we should give
up. There must be constraints on a process in order to allow this to work
and as far as I can tell this is best done in userspace with a library and
by putting requirements on the applications that desire to be movable that
way.

F.e. an application that does not use memory policies or other allocation
constraints should be fine. That has been working.
