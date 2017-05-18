From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race with
 cpuset update
Date: Thu, 18 May 2017 12:03:50 +0200
Message-ID: <8889d67a-adab-91e1-c320-d8bd88d7e1e0@suse.cz>
References: <20170411140609.3787-2-vbabka@suse.cz>
 <alpine.DEB.2.20.1704111152170.25069@east.gentwo.org>
 <a86ae57a-3efc-6ae5-ddf0-fd64c53c20fa@suse.cz>
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
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1705170943090.8714@east.gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/17/2017 04:48 PM, Christoph Lameter wrote:
> On Wed, 17 May 2017, Michal Hocko wrote:
> 
>>>> So how are you going to distinguish VM_FAULT_OOM from an empty mempolicy
>>>> case in a raceless way?
>>>
>>> You dont have to do that if you do not create an empty mempolicy in the
>>> first place. The current kernel code avoids that by first allowing access
>>> to the new set of nodes and removing the old ones from the set when done.
>>
>> which is racy and as Vlastimil pointed out. If we simply fail such an
>> allocation the failure will go up the call chain until we hit the OOM
>> killer due to VM_FAULT_OOM. How would you want to handle that?
> 
> The race is where? If you expand the node set during the move of the
> application then you are safe in terms of the legacy apps that did not
> include static bindings.

No, that expand/shrink by itself doesn't work against parallel
get_page_from_freelist going through a zonelist. Moving from node 0 to
1, with zonelist containing nodes 1 and 0 in that order:

- mempolicy mask is 0
- zonelist iteration checks node 1, it's not allowed, skip
- mempolicy mask is 0,1 (expand)
- mempolicy mask is 1 (shrink)
- zonelist iteration checks node 0, it's not allowed, skip
- OOM
