From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 0/7] mm: process_vm_mmap() -- syscall for duplication a
 process mapping
Date: Thu, 23 May 2019 09:19:01 -0700
Message-ID: <CALCETrWzuH3=Uh91UeGwpCj28kjQ82Lj2OTuXm7_3d871PyZSA@mail.gmail.com>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
 <CALCETrU221N6uPmdaj4bRDDsf+Oc5tEfPERuyV24wsYKHn+spA@mail.gmail.com>
 <9638a51c-4295-924f-1852-1783c7f3e82d@virtuozzo.com> <CALCETrUMDTGRtLFocw6vnN___7rkb6r82ULehs0=yQO5PZL8MA@mail.gmail.com>
 <67d1321e-ffd6-24a3-407f-cd26c82e46b8@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <67d1321e-ffd6-24a3-407f-cd26c82e46b8@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Keith Busch <keith.busch@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, alexander.h.duyck@linux.intel.com, Weiny Ira <ira.weiny@intel.com>, Andrey Konovalov <andreyknvl@google.com>, arunks@codeaurora.org, Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, Rik van Riel <riel@surriel.com>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Nicholas Piggin <npiggin@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Hugh
List-Id: linux-api@vger.kernel.org

On Tue, May 21, 2019 at 10:44 AM Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
>
> On 21.05.2019 19:43, Andy Lutomirski wrote:
> > On Tue, May 21, 2019 at 8:52 AM Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> >>
> >> On 21.05.2019 17:43, Andy Lutomirski wrote:

> > Do you mean that the code you sent rejects this case?  If so, please
> > document it.  In any case, I looked at the code, and it seems to be
> > trying to handle MAP_SHARED and MAP_ANONYMOUS.  I don't see where it
> > would reject copying a vDSO.
>
> I prohibit all the VMAs, which contain on of flags: VM_HUGETLB|VM_DONTEXPAND|VM_PFNMAP|VM_IO.
> I'll check carefully, whether it's enough for vDSO.

I think you could make the new syscall a lot more comprehensible bg
restricting it to just MAP_ANONYMOUS, by making it unmap the source,
or possibly both.  If the new syscall unmaps the source (in order so
that the source is gone before the newly mapped pages become
accessible), then you avoid issues in which you need to define
sensible semantics for what happens if both copies are accessed
simultaneously.


--Andy
