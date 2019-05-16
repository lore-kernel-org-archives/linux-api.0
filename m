From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH RFC 0/5] mm: process_vm_mmap() -- syscall for duplication
 a process mapping
Date: Thu, 16 May 2019 17:22:23 +0300
Message-ID: <85562807-2a13-9aa2-e67d-15513c766eae@virtuozzo.com>
References: <155793276388.13922.18064660723547377633.stgit@localhost.localdomain>
 <20190516133034.GT16651@dhcp22.suse.cz>
 <20190516135259.GU16651@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516135259.GU16651@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, keith.busch@intel.com, kirill.shutemov@linux.intel.com, pasha.tatashin@oracle.com, alexander.h.duyck@linux.intel.com, ira.weiny@intel.com, andreyknvl@google.com, arunks@codeaurora.org, vbabka@suse.cz, cl@linux.com, riel@surriel.com, keescook@chromium.org, hannes@cmpxchg.org, npiggin@gmail.com, mathieu.desnoyers@efficios.com, shakeelb@google.com, guro@fb.com, aarcange@redhat.com, hughd@google.com, jglisse@redhat.com, mgorman@techsingularity.net, daniel.m.jordan@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 16.05.2019 16:52, Michal Hocko wrote:
> On Thu 16-05-19 15:30:34, Michal Hocko wrote:
>> [You are defining a new user visible API, please always add linux-api
>>  mailing list - now done]
>>
>> On Wed 15-05-19 18:11:15, Kirill Tkhai wrote:
> [...]
>>> The proposed syscall aims to introduce an interface, which
>>> supplements currently existing process_vm_writev() and
>>> process_vm_readv(), and allows to solve the problem with
>>> anonymous memory transfer. The above example may be rewritten as:
>>>
>>> 	void *buf;
>>>
>>> 	buf = mmap(NULL, n * PAGE_SIZE, PROT_READ|PROT_WRITE,
>>> 		   MAP_PRIVATE|MAP_ANONYMOUS, ...);
>>> 	recv(sock, buf, n * PAGE_SIZE, 0);
>>>
>>> 	/* Sign of @pid is direction: "from @pid task to current" or vice versa. */
>>> 	process_vm_mmap(-pid, buf, n * PAGE_SIZE, remote_addr, PVMMAP_FIXED);
>>> 	munmap(buf, n * PAGE_SIZE);
> 
> AFAIU this means that you actually want to do an mmap of an anonymous
> memory with a COW semantic to the remote process right?

Yes.

> How does the remote process find out where and what has been mmaped?

Any way. Isn't this a trivial task? :) You may use socket or any
of appropriate linux features to communicate between them.

>What if the range collides? This sounds quite scary to me TBH.

In case of range collides, the part of old VMA becomes unmapped.
The same way we behave on ordinary mmap. You may intersect a range,
which another thread mapped, so you need a synchronization between
them. There is no a principle difference.

Also I'm going to add a flag to prevent unmapping like Kees suggested.
Please, see his message.

> Why cannot you simply use shared memory for that?

Because of remote task may want specific type of VMA. It may want not to
share a VMA with its children.

Speaking about online migration, a task wants its anonymous private VMAs
remain the same after the migration. Otherwise, imagine the situation,
when task's stack becomes a shared VMA after the migration.
Also, task wants anonymous mapping remains anonymous.

In general, in case of shared memory is enough for everything, we would
have never had process_vm_writev() and process_vm_readv() syscalls.

Kirill
