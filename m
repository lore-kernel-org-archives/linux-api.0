From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race
 with cpuset update
Date: Wed, 17 May 2017 16:56:45 +0200
Message-ID: <20170517145645.GO18247@dhcp22.suse.cz>
References: <a86ae57a-3efc-6ae5-ddf0-fd64c53c20fa@suse.cz>
 <alpine.DEB.2.20.1704121617040.28335@east.gentwo.org>
 <cf9628e9-20ed-68b0-6cbd-48af5133138c@suse.cz>
 <alpine.DEB.2.20.1704141526260.17435@east.gentwo.org>
 <fda99ddc-94f5-456e-6560-d4991da452a6@suse.cz>
 <alpine.DEB.2.20.1704301628460.21533@east.gentwo.org>
 <20170517092042.GH18247@dhcp22.suse.cz>
 <alpine.DEB.2.20.1705170855430.7925@east.gentwo.org>
 <20170517140501.GM18247@dhcp22.suse.cz>
 <alpine.DEB.2.20.1705170943090.8714@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1705170943090.8714-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 17-05-17 09:48:25, Cristopher Lameter wrote:
> On Wed, 17 May 2017, Michal Hocko wrote:
> 
> > > > So how are you going to distinguish VM_FAULT_OOM from an empty mempolicy
> > > > case in a raceless way?
> > >
> > > You dont have to do that if you do not create an empty mempolicy in the
> > > first place. The current kernel code avoids that by first allowing access
> > > to the new set of nodes and removing the old ones from the set when done.
> >
> > which is racy and as Vlastimil pointed out. If we simply fail such an
> > allocation the failure will go up the call chain until we hit the OOM
> > killer due to VM_FAULT_OOM. How would you want to handle that?
> 
> The race is where? If you expand the node set during the move of the
> application then you are safe in terms of the legacy apps that did not
> include static bindings.

I am pretty sure it is describe in those changelogs and I won't repeat
it here.

> If you have screwy things like static mbinds in there then you are
> hopelessly lost anyways. You may have moved the process to another set
> of nodes but the static bindings may refer to a node no longer
> available. Thus the OOM is legitimate.

The point is that you do _not_ want such a process to trigger the OOM
because it can cause other processes being killed.

> At least a user space app could inspect
> the situation and come up with custom ways of dealing with the mess.

I do not really see how would this help to prevent a malicious user from
playing tricks.

-- 
Michal Hocko
SUSE Labs
