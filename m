From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v2 0/7] mm: process_vm_mmap() -- syscall for duplication
 a process mapping
Date: Wed, 22 May 2019 18:22:54 +0300
Message-ID: <20190522152254.5cyxhjizuwuojlix@box>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, mhocko@suse.com, keith.busch@intel.com, kirill.shutemov@linux.intel.com, alexander.h.duyck@linux.intel.com, ira.weiny@intel.com, andreyknvl@google.com, arunks@codeaurora.org, vbabka@suse.cz, cl@linux.com, riel@surriel.com, keescook@chromium.org, hannes@cmpxchg.org, npiggin@gmail.com, mathieu.desnoyers@efficios.com, shakeelb@google.com, guro@fb.com, aarcange@redhat.com, hughd@google.com, jglisse@redhat.com, mgorman@techsingularity.net, daniel.m.jordan@oracle.com, jannh@google.com, kilobyte@angband.pl, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Mon, May 20, 2019 at 05:00:01PM +0300, Kirill Tkhai wrote:
> This patchset adds a new syscall, which makes possible
> to clone a VMA from a process to current process.
> The syscall supplements the functionality provided
> by process_vm_writev() and process_vm_readv() syscalls,
> and it may be useful in many situation.

Kirill, could you explain how the change affects rmap and how it is safe.

My concern is that the patchset allows to map the same page multiple times
within one process or even map page allocated by child to the parrent.

It was not allowed before.

In the best case it makes reasoning about rmap substantially more difficult.

But I'm worry it will introduce hard-to-debug bugs, like described in
https://lwn.net/Articles/383162/.

Note, that is some cases we care about rmap walk order (see for instance
mremap() case). I'm not convinced that the feature will not break
something in the area.

-- 
 Kirill A. Shutemov
