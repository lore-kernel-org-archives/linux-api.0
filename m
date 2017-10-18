From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm/mempolicy: add node_empty check in SYSC_migrate_pages
Date: Wed, 18 Oct 2017 12:46:41 +0200
Message-ID: <f889d39f-ca1f-9239-dc95-4e1806a6345f@suse.cz>
References: <1508290660-60619-1-git-send-email-xieyisheng1@huawei.com>
 <7086c6ea-b721-684e-fe3d-ff59ae1d78ed@suse.cz>
 <20aac66a-7252-947c-355b-6da4be671dcf@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20aac66a-7252-947c-355b-6da4be671dcf-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/18/2017 11:34 AM, Yisheng Xie wrote:
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
> 
> Yes, that is what manpage said, but I have a question about this: if user
> set maxnode exceeds a kernel-imposed and try to access node without enough
> privilege, which errors values we should return ? For I have seen that all
> of the ltp migrate_pages01 will set maxnode to 64 in my system.

Hm I don't think it matters much and don't know if there's some commonly
used priority. Personally I would do the checks resulting in EINVAL
first, before EPERM, but if the code is structured differently, it may
stay as it is.
