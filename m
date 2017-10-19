From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/mempolicy: add node_empty check in SYSC_migrate_pages
Date: Thu, 19 Oct 2017 18:31:03 +0800
Message-ID: <ce912b7c-6e28-b780-3ba3-354b4226bb22@huawei.com>
References: <1508290660-60619-1-git-send-email-xieyisheng1@huawei.com>
 <7086c6ea-b721-684e-fe3d-ff59ae1d78ed@suse.cz>
 <20aac66a-7252-947c-355b-6da4be671dcf@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20aac66a-7252-947c-355b-6da4be671dcf-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Vlastimil,

Thanks for you comment!
On 2017/10/18 17:34, Yisheng Xie wrote:
> Hi Vlastimil,
> 
> Thanks for your comment!
> On 2017/10/18 15:54, Vlastimil Babka wrote:
>> +CC linux-api
>>
>> On 10/18/2017 03:37 AM, Yisheng Xie wrote:
>>> As Xiaojun reported the ltp of migrate_pages01 will failed on ARCH arm64
>>> system whoes has 4 nodes[0...3], all have memory and CONFIG_NODES_SHIFT=2:
>>>
>>> migrate_pages01    0  TINFO  :  test_invalid_nodes
>>> migrate_pages01   14  TFAIL  :  migrate_pages_common.c:45: unexpected failure - returned value = 0, expected: -1
>>> migrate_pages01   15  TFAIL  :  migrate_pages_common.c:55: call succeeded unexpectedly
>>>
>>> In this case the test_invalid_nodes of migrate_pages01 will call:
>>> SYSC_migrate_pages as:
>>>
>>> migrate_pages(0, , {0x0000000000000001}, 64, , {0x0000000000000010}, 64) = 0
>>
>> is 64 here the maxnode parameter of migrate_pages() ?
> 
> Yes, I have print it in the kernel.
> 
>>
>>> For MAX_NUMNODES is 4, so 0x10 nodemask will tread as empty set which makes
>>> 	nodes_subset(*new, node_states[N_MEMORY])
>>
>> According to manpage of migrate_pages:
>>
>>         EINVAL The value specified by maxnode exceeds a kernel-imposed
>> limit.  Or, old_nodes or new_nodes specifies one or more node IDs that
>> are greater than the maximum supported node ID.  Or, none of the node
>> IDs specified by new_nodes are on-line and allowed by the process's
>> current cpuset context, or none of the specified nodes contain memory.
>>
>> if maxnode parameter is 64, but MAX_NUMNODES ("kernel-imposed limit") is
>> 4, we should get EINVAL just because of that. I don't see such check in
>> the migrate_pages implementation though.
I agree that we should add this check,  howver, I'm doubt about what
"kernel-imposed limit" in the manpage, does it really what your said
MAX_NUMNODES? or BITS_PER_LONG * BITS_TO_LONGS(MAX_NUMNODES),
we used unsigned long to store node bitmap, so the limit should count in
multiple of BITS_PER_LONG, is this fare?

> 
> Yes, that is what manpage said, but I have a question about this: if user
> set maxnode exceeds a kernel-imposed and try to access node without enough
> privilege, which errors values we should return ? For I have seen that all
> of the ltp migrate_pages01 will set maxnode to 64 in my system.
> 
>> But then at least the
>> "new_nodes specifies one or more node IDs that are greater than the
>> maximum supported node ID" part should trigger here, because you have
>> node number 8 set in the new_nodes nodemask, right?
>> get_nodes() should be checking this according to comment:
>>
>>         /* When the user specified more nodes than supported just check
>>            if the non supported part is all zero. */

here, "nodes than supported" also means BITS_PER_LONG * BITS_TO_LONGS(MAX_NUMNODES),
it check whether user specified more than BITS_PER_LONG * BITS_TO_LONGS(MAX_NUMNODES)
is zero or no. And if "kernel-imposed limit" means MAX_NUMNODES this check is no need
at all, we can just check if maxnode > MAX_NUMNODES, for bits higher than maxnode is
invalid which should be masked after taken from user:
       The old_nodes and new_nodes arguments are pointers to bit masks of
       node numbers, with up to maxnode bits in each mask.  These masks are
       maintained as arrays of unsigned long integers (in the last long
       integer, the bits beyond those specified by maxnode are ignored).
       The maxnode argument is the maximum node number in the bit mask plus
       one (this is the same as in mbind(2), but different from select(2)).

The get_nodes is just a common code which also used in set_mempolicy whoes ERRORS
of EINVAL is not the same as migrate_pages:
    EINVAL
        mode is invalid. Or, mode is MPOL_DEFAULT and nodemask is nonempty, or mode
        is MPOL_BIND or MPOL_INTERLEAVE and nodemask is empty. Or, *maxnode specifies
        more than a page worth of bits*. Or, nodemask specifies one or more node IDs
        that are greater than the maximum supported node ID. Or, none of the node IDs
        specified by nodemask are on-line and allowed by the process's current cpuset
        context, or none of the specified nodes contain memory. Or, the mode argument
        specified both MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES.

So get_nodes just check whether "nodemask specifies one or more node IDs that are
greater than the maximum supported node ID（BITS_TO_LONGS(MAX_NUMNODES)）" as a
common part. If we want check "maxnode exceeds a kernel-imposed limit", maybe we
should add following in migrate_pages:
+       if (BITS_TO_LONGS(MAX_NUMNODES) < BITS_TO_LONGS(maxnode)) {
+               err = -EINVAL;
+               goto out;
+       }
+

And for nodes_empty() check should also be need for this case or real empty nodes set.
Any opinion?

Thanks
Yisheng Xie.
