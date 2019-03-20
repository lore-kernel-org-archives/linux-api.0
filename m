From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 1/1] userfaultfd/sysctl: add
 vm.unprivileged_userfaultfd
Date: Wed, 20 Mar 2019 15:01:12 -0400
Message-ID: <20190320190112.GD23793@redhat.com>
References: <20190319030722.12441-1-peterx@redhat.com>
 <20190319030722.12441-2-peterx@redhat.com>
 <20190319110236.b6169d6b469a587a852c7e09@linux-foundation.org>
 <20190319182822.GK2727@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190319182822.GK2727@work-vm>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Maxime Coquelin <maxime.coquelin@redhat.com>, Maya Gokhale <gokhale2@llnl.gov>, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, linux-mm@kvack.org, Marty McFadden <mcfadden8@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, "Kirill A . Shutemov" <kirill@shutemov.name>, linux-api@vger.ker
List-Id: linux-api@vger.kernel.org

Hello,

On Tue, Mar 19, 2019 at 06:28:23PM +0000, Dr. David Alan Gilbert wrote:
> ---
> Userfaultfd can be misued to make it easier to exploit existing use-after-free
> (and similar) bugs that might otherwise only make a short window
> or race condition available.  By using userfaultfd to stall a kernel
> thread, a malicious program can keep some state, that it wrote, stable
> for an extended period, which it can then access using an existing
> exploit.   While it doesn't cause the exploit itself, and while it's not
> the only thing that can stall a kernel thread when accessing a memory location,
> it's one of the few that never needs priviledge.
> 
> Add a flag, allowing userfaultfd to be restricted, so that in general 
> it won't be useable by arbitrary user programs, but in environments that
> require userfaultfd it can be turned back on.

The default in the patch leaves userfaultfd enabled to all users, so
it may be clearer to reverse the last sentence to "in hardened
environments it allows to restrict userfaultfd to privileged processes.".

We can also make example that 'While this is not a kernel issue, in
practice unless you also "chmod u-s /usr/bin/fusermount" there's no
tangible benefit in removing privileges for userfaultfd, other than
probabilistic ones by decreasig the attack surface of the kernel, but
that would be better be achieved through SECCOMP and not globally.'.
