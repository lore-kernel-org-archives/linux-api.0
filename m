From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v2 1/1] userfaultfd/sysctl: add
 vm.unprivileged_userfaultfd
Date: Tue, 19 Mar 2019 18:28:23 +0000
Message-ID: <20190319182822.GK2727@work-vm>
References: <20190319030722.12441-1-peterx@redhat.com>
 <20190319030722.12441-2-peterx@redhat.com>
 <20190319110236.b6169d6b469a587a852c7e09@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190319110236.b6169d6b469a587a852c7e09@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Maxime Coquelin <maxime.coquelin@redhat.com>, Maya Gokhale <gokhale2@llnl.gov>, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, linux-mm@kvack.org, Marty McFadden <mcfadden8@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, "Kirill A . Shutemov" <kirill@shutemov.name>, linux-api@vger.kernel
List-Id: linux-api@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 19 Mar 2019 11:07:22 +0800 Peter Xu <peterx@redhat.com> wrote:
> 
> > Add a global sysctl knob "vm.unprivileged_userfaultfd" to control
> > whether userfaultfd is allowed by unprivileged users.  When this is
> > set to zero, only privileged users (root user, or users with the
> > CAP_SYS_PTRACE capability) will be able to use the userfaultfd
> > syscalls.
> 
> Please send along a full description of why you believe Linux needs
> this feature, for me to add to the changelog.  What is the benefit to
> our users?  How will it be used?
> 
> etcetera.  As it was presented I'm seeing no justification for adding
> the patch!

How about:

---
Userfaultfd can be misued to make it easier to exploit existing use-after-free
(and similar) bugs that might otherwise only make a short window
or race condition available.  By using userfaultfd to stall a kernel
thread, a malicious program can keep some state, that it wrote, stable
for an extended period, which it can then access using an existing
exploit.   While it doesn't cause the exploit itself, and while it's not
the only thing that can stall a kernel thread when accessing a memory location,
it's one of the few that never needs priviledge.

Add a flag, allowing userfaultfd to be restricted, so that in general 
it won't be useable by arbitrary user programs, but in environments that
require userfaultfd it can be turned back on.

---

Dave

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
