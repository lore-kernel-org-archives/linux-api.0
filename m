From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH v4 0/5] cgroup: Introducing bypass mode
Date: Wed, 21 Nov 2018 15:27:15 +0100
Message-ID: <CAHO5Pa1axpoweQuO7A9K2yv+HvSkVXCkXS5f6Ag3fA1_SjPcuA@mail.gmail.com>
References: <1542736289-31338-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542736289-31338-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: longman@redhat.com
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc <linux-doc@vger.kernel.org>, guro@fb.com, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>, dennis@kernel.org, shakeelb@google.com, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@vger.kernel.org]

Hi Waiman,

Since this is a kernel-user-space API change, for all future
iterations of this patch, please CC linux-api@.

The kernel source file Documentation/SubmitChecklist notes that all
Linux kernel patches that change userspace interfaces should be CCed
to linux-api@vger.kernel.org, so that the various parties who are
interested in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Thanks,

Michael
On Tue, Nov 20, 2018 at 8:45 PM Waiman Long <longman@redhat.com> wrote:
>
>  v4:
>   - Rebased to the latest for-4.21 branch of cgroup tree.
>   - Make each controller explicitly opt in to become bypassable by
>     setting the bypassable cgroup_subsys flag. Currently, only cpu
>     controller is made bypassable.
>   - Break out the cgroup_v2.rst documentation update as separate patch.
>
>  v3:
>   - Remove invalid cgroup subdirectory creation patch.
>   - Add use cases for the bypass mode and removing statements about
>     control files ownership in cgroup-v2.txt.
>   - Restrict bypass mode to non-domain (threaded) controllers only.
>
>  v3 patch - https://lkml.org/lkml/2017/8/9/604
>
> This patchset introduces a new bypass mode to the cgroup v2 core to
> give more freedom and flexibility to controllers which choose to become
> bypassable the freedom to shape their own unique views of the virtual
> cgroup hierarchies that can best suit thier own use cases.
>
> Because of the inherent performance overhead in enabling cpu controller,
> it is made bypassable so that the controller only needs to be enabled
> at those cgroups that really need it instead of in every cgroups at a
> given layer if at least one of them needs it.
>
> The cpu controller performance problem is one of the major issues
> in migrating from cgroup v1 to v2.
>
> For example,
>
>   R - A(+) - B(#) - C(+)
>                   \ D(#)
>
> where "+" means the controller is enabled and "#" means the controller
> is bypassed. For this controller's perspective, the cgroups are
> equivalent to:
>
>   R - A|B|D - C
>
> Underneath the root R, cgoups A, B and D are controlled by one set of
> knobs and cgroup C is controlled by another set of knobs as a child of
> cgroups A|B|C.
>
> This patchset is layered on top of the "for-4.21" branch of Tejun's
> cgroup git tree.
>
> Patch 1 introduces a new bypass mode that allows a bypassable
> controller to be disabled in a cgroup, but to be re-enabled again in its
> children. This is enabled by writing the controller name prefixed with
> '#' to the "cgroup.subtree_control" file. Then all its children will
> have this controller in bypass mode.
>
> Patch 2 extends the bypass mode mechanism to allow those child cgroups
> that are put into the bypass mode for a particular bypassable controller
> by their parent to be re-enabled again by writing the controller name
> with the '+' prefix to the "cgroup.controllers" file.
>
> Patch 3 extends the debug controller to expose additional controller
> masks introduced by this patchset.
>
> Patch 4 makes the cpu controller bypassable.
>
> Patch 5 documents the new bypass mode in cgroup-v2.rst file.
>
> Waiman Long (5):
>   cgroup: subtree_control bypass mode for bypassable controllers
>   cgroup: Allow reenabling of controller in bypass mode
>   cgroup: Make debug controller report new controller masks
>   sched/core: Make cpu cgroup controller bypassable
>   cgroup: Document bypass mode
>
>  Documentation/admin-guide/cgroup-v2.rst |  66 +++++---
>  include/linux/cgroup-defs.h             |  26 +++-
>  kernel/cgroup/cgroup.c                  | 256 +++++++++++++++++++++++++-------
>  kernel/cgroup/debug.c                   |   2 +
>  kernel/sched/core.c                     |   1 +
>  5 files changed, 276 insertions(+), 75 deletions(-)
>
> --
> 1.8.3.1
>


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
