From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v18 0/3] sys_membarrier()
Date: Fri, 8 May 2015 14:06:51 +0200
Message-ID: <CAHO5Pa3pAb_DdQGVRErCkYMJE=-YbgZPCTNF=JXwcHODTbV9=g@mail.gmail.com>
References: <1430940068-4326-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430940068-4326-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@]

On Wed, May 6, 2015 at 9:21 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> Here is v18 of the sys_membarrier patchset, taking care of comments about v17.
> Let see if there are further comments on this patch round.
>
> Thanks,
>
> Mathieu
>
> Mathieu Desnoyers (2):
>   sys_membarrier(): system-wide memory barrier (generic, x86)
>   selftests: enhance membarrier syscall test
>
> Pranith Kumar (1):
>   selftests: add membarrier syscall test
>
>  MAINTAINERS                                        |    8 ++
>  arch/x86/syscalls/syscall_32.tbl                   |    1 +
>  arch/x86/syscalls/syscall_64.tbl                   |    1 +
>  include/linux/syscalls.h                           |    2 +
>  include/uapi/asm-generic/unistd.h                  |    4 +-
>  include/uapi/linux/Kbuild                          |    1 +
>  include/uapi/linux/membarrier.h                    |   53 +++++++++
>  init/Kconfig                                       |   12 ++
>  kernel/Makefile                                    |    1 +
>  kernel/membarrier.c                                |   66 +++++++++++
>  kernel/sys_ni.c                                    |    3 +
>  tools/testing/selftests/Makefile                   |    1 +
>  tools/testing/selftests/membarrier/.gitignore      |    1 +
>  tools/testing/selftests/membarrier/Makefile        |   11 ++
>  .../testing/selftests/membarrier/membarrier_test.c |  121 ++++++++++++++++++++
>  15 files changed, 285 insertions(+), 1 deletions(-)
>  create mode 100644 include/uapi/linux/membarrier.h
>  create mode 100644 kernel/membarrier.c
>  create mode 100644 tools/testing/selftests/membarrier/.gitignore
>  create mode 100644 tools/testing/selftests/membarrier/Makefile
>  create mode 100644 tools/testing/selftests/membarrier/membarrier_test.c
>
> --
> 1.7.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
