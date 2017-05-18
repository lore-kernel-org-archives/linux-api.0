From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race
 with cpuset update
Date: Thu, 18 May 2017 19:24:24 +0200
Message-ID: <20170518172424.GB30148@dhcp22.suse.cz>
References: <fda99ddc-94f5-456e-6560-d4991da452a6@suse.cz>
 <alpine.DEB.2.20.1704301628460.21533@east.gentwo.org>
 <20170517092042.GH18247@dhcp22.suse.cz>
 <alpine.DEB.2.20.1705170855430.7925@east.gentwo.org>
 <20170517140501.GM18247@dhcp22.suse.cz>
 <alpine.DEB.2.20.1705170943090.8714@east.gentwo.org>
 <20170517145645.GO18247@dhcp22.suse.cz>
 <alpine.DEB.2.20.1705171021570.9487@east.gentwo.org>
 <20170518090846.GD25462@dhcp22.suse.cz>
 <alpine.DEB.2.20.1705181154450.27641@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1705181154450.27641-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 18-05-17 11:57:55, Cristopher Lameter wrote:
> On Thu, 18 May 2017, Michal Hocko wrote:
> 
> > > Nope. The OOM in a cpuset gets the process doing the alloc killed. Or what
> > > that changed?
> 
> !!!!!
> 
> > >
> > > At this point you have messed up royally and nothing is going to rescue
> > > you anyways. OOM or not does not matter anymore. The app will fail.
> >
> > Not really. If you can trick the system to _think_ that the intersection
> > between mempolicy and the cpuset is empty then the OOM killer might
> > trigger an innocent task rather than the one which tricked it into that
> > situation.
> 
> See above. OOM Kill in a cpuset does not kill an innocent task but a task
> that does an allocation in that specific context meaning a task in that
> cpuset that also has a memory policty.

No, the oom killer will chose the largest task in the specific NUMA
domain. If you just fail such an allocation then a page fault would get
VM_FAULT_OOM and pagefault_out_of_memory would kill a task regardless of
the cpusets.
 
> Regardless of that the point earlier was that the moving logic can avoid
> creating temporary situations of empty sets of nodes by analysing the
> memory policies etc and only performing moves when doing so is safe.

How are you going to do that in a raceless way? Moreover the whole
discussion is about _failing_ allocations on an empty cpuset and
mempolicy intersection.

-- 
Michal Hocko
SUSE Labs
