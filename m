From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH v2 0/7] mm: process_vm_mmap() -- syscall for duplication a
 process mapping
Date: Thu, 23 May 2019 19:11:37 +0300
Message-ID: <4b0a2b23-abc7-fa0d-5e30-74741331e7e5@virtuozzo.com>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
 <20190522152254.5cyxhjizuwuojlix@box>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522152254.5cyxhjizuwuojlix@box>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, mhocko@suse.com, keith.busch@intel.com, kirill.shutemov@linux.intel.com, alexander.h.duyck@linux.intel.com, ira.weiny@intel.com, andreyknvl@google.com, arunks@codeaurora.org, vbabka@suse.cz, cl@linux.com, riel@surriel.com, keescook@chromium.org, hannes@cmpxchg.org, npiggin@gmail.com, mathieu.desnoyers@efficios.com, shakeelb@google.com, guro@fb.com, aarcange@redhat.com, hughd@google.com, jglisse@redhat.com, mgorman@techsingularity.net, daniel.m.jordan@oracle.com, jannh@google.com, kilobyte@angband.pl, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On 22.05.2019 18:22, Kirill A. Shutemov wrote:
> On Mon, May 20, 2019 at 05:00:01PM +0300, Kirill Tkhai wrote:
>> This patchset adds a new syscall, which makes possible
>> to clone a VMA from a process to current process.
>> The syscall supplements the functionality provided
>> by process_vm_writev() and process_vm_readv() syscalls,
>> and it may be useful in many situation.
> 
> Kirill, could you explain how the change affects rmap and how it is safe.
> 
> My concern is that the patchset allows to map the same page multiple times
> within one process or even map page allocated by child to the parrent.
> 
> It was not allowed before.
>
> In the best case it makes reasoning about rmap substantially more difficult.

I don't think here is big impact from process relationships, because of
as it existed before, the main rule of VMA chaining is that VMA is younger
or older each other. For example, reusing of anon_vma in anon_vma_clone()
may be done either children or siblings. Also, it is possible reparenting
after some of processes dies; or splitting two branches of processes having
the same grand parent into two chains after the grand parent dies, so it looks
there should be many combinations already available.

Mapping of the same page multiple times is a different thing, and it was never
allowed for rmap.

Could you please say more specifically what looks suspicious for you and I'll
try to answer then? Otherwise, it's possible to write explanations as big as
a dissertation and to miss all answers to that is interested for you :)

> 
> But I'm worry it will introduce hard-to-debug bugs, like described in
> https://lwn.net/Articles/383162/.

I read the article, but there are a lot of messages in thread, I'm not sure,
that found the actual fix there. But it looks like one of the fixes may be
be usage of anon_vma->root in __page_set_anon_rmap().

> Note, that is some cases we care about rmap walk order (see for instance
> mremap() case). I'm not convinced that the feature will not break
> something in the area.

Yeah, thanks for pointing, I'll check this.

Kirill
