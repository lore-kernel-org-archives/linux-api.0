From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Wed, 28 Nov 2018 15:05:19 +0100
Message-ID: <CAK8P3a2eB59EQsjKH50CQV6OtvsJfG++JaF5z7Krvk2tjrMotQ@mail.gmail.com>
References: <20181120105124.14733-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181120105124.14733-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: christian@brauner.io
Cc: "Eric W . Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 20, 2018 at 11:54 AM Christian Brauner <christian@brauner.io> wrote:
> ---
>  arch/x86/entry/syscalls/syscall_32.tbl |   1 +
>  arch/x86/entry/syscalls/syscall_64.tbl |   2 +
>  fs/proc/base.c                         |  11 ++-
>  fs/proc/internal.h                     |   5 -
>  include/linux/proc_fs.h                |  12 +++
>  include/linux/syscalls.h               |   2 +
>  include/uapi/asm-generic/unistd.h      |   4 +-
>  kernel/signal.c                        | 127 +++++++++++++++++++++++--
>  8 files changed, 151 insertions(+), 13 deletions(-)

For asm-generic:

Acked-by: Arnd Bergmann <arnd@arndb.de>

I checked that the system call wired up correctly in a way that
works on all architectures using the generic syscall table.
