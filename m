From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 0/3] userfaultfd: allow to forbid unprivileged users
Date: Tue, 12 Mar 2019 10:49:51 +0300
Message-ID: <20190312074951.i2md3npcjcceywqj@kshutemo-mobl1>
References: <20190311093701.15734-1-peterx@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190311093701.15734-1-peterx@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Maxime Coquelin <maxime.coquelin@redhat.com>, kvm@vger.kernel.org, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, linux-mm@kvack.org, Marty McFadden <mcfadden8@llnl.gov>, Maya Gokhale <gokhale2@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, "Dr . David Alan Gilbert" <dgilbert@redhat.com>Andr
List-Id: linux-api@vger.kernel.org

On Mon, Mar 11, 2019 at 05:36:58PM +0800, Peter Xu wrote:
> Hi,
> 
> (The idea comes from Andrea, and following discussions with Mike and
>  other people)
> 
> This patchset introduces a new sysctl flag to allow the admin to
> forbid users from using userfaultfd:
> 
>   $ cat /proc/sys/vm/unprivileged_userfaultfd
>   [disabled] enabled kvm

CC linux-api@

This is unusual way to return current value for sysctl. Does it work fine
with sysctl tool?

Have you considered to place the switch into /sys/kernel/mm instead?
I doubt it's the last tunable for userfaultfd. Maybe we should have an
directory for it under /sys/kernel/mm?

>   - When set to "disabled", all unprivileged users are forbidden to
>     use userfaultfd syscalls.
> 
>   - When set to "enabled", all users are allowed to use userfaultfd
>     syscalls.
> 
>   - When set to "kvm", all unprivileged users are forbidden to use the
>     userfaultfd syscalls, except the user who has permission to open
>     /dev/kvm.
> 
> This new flag can add one more layer of security to reduce the attack
> surface of the kernel by abusing userfaultfd.  Here we grant the
> thread userfaultfd permission by checking against CAP_SYS_PTRACE
> capability.  By default, the value is "disabled" which is the most
> strict policy.  Distributions can have their own perferred value.
> 
> The "kvm" entry is a bit special here only to make sure that existing
> users like QEMU/KVM won't break by this newly introduced flag.  What
> we need to do is simply set the "unprivileged_userfaultfd" flag to
> "kvm" here to automatically grant userfaultfd permission for processes
> like QEMU/KVM without extra code to tweak these flags in the admin
> code.
> 
> Patch 1:  The interface patch to introduce the flag
> 
> Patch 2:  The KVM related changes to detect opening of /dev/kvm
> 
> Patch 3:  Apply the flag to userfaultfd syscalls
> 
> All comments would be greatly welcomed.  Thanks,
> 
> Peter Xu (3):
>   userfaultfd/sysctl: introduce unprivileged_userfaultfd
>   kvm/mm: introduce MMF_USERFAULTFD_ALLOW flag
>   userfaultfd: apply unprivileged_userfaultfd check
> 
>  fs/userfaultfd.c               | 121 +++++++++++++++++++++++++++++++++
>  include/linux/sched/coredump.h |   1 +
>  include/linux/userfaultfd_k.h  |   5 ++
>  init/Kconfig                   |  11 +++
>  kernel/sysctl.c                |  11 +++
>  virt/kvm/kvm_main.c            |   7 ++
>  6 files changed, 156 insertions(+)
> 
> -- 
> 2.17.1
> 

-- 
 Kirill A. Shutemov
