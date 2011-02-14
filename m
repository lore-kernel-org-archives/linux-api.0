From: "Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: [PATCH, v6 0/3] Introduce timer slack controller
Date: Mon, 14 Feb 2011 15:06:24 +0200
Message-ID: <1297688787-3592-1-git-send-email-kirill@shutemov.name>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>


Changelog:

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
  cgroups: export cgroup_iter_{start,next,end}
  Implement timer slack notifier chain
  cgroups: introduce timer slack controller

 Documentation/cgroups/timer_slack.txt |   93 +++++++++++
 include/linux/cgroup_subsys.h         |    6 +
 include/linux/sched.h                 |    5 +
 init/Kconfig                          |   10 ++
 kernel/Makefile                       |    3 +-
 kernel/cgroup.c                       |    3 +
 kernel/cgroup_timer_slack.c           |  285 +++++++++++++++++++++++++++++++++
 kernel/sys.c                          |    9 +-
 kernel/timer_slack.c                  |   57 +++++++
 9 files changed, 463 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/cgroups/timer_slack.txt
 create mode 100644 kernel/cgroup_timer_slack.c
 create mode 100644 kernel/timer_slack.c

-- 
1.7.4
