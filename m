From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] mm/mempolicy.c: Remove unnecessary nodemask check in
 kernel_migrate_pages()
Date: Wed, 7 Aug 2019 08:58:03 +0800
Message-ID: <34880869-49a1-86c6-9345-2a01da7fbb9b@huawei.com>
References: <20190806023634.55356-1-wangkefeng.wang@huawei.com>
 <80f8da83-f425-1aab-f47e-8da41ec6dcbf@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <80f8da83-f425-1aab-f47e-8da41ec6dcbf@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, Linux API <linux-api@vger.kernel.org>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



On 2019/8/6 16:36, Vlastimil Babka wrote:
> On 8/6/19 4:36 AM, Kefeng Wang wrote:
[...]
>>
>> [QUESTION]
>>
>> SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
>>                 const unsigned long __user *, old_nodes,
>>                 const unsigned long __user *, new_nodes)
>> {
>>         return kernel_migrate_pages(pid, maxnode, old_nodes, new_nodes);
>> }
>>
>> The migrate_pages() takes pid argument, witch is the ID of the process
>> whose pages are to be moved. should the cpuset_mems_allowed(current) be
>> cpuset_mems_allowed(task)?
> 
> The check for cpuset_mems_allowed(task) is just above the code you change, so
> the new nodes have to be subset of the target task's cpuset.
> But they also have to be allowed by the calling task's cpuset. In manpage of
> migrate_pages(2), this is hinted by the NOTES "Use get_mempolicy(2) with the
> MPOL_F_MEMS_ALLOWED flag to obtain the set of nodes that are allowed by the
> calling process's cpuset..."
> 
> But perhaps the manpage should be better clarified:
> 
> - the EINVAL case includes "Or, none of the node IDs specified by new_nodes are
> on-line and allowed by the process's current cpuset context, or none of the
> specified nodes contain memory." - this should probably say "calling process" to
> disambiguate
> - the EPERM case should mention that new_nodes have to be subset of the target
> process' cpuset context. The caller should also have CAP_SYS_NICE and
> ptrace_may_access()

Get it, thanks for your detail explanation.

> 
