From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH v2 1/7] mm: Add process_vm_mmap() syscall declaration
Date: Tue, 21 May 2019 11:29:09 +0300
Message-ID: <4c35e953-5f59-0202-3f75-f9ccf7df798f@virtuozzo.com>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
 <155836080726.2441.11153759042802992469.stgit@localhost.localdomain>
 <20190521002827.GA30518@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190521002827.GA30518@iweiny-DESK2.sc.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, mhocko@suse.com, keith.busch@intel.com, kirill.shutemov@linux.intel.com, alexander.h.duyck@linux.intel.com, andreyknvl@google.com, arunks@codeaurora.org, vbabka@suse.cz, cl@linux.com, riel@surriel.com, keescook@chromium.org, hannes@cmpxchg.org, npiggin@gmail.com, mathieu.desnoyers@efficios.com, shakeelb@google.com, guro@fb.com, aarcange@redhat.com, hughd@google.com, jglisse@redhat.com, mgorman@techsingularity.net, daniel.m.jordan@oracle.com, jannh@google.com, kilobyte@angband.pl, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

Hi, Ira,

On 21.05.2019 03:28, Ira Weiny wrote:
> On Mon, May 20, 2019 at 05:00:07PM +0300, Kirill Tkhai wrote:
>> Similar to process_vm_readv() and process_vm_writev(),
>> add declarations of a new syscall, which will allow
>> to map memory from or to another process.
> 
> Shouldn't this be the last patch in the series so that the syscall is actually
> implemented first?

It looks like there is no dependencies in the last patch to declarations made
in the first patch, so we really can move it.

I'll make this after there are accumulated some commentaries about the logic
to reduce number of patch series.

[...]

Thanks,
Kirill
