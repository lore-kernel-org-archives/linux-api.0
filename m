From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 1/1] userfaultfd/sysctl: add
 vm.unprivileged_userfaultfd
Date: Thu, 21 Mar 2019 17:06:17 -0400
Message-ID: <20190321210617.GB22094@redhat.com>
References: <20190319030722.12441-1-peterx@redhat.com>
 <20190319030722.12441-2-peterx@redhat.com>
 <20190319110236.b6169d6b469a587a852c7e09@linux-foundation.org>
 <20190319182822.GK2727@work-vm>
 <20190320190112.GD23793@redhat.com>
 <20190321134335.GB1146@42.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190321134335.GB1146@42.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Maxime Coquelin <maxime.coquelin@redhat.com>, Maya Gokhale <gokhale2@llnl.gov>, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, linux-mm@kvack.org, Marty McFadden <mcfadden8@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, "Kirill A . Shutemov" <kirill@shutemov.name>, linux-ap
List-Id: linux-api@vger.kernel.org

Hello,

On Thu, Mar 21, 2019 at 01:43:35PM +0000, Luis Chamberlain wrote:
> On Wed, Mar 20, 2019 at 03:01:12PM -0400, Andrea Arcangeli wrote:
> > but
> > that would be better be achieved through SECCOMP and not globally.'.
> 
> That begs the question why not use seccomp for this? What if everyone
> decided to add a knob for all syscalls to do the same? For the commit
> log, why is it OK then to justify a knob for this syscall?

That's a good point and it's obviously more secure because you can
block a lot more than just bpf and userfaultfd: however not all
syscalls have CONFIG_USERFAULTFD=n or CONFIG_BPF_SYSCALL=n that you
can set to =n at build time, then they'll return -ENOSYS (implemented
as sys_ni_syscall in the =n case).

The point of the bpf (already included upstream) and userfaultfd
(proposed) sysctl is to avoid users having to rebuild the kernel if
they want to harden their setup without being forced to run all
containers under seccomp, just like they could by setting those two
config options "=n" at build time.

So you can see it like allowing a runtime selection of
CONFIG_USERFAULTFD and CONFIG_BPF_SYSCALL without the kernel build
time config forcing the decision on behalf of the end user.

Thanks,
Andrea
