From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH, v8 0/3] *** SUBJECT HERE ***
Date: Thu, 3 Mar 2011 16:20:30 +0200
Message-ID: <20110303142030.GA9980@shutemov.name>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1299161947-9903-1-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2011 at 04:19:04PM +0200, Kirill A. Shutsemov wrote:
> From: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> 
> *** BLURB HERE ***

Oops.

Changelog:

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

> Kirill A. Shutemov (3):
>   hrtimer: introduce effective timer slack
>   hrtimer: implement PR_GET_EFFECTIVE_TIMERSLACK
>   cgroups: introduce timer slack controller
> 
>  Documentation/cgroups/timer_slack.txt |   64 +++++++++++++++++
>  fs/select.c                           |    7 +--
>  include/linux/cgroup_subsys.h         |    6 ++
>  include/linux/prctl.h                 |    6 ++
>  include/linux/sched.h                 |   10 +++
>  init/Kconfig                          |    8 ++
>  kernel/Makefile                       |    1 +
>  kernel/cgroup_timer_slack.c           |  124 +++++++++++++++++++++++++++++++++
>  kernel/fork.c                         |    4 +
>  kernel/futex.c                        |    4 +-
>  kernel/hrtimer.c                      |    2 +-
>  kernel/sys.c                          |    3 +
>  12 files changed, 231 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/cgroups/timer_slack.txt
>  create mode 100644 kernel/cgroup_timer_slack.c
> 
> -- 
> 1.7.4.1
> 

-- 
 Kirill A. Shutemov
