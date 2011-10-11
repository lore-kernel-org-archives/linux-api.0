From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, v10 0/3] Introduce timer slack controller
Date: Tue, 11 Oct 2011 19:15:26 +0300
Message-ID: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, lennart@poettering.net, harald@redhat.com, david@fubar.dk, greg@kroah.com, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

Changelog:

v10 [7 month later, thanks to A Plumber's Wish List]:
 - rebased to linux-next-20111011
v9:
 - update documentation
 - minor cleanup
v8:
 - change hiearchy rules
 - introduce timer_slack.effective_slack_ns
 - get_task_timer_slack() -> task_get_effective_timer_slack()
 - task_get_effective_timer_slack() splited in separate patch
 - implement PR_GET_EFFECTIVE_TIMERSLACK
v7:
 - totally reworked interface and rewritten from scratch
   (See Documentation/cgroups/timer_slack.txt for more information)
v6:
 - add documentation
 - use notifier_call_chain() instead of check hook
 - fix validate_change()
 - cleanup
v5:
 - -EBUSY on writing to timer_slack.min_slack_ns/max_slack_ns if a child has
   wider min-max range
v4:
 - hierarchy support
 - drop dummy_timer_slack_check()
 - workaround lockdep false (?) positive
 - allow 0 as timer slack value
v3:
 - rework interface
 - s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL/
v2:
 - fixed with CONFIG_CGROUP_TIMER_SLACK=y
v1:
 - initial revision

Kirill A. Shutemov (3):
  hrtimer: introduce effective timer slack
  hrtimer: implement PR_GET_EFFECTIVE_TIMERSLACK
  cgroups: introduce timer slack controller

 Documentation/cgroups/timer_slack.txt |   72 +++++++++++++++++++
 fs/select.c                           |    7 +--
 include/linux/cgroup_subsys.h         |    7 ++
 include/linux/prctl.h                 |    6 ++
 include/linux/sched.h                 |   10 +++
 init/Kconfig                          |    8 ++
 kernel/Makefile                       |    1 +
 kernel/cgroup_timer_slack.c           |  124 +++++++++++++++++++++++++++++++++
 kernel/fork.c                         |    4 +
 kernel/futex.c                        |    4 +-
 kernel/hrtimer.c                      |    2 +-
 kernel/sys.c                          |    3 +
 12 files changed, 240 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/cgroups/timer_slack.txt
 create mode 100644 kernel/cgroup_timer_slack.c

-- 
1.7.6.3
