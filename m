From: Waiman Long <longman@redhat.com>
Subject: [PATCH v5 0/5] cgroup: Introducing bypass mode
Date: Mon, 10 Dec 2018 16:40:53 -0500
Message-ID: <1544478058-24252-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Shakeel Butt <shakeelb@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Waiman Long <longman@redhat.com>
List-Id: linux-api@vger.kernel.org

 v5:
  - Fix a bug in css_create() reported by Dan Carpenter.

 v4:
  - Rebased to the latest for-4.21 branch of cgroup tree.
  - Make each controller explicitly opt in to become bypassable by
    setting the bypassable cgroup_subsys flag. Currently, only cpu
    controller is made bypassable.
  - Break out the cgroup_v2.rst documentation update as separate patch.

 v3:
  - Remove invalid cgroup subdirectory creation patch.
  - Add use cases for the bypass mode and removing statements about
    control files ownership in cgroup-v2.txt.
  - Restrict bypass mode to non-domain (threaded) controllers only.

 v3 patch - https://lkml.org/lkml/2017/8/9/604
 v4 patch - https://lkml.org/lkml/2018/11/20/1361

This patchset introduces a new bypass mode to the cgroup v2 core to
give more freedom and flexibility to controllers which choose to become
bypassable the freedom to shape their own unique views of the virtual
cgroup hierarchies that can best suit thier own use cases.

Because of the inherent performance overhead in enabling cpu controller,
it is made bypassable so that the controller only needs to be enabled
at those cgroups that really need it instead of in every cgroups at a
given layer if at least one of them needs it.

The cpu controller performance problem is one of the major issues
in migrating from cgroup v1 to v2.

For example,

  R - A(+) - B(#) - C(+)
                  \ D(#)

where "+" means the controller is enabled and "#" means the controller
is bypassed. For this controller's perspective, the cgroups are
equivalent to:

  R - A|B|D - C

Underneath the root R, cgoups A, B and D are controlled by one set of
knobs and cgroup C is controlled by another set of knobs as a child of
cgroups A|B|C.

This patchset is layered on top of the "for-4.21" branch of Tejun's
cgroup git tree.

Patch 1 introduces a new bypass mode that allows a bypassable
controller to be disabled in a cgroup, but to be re-enabled again in its
children. This is enabled by writing the controller name prefixed with
'#' to the "cgroup.subtree_control" file. Then all its children will
have this controller in bypass mode.

Patch 2 extends the bypass mode mechanism to allow those child cgroups
that are put into the bypass mode for a particular bypassable controller
by their parent to be re-enabled again by writing the controller name
with the '+' prefix to the "cgroup.controllers" file.

Patch 3 extends the debug controller to expose additional controller
masks introduced by this patchset.

Patch 4 makes the cpu controller bypassable.

Patch 5 documents the new bypass mode in cgroup-v2.rst file.

Waiman Long (5):
  cgroup: subtree_control bypass mode for bypassable controllers
  cgroup: Allow reenabling of controller in bypass mode
  cgroup: Make debug controller report new controller masks
  sched/core: Make cpu cgroup controller bypassable
  cgroup: Document bypass mode

 Documentation/admin-guide/cgroup-v2.rst |  66 +++++---
 include/linux/cgroup-defs.h             |  26 +++-
 kernel/cgroup/cgroup.c                  | 258 +++++++++++++++++++++++++-------
 kernel/cgroup/debug.c                   |   2 +
 kernel/sched/core.c                     |   1 +
 5 files changed, 279 insertions(+), 74 deletions(-)

-- 
1.8.3.1
