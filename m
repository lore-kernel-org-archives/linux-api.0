From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/5] introduce memory hinting API for external process
Date: Mon, 10 Feb 2020 13:29:06 -0800
Message-ID: <20200210212906.GB48790@google.com>
References: <20200128001641.5086-1-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200128001641.5086-1-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hey Folks,


Can I get review further since I resolved most of concerns(especially,
description stuff) I got from previous iteration?

On Mon, Jan 27, 2020 at 04:16:36PM -0800, Minchan Kim wrote:
> Now, we have MADV_PAGEOUT and MADV_COLD as madvise hinting API. With that,
> application could give hints to kernel what memory range are preferred to be
> reclaimed. However, in some platform(e.g., Android), the information
> required to make the hinting decision is not known to the app.
> Instead, it is known to a centralized userspace daemon(e.g., ActivityManagerService),
> and that daemon must be able to initiate reclaim on its own without any app
> involvement.
> 
> To solve the concern, this patch introduces new syscall - process_madvise(2).
> Bascially, it's same with madvise(2) syscall but it has some differences.
> 
> 1. It needs pidfd of target process to provide the hint
> 2. It supports only MADV_{COLD|PAGEOUT|MERGEABLE|UNMEREABLE} at this moment.
>    Other hints in madvise will be opened when there are explicit requests from
>    community to prevent unexpected bugs we couldn't support.
> 3. Only privileged processes can do something for other process's address
>    space.
> 
> For more detail of the new API, please see "mm: introduce external memory hinting API"
> description in this patchset.
> 
> Minchan Kim (3):
>   mm: factor out madvise's core functionality
>   mm: introduce external memory hinting API
>   mm: support both pid and pidfd for process_madvise
> 
> Oleksandr Natalenko (2):
>   mm/madvise: employ mmget_still_valid for write lock
>   mm/madvise: allow KSM hints for remote API
> 
> * from v2 - https://lore.kernel.org/linux-mm/20200116235953.163318-1-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
>   * check signal callee and caller to bail out - Kirill Tkhai
>   * put more clarification for justification of new API
> 
> * from v1 - https://lore.kernel.org/linux-mm/20200110213433.94739-1-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
>   * fix syscall number - SeongJae
>   * use get_pid_task - Kirill Tkhai
>   * extend API to support pid as well as pidfd - Kirill Tkhai
> 
>  arch/alpha/kernel/syscalls/syscall.tbl      |   1 +
>  arch/arm/tools/syscall.tbl                  |   1 +
>  arch/arm64/include/asm/unistd.h             |   2 +-
>  arch/arm64/include/asm/unistd32.h           |   2 +
>  arch/ia64/kernel/syscalls/syscall.tbl       |   1 +
>  arch/m68k/kernel/syscalls/syscall.tbl       |   1 +
>  arch/microblaze/kernel/syscalls/syscall.tbl |   1 +
>  arch/mips/kernel/syscalls/syscall_n32.tbl   |   1 +
>  arch/mips/kernel/syscalls/syscall_n64.tbl   |   1 +
>  arch/parisc/kernel/syscalls/syscall.tbl     |   1 +
>  arch/powerpc/kernel/syscalls/syscall.tbl    |   1 +
>  arch/s390/kernel/syscalls/syscall.tbl       |   1 +
>  arch/sh/kernel/syscalls/syscall.tbl         |   1 +
>  arch/sparc/kernel/syscalls/syscall.tbl      |   1 +
>  arch/x86/entry/syscalls/syscall_32.tbl      |   1 +
>  arch/x86/entry/syscalls/syscall_64.tbl      |   1 +
>  arch/xtensa/kernel/syscalls/syscall.tbl     |   1 +
>  include/linux/pid.h                         |   1 +
>  include/linux/syscalls.h                    |   3 +
>  include/uapi/asm-generic/unistd.h           |   5 +-
>  kernel/exit.c                               |  17 --
>  kernel/pid.c                                |  17 ++
>  kernel/sys_ni.c                             |   1 +
>  mm/madvise.c                                | 277 ++++++++++++++------
>  24 files changed, 238 insertions(+), 102 deletions(-)
> 
> -- 
> 2.25.0.341.g760bfbb309-goog
> 
