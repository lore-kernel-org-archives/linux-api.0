From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race
 with cpuset update
Date: Wed, 17 May 2017 09:48:25 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1705170943090.8714@east.gentwo.org>
References: <20170411140609.3787-2-vbabka@suse.cz> <alpine.DEB.2.20.1704111152170.25069@east.gentwo.org> <a86ae57a-3efc-6ae5-ddf0-fd64c53c20fa@suse.cz> <alpine.DEB.2.20.1704121617040.28335@east.gentwo.org> <cf9628e9-20ed-68b0-6cbd-48af5133138c@suse.cz>
 <alpine.DEB.2.20.1704141526260.17435@east.gentwo.org> <fda99ddc-94f5-456e-6560-d4991da452a6@suse.cz> <alpine.DEB.2.20.1704301628460.21533@east.gentwo.org> <20170517092042.GH18247@dhcp22.suse.cz> <alpine.DEB.2.20.1705170855430.7925@east.gentwo.org>
 <20170517140501.GM18247@dhcp22.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170517140501.GM18247@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 17 May 2017, Michal Hocko wrote:

> > > So how are you going to distinguish VM_FAULT_OOM from an empty mempolicy
> > > case in a raceless way?
> >
> > You dont have to do that if you do not create an empty mempolicy in the
> > first place. The current kernel code avoids that by first allowing access
> > to the new set of nodes and removing the old ones from the set when done.
>
> which is racy and as Vlastimil pointed out. If we simply fail such an
> allocation the failure will go up the call chain until we hit the OOM
> killer due to VM_FAULT_OOM. How would you want to handle that?

The race is where? If you expand the node set during the move of the
application then you are safe in terms of the legacy apps that did not
include static bindings.

If you have screwy things like static mbinds in there then you are
hopelessly lost anyways. You may have moved the process to another set
of nodes but the static bindings may refer to a node no longer
available. Thus the OOM is legitimate.

At least a user space app could inspect
the situation and come up with custom ways of dealing with the mess.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
