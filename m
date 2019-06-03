From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH v2 0/7] mm: process_vm_mmap() -- syscall for duplication a
 process mapping
Date: Mon, 3 Jun 2019 17:56:32 +0300
Message-ID: <5ae7e3c1-3875-ea1e-54b3-ac3c493a11f0@virtuozzo.com>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
 <20190522152254.5cyxhjizuwuojlix@box>
 <4228b541-d31c-b76a-2570-1924df0d4724@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4228b541-d31c-b76a-2570-1924df0d4724@virtuozzo.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, mhocko@suse.com, keith.busch@intel.com, kirill.shutemov@linux.intel.com, alexander.h.duyck@linux.intel.com, ira.weiny@intel.com, andreyknvl@google.com, arunks@codeaurora.org, vbabka@suse.cz, cl@linux.com, riel@surriel.com, keescook@chromium.org, hannes@cmpxchg.org, npiggin@gmail.com, mathieu.desnoyers@efficios.com, shakeelb@google.com, guro@fb.com, aarcange@redhat.com, hughd@google.com, jglisse@redhat.com, mgorman@techsingularity.net, daniel.m.jordan@oracle.com, jannh@google.com, kilobyte@angband.pl, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On 03.06.2019 17:38, Kirill Tkhai wrote:
> On 22.05.2019 18:22, Kirill A. Shutemov wrote:
>> On Mon, May 20, 2019 at 05:00:01PM +0300, Kirill Tkhai wrote:
>>> This patchset adds a new syscall, which makes possible
>>> to clone a VMA from a process to current process.
>>> The syscall supplements the functionality provided
>>> by process_vm_writev() and process_vm_readv() syscalls,
>>> and it may be useful in many situation.
>>
>> Kirill, could you explain how the change affects rmap and how it is safe.
>>
>> My concern is that the patchset allows to map the same page multiple times
>> within one process or even map page allocated by child to the parrent.
> 
> Speaking honestly, we already support this model, since ZERO_PAGE() may
> be mapped multiply times in any number of mappings.

Picking of huge_zero_page and mremapping its VMA to unaligned address also gives
the case, when the same huge page is mapped as huge page and as set of ordinary
pages in the same process.

Summing up two above cases, is there really a fundamental problem with
the functionality the patch set introduces? It looks like we already have
these cases in stable kernel supported.

Thanks,
Kirill
