From: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 0/3] userfaultfd: allow to forbid unprivileged users
Date: Tue, 12 Mar 2019 20:43:02 +0800
Message-ID: <20190312124302.GA2433@xz-x1>
References: <20190311093701.15734-1-peterx@redhat.com>
 <20190312074951.i2md3npcjcceywqj@kshutemo-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190312074951.i2md3npcjcceywqj@kshutemo-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Maxime Coquelin <maxime.coquelin@redhat.com>, kvm@vger.kernel.org, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, linux-mm@kvack.org, Marty McFadden <mcfadden8@llnl.gov>, Maya Gokhale <gokhale2@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, "Dr . David Alan Gilbert" <dgilbert@redhat.com>Andr
List-Id: linux-api@vger.kernel.org

Hi, Kirill,

On Tue, Mar 12, 2019 at 10:49:51AM +0300, Kirill A. Shutemov wrote:
> On Mon, Mar 11, 2019 at 05:36:58PM +0800, Peter Xu wrote:
> > Hi,
> > 
> > (The idea comes from Andrea, and following discussions with Mike and
> >  other people)
> > 
> > This patchset introduces a new sysctl flag to allow the admin to
> > forbid users from using userfaultfd:
> > 
> >   $ cat /proc/sys/vm/unprivileged_userfaultfd
> >   [disabled] enabled kvm
> 
> CC linux-api@
> 
> This is unusual way to return current value for sysctl. Does it work fine
> with sysctl tool?

It can work, though it displays the same as "cat":

$ sysctl vm.unprivileged_userfaultfd
vm.unprivileged_userfaultfd = disabled enabled [kvm] 

> 
> Have you considered to place the switch into /sys/kernel/mm instead?
> I doubt it's the last tunable for userfaultfd. Maybe we should have an
> directory for it under /sys/kernel/mm?

I haven't thought about sysfs, if that's preferred I can consider to
switch to that.  And yes I think creating a directory should be a good
idea.

Thanks,

-- 
Peter Xu
