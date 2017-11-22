From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v3 0/4] vm: add a syscall to map a process memory into a pipe
Date: Wed, 22 Nov 2017 21:43:31 +0100
Message-ID: <CAKgNAkhtm0JqxeKXovoXPbApogMsGtMR=1td_NhT3AMv_Ot1Ng@mail.gmail.com>
References: <1511379391-988-1-git-send-email-rppt@linux.vnet.ibm.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1511379391-988-1-git-send-email-rppt@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, criu@openvz.org, Arnd Bergmann <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Josh Triplett <josh@joshtriplett.org>, Jann Horn <jannh@google.com>, Yossi Kuperman <yossiku@il.ibm.com>
List-Id: linux-api@vger.kernel.org

Hi Mike,

On 22 November 2017 at 20:36, Mike Rapoport <rppt@linux.vnet.ibm.com> wrote:
> From: Yossi Kuperman <yossiku@il.ibm.com>
>
> Hi,
>
> This patches introduces new process_vmsplice system call that combines
> functionality of process_vm_read and vmsplice.
>
> It allows to map the memory of another process into a pipe, similarly to
> what vmsplice does for its own address space.
>
> The patch 2/4 ("vm: add a syscall to map a process memory into a pipe")
> actually adds the new system call and provides its elaborate description.

Where is the man page for this new syscall?

Cheers,

Michael

> The patchset is against -mm tree.
>
> v3: minor refactoring to reduce code duplication
> v2: move this syscall under CONFIG_CROSS_MEMORY_ATTACH
>     give correct flags to get_user_pages_remote()
>
> Andrei Vagin (3):
>   vm: add a syscall to map a process memory into a pipe
>   x86: wire up the process_vmsplice syscall
>   test: add a test for the process_vmsplice syscall
>
> Mike Rapoport (1):
>   fs/splice: introduce pages_to_pipe helper
>
>  arch/x86/entry/syscalls/syscall_32.tbl             |   1 +
>  arch/x86/entry/syscalls/syscall_64.tbl             |   2 +
>  fs/splice.c                                        | 262 +++++++++++++++++++--
>  include/linux/compat.h                             |   3 +
>  include/linux/syscalls.h                           |   4 +
>  include/uapi/asm-generic/unistd.h                  |   5 +-
>  kernel/sys_ni.c                                    |   2 +
>  tools/testing/selftests/process_vmsplice/Makefile  |   5 +
>  .../process_vmsplice/process_vmsplice_test.c       | 188 +++++++++++++++
>  9 files changed, 450 insertions(+), 22 deletions(-)
>  create mode 100644 tools/testing/selftests/process_vmsplice/Makefile
>  create mode 100644 tools/testing/selftests/process_vmsplice/process_vmsplice_test.c
>
> --
> 2.7.4
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
