From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 1/1] userfaultfd/sysctl: add
 vm.unprivileged_userfaultfd
Date: Tue, 19 Mar 2019 14:07:29 -0400
Message-ID: <20190319180729.GA27618@redhat.com>
References: <20190319030722.12441-1-peterx@redhat.com>
 <20190319030722.12441-2-peterx@redhat.com>
 <20190319071104.GA6392@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190319071104.GA6392@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Maxime Coquelin <maxime.coquelin@redhat.com>, Maya Gokhale <gokhale2@llnl.gov>, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, linux-mm@kvack.org, Marty McFadden <mcfadden8@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, "Kirill A . Shutemov" <kirill@shutemov.name>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dr
List-Id: linux-api@vger.kernel.org

Hello,

On Tue, Mar 19, 2019 at 09:11:04AM +0200, Mike Rapoport wrote:
> Hi Peter,
> 
> On Tue, Mar 19, 2019 at 11:07:22AM +0800, Peter Xu wrote:
> > Add a global sysctl knob "vm.unprivileged_userfaultfd" to control
> > whether userfaultfd is allowed by unprivileged users.  When this is
> > set to zero, only privileged users (root user, or users with the
> > CAP_SYS_PTRACE capability) will be able to use the userfaultfd
> > syscalls.
> > 
> > Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
> > Suggested-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> 
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> 
> Just one minor note below

This looks fine with me too.

> > +	if (!sysctl_unprivileged_userfaultfd && !capable(CAP_SYS_PTRACE))
> > +		return -EPERM;

The only difference between the bpf sysctl and the userfaultfd sysctl
this way is that the bpf sysctl adds the CAP_SYS_ADMIN capability
requirement, while userfaultfd adds the CAP_SYS_PTRACE requirement,
because the userfaultfd monitor is more likely to need CAP_SYS_PTRACE
already if it's doing other kind of tracking on processes runtime, in
addition of userfaultfd. In other words both syscalls works only for
root, when the two sysctl are opt-in set to 1.

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
