From: Peter Xu <peterx@redhat.com>
Subject: [PATCH v2 0/1] userfaultfd: allow to forbid unprivileged users
Date: Tue, 19 Mar 2019 11:07:21 +0800
Message-ID: <20190319030722.12441-1-peterx@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Maxime Coquelin <maxime.coquelin@redhat.com>, Maya Gokhale <gokhale2@llnl.gov>, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, peterx@redhat.com, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, linux-mm@kvack.org, Marty McFadden <mcfadden8@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, "Kirill A . Shutemov" <kirill@shutemov.name>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dr
List-Id: linux-api@vger.kernel.org

Hi,

This is the second version of the work.  V1 was here:

https://lkml.org/lkml/2019/3/11/207

I removed CC to kvm list since not necessary any more, but added
linux-api to the list as suggested by Kirill.

This one greatly simplifies the previous version, dropped the kvm
special entry and mimic the sysctl_unprivileged_bpf_disabled knob for
userfaultfd as suggested by many.  The major differences comparing to
the BPF flag are: (1) use PTRACE instead of ADMIN capability, and (2)
allow to switch the flag back and forth (BPF does not allow to switch
back to "enabled" if "disabled" once).

So the main idea of this simpler version is that we still keep the old
way as is by default but we only provide a way for admins when they
really want to turn userfaultfd off for unprivileged users.

About procfs vs sysfs: I still used the procfs way because admins can
still leverage sysctl.conf with that and also since no one yet
explicitly asked for sysfs for a better reason yet (And I just noticed
BPF just added another bpf_stats_enabled into sysctl a few weeks ago).

Please have a look, thanks.

Peter Xu (1):
  userfaultfd/sysctl: add vm.unprivileged_userfaultfd

 Documentation/sysctl/vm.txt   | 12 ++++++++++++
 fs/userfaultfd.c              |  5 +++++
 include/linux/userfaultfd_k.h |  2 ++
 kernel/sysctl.c               | 12 ++++++++++++
 4 files changed, 31 insertions(+)

-- 
2.17.1
