From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race
 with cpuset update
Date: Wed, 17 May 2017 11:20:43 +0200
Message-ID: <20170517092042.GH18247@dhcp22.suse.cz>
References: <20170411140609.3787-1-vbabka@suse.cz>
 <20170411140609.3787-2-vbabka@suse.cz>
 <alpine.DEB.2.20.1704111152170.25069@east.gentwo.org>
 <a86ae57a-3efc-6ae5-ddf0-fd64c53c20fa@suse.cz>
 <alpine.DEB.2.20.1704121617040.28335@east.gentwo.org>
 <cf9628e9-20ed-68b0-6cbd-48af5133138c@suse.cz>
 <alpine.DEB.2.20.1704141526260.17435@east.gentwo.org>
 <fda99ddc-94f5-456e-6560-d4991da452a6@suse.cz>
 <alpine.DEB.2.20.1704301628460.21533@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1704301628460.21533-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun 30-04-17 16:33:10, Cristopher Lameter wrote:
> On Wed, 26 Apr 2017, Vlastimil Babka wrote:
> 
> > > Such an application typically already has such logic and executes a
> > > binding after discovering its numa node configuration on startup. It would
> > > have to be modified to redo that action when it gets some sort of a signal
> > > from the script telling it that the node config would be changed.
> > >
> > > Having this logic in the application instead of the kernel avoids all the
> > > kernel messes that we keep on trying to deal with and IMHO is much
> > > cleaner.
> >
> > That would be much simpler for us indeed. But we still IMHO can't
> > abruptly start denying page fault allocations for existing applications
> > that don't have the necessary awareness.
> 
> We certainly can do that. The failure of the page faults are due to the
> admin trying to move an application that is not aware of this and is using
> mempols. That could be an error. Trying to move an application that
> contains both absolute and relative node numbers is definitely something
> that is potentiall so screwed up that the kernel should not muck around
> with such an app.
> 
> Also user space can determine if the application is using memory policies
> and can then take appropriate measures (message to the sysadmin to eval
> tge situation f.e.) or mess aroud with the processes memory policies on
> its own.
> 
> So this is certainly a way out of this mess.

So how are you going to distinguish VM_FAULT_OOM from an empty mempolicy
case in a raceless way?

-- 
Michal Hocko
SUSE Labs
