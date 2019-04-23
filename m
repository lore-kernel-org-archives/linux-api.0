From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/1] userfaultfd/sysctl: add vm.unprivileged_userfaultfd
Date: Tue, 23 Apr 2019 15:19:15 -0700
Message-ID: <CAGXu5jJbgmq1QS-+FO7Oe9KLrAmT+ivUjSochmHBgbvHkuj+VQ@mail.gmail.com>
References: <20190319030722.12441-1-peterx@redhat.com> <20190319030722.12441-2-peterx@redhat.com>
 <20190319110236.b6169d6b469a587a852c7e09@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190319110236.b6169d6b469a587a852c7e09@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Maxime Coquelin <maxime.coquelin@redhat.com>, Maya Gokhale <gokhale2@llnl.gov>, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, Linux-MM <linux-mm@kvack.org>, Marty McFadden <mcfadden8@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, "Kirill A . Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 19, 2019 at 11:02 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
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

Was there a v3 of this patch? I'd still really like to have this knob added. :)

Thanks!

-- 
Kees Cook
