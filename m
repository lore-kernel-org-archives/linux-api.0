From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race
 with cpuset update
Date: Sun, 30 Apr 2017 16:33:10 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1704301628460.21533@east.gentwo.org>
References: <20170411140609.3787-1-vbabka@suse.cz> <20170411140609.3787-2-vbabka@suse.cz> <alpine.DEB.2.20.1704111152170.25069@east.gentwo.org> <a86ae57a-3efc-6ae5-ddf0-fd64c53c20fa@suse.cz> <alpine.DEB.2.20.1704121617040.28335@east.gentwo.org>
 <cf9628e9-20ed-68b0-6cbd-48af5133138c@suse.cz> <alpine.DEB.2.20.1704141526260.17435@east.gentwo.org> <fda99ddc-94f5-456e-6560-d4991da452a6@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <fda99ddc-94f5-456e-6560-d4991da452a6@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 26 Apr 2017, Vlastimil Babka wrote:

> > Such an application typically already has such logic and executes a
> > binding after discovering its numa node configuration on startup. It would
> > have to be modified to redo that action when it gets some sort of a signal
> > from the script telling it that the node config would be changed.
> >
> > Having this logic in the application instead of the kernel avoids all the
> > kernel messes that we keep on trying to deal with and IMHO is much
> > cleaner.
>
> That would be much simpler for us indeed. But we still IMHO can't
> abruptly start denying page fault allocations for existing applications
> that don't have the necessary awareness.

We certainly can do that. The failure of the page faults are due to the
admin trying to move an application that is not aware of this and is using
mempols. That could be an error. Trying to move an application that
contains both absolute and relative node numbers is definitely something
that is potentiall so screwed up that the kernel should not muck around
with such an app.

Also user space can determine if the application is using memory policies
and can then take appropriate measures (message to the sysadmin to eval
tge situation f.e.) or mess aroud with the processes memory policies on
its own.

So this is certainly a way out of this mess.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
