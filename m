From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race with
 cpuset update
Date: Tue, 11 Apr 2017 21:00:21 +0200
Message-ID: <a86ae57a-3efc-6ae5-ddf0-fd64c53c20fa@suse.cz>
References: <20170411140609.3787-1-vbabka@suse.cz>
 <20170411140609.3787-2-vbabka@suse.cz>
 <alpine.DEB.2.20.1704111152170.25069@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1704111152170.25069-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+CC linux-api

On 11.4.2017 19:24, Christoph Lameter wrote:
> On Tue, 11 Apr 2017, Vlastimil Babka wrote:
> 
>> The root of the problem is that the cpuset's mems_allowed and mempolicy's
>> nodemask can temporarily have no intersection, thus get_page_from_freelist()
>> cannot find any usable zone. The current semantic for empty intersection is to
>> ignore mempolicy's nodemask and honour cpuset restrictions. This is checked in
>> node_zonelist(), but the racy update can happen after we already passed the
> 
> The fallback was only intended for a cpuset on which boundaries are not enforced
> in critical conditions (softwall). A hardwall cpuset (CS_MEM_HARDWALL)
> should fail the allocation.

Hmm just to clarify - I'm talking about ignoring the *mempolicy's* nodemask on
the basis of cpuset having higher priority, while you seem to be talking about
ignoring a (softwall) cpuset nodemask, right? man set_mempolicy says "... if
required nodemask contains no nodes that are allowed by the process's current
cpuset context, the memory  policy reverts to local allocation" which does come
down to ignoring mempolicy's nodemask.

>> This patch fixes the issue by having __alloc_pages_slowpath() check for empty
>> intersection of cpuset and ac->nodemask before OOM or allocation failure. If
>> it's indeed empty, the nodemask is ignored and allocation retried, which mimics
>> node_zonelist(). This works fine, because almost all callers of
> 
> Well that would need to be subject to the hardwall flag. Allocation needs
> to fail for a hardwall cpuset.

They still do, if no hardwall cpuset node can satisfy the allocation with
mempolicy ignored.
