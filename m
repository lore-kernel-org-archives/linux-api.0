From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH] x86: ipc: fix x32 version of shmid64_ds and msqid64_ds
Date: Fri, 20 Apr 2018 09:53:05 -0400
Message-ID: <CAH8yC8mnfNnG86kgjnfwiZJ0=qN+w=5PVcLcxddaJdDtYbSanA@mail.gmail.com>
References: <CAK8P3a3qAoR1afmTTK1CAp1L81dzwtBL+SKj=QMqD=dBr_8oRQ@mail.gmail.com>
 <20180420130346.3178914-1-arnd@arndb.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180420130346.3178914-1-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, ebiederm@xmission.com, y2038 Mailman List <y2038@lists.linaro.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Deepa Dinamani <deepa.kernel@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Albert ARIBAUD <albert.aribaud@3adev.fr>, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-mips@linux-mips.org, jhogan@kernel.org, Ralf Baechle <ralf@linux-mips.org>, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>, Daniel Schepler <dschepler@gmail.com>, "H . J . Lu" <hjl.tools@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi Arnd,

One comment here:

> +#if !defined(__x86_64__) || !defined(__ilp32__)
>  #include <asm-generic/msgbuf.h>
> +#else

I understand there's some progress having Clang compile the kernel.
Clang treats __ILP32__ and friends differently than GCC. I believe
ILP32 shows up just about everywhere there are 32-bit ints, longs and
pointers. You might find it on Aarch64 or you might find it on MIPS64
when using Clang.

I think that means this may be a little suspicious:

    > +#if !defined(__x86_64__) || !defined(__ilp32__)

I kind of felt LLVM was wandering away from the x32 ABI, but the LLVM
devs insisted they were within their purview. Also see
https://lists.llvm.org/pipermail/cfe-dev/2015-December/046300.html.

Sorry about the top-post. I just wanted to pick out that one piece.

Jeff

On Fri, Apr 20, 2018 at 9:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> A bugfix broke the x32 shmid64_ds and msqid64_ds data structure layout
> (as seen from user space)  a few years ago: Originally, __BITS_PER_LONG
> was defined as 64 on x32, so we did not have padding after the 64-bit
> __kernel_time_t fields, After __BITS_PER_LONG got changed to 32,
> applications would observe extra padding.
>
> In other parts of the uapi headers we seem to have a mix of those
> expecting either 32 or 64 on x32 applications, so we can't easily revert
> the path that broke these two structures.
>
> Instead, this patch decouples x32 from the other architectures and moves
> it back into arch specific headers, partially reverting the even older
> commit 73a2d096fdf2 ("x86: remove all now-duplicate header files").
>
> It's not clear whether this ever made any difference, since at least
> glibc carries its own (correct) copy of both of these header files,
> so possibly no application has ever observed the definitions here.
>
> There are other UAPI interfaces that depend on __BITS_PER_LONG and
> that might suffer from the same problem on x32, but I have not tried to
> analyse them in enough detail to be sure. If anyone still cares about x32,
> that may be a useful thing to do.
>
> Fixes: f4b4aae18288 ("x86/headers/uapi: Fix __BITS_PER_LONG value for x32 builds")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This came out of the y2038 ipc syscall series but can be applied
> and backported independently.
> ---
>  arch/x86/include/uapi/asm/msgbuf.h | 29 +++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/shmbuf.h | 40 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/msgbuf.h b/arch/x86/include/uapi/asm/msgbuf.h
> index 809134c644a6..5f1604961e6d 100644
> --- a/arch/x86/include/uapi/asm/msgbuf.h
> +++ b/arch/x86/include/uapi/asm/msgbuf.h
> @@ -1 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef __ASM_X64_MSGBUF_H
> +#define __ASM_X64_MSGBUF_H
> +
> +#if !defined(__x86_64__) || !defined(__ilp32__)
>  #include <asm-generic/msgbuf.h>
> +#else
> +/*
> + * The msqid64_ds structure for x86 architecture with x32 ABI.
> + *
> + * On x86-32 and x86-64 we can just use the generic definition, but
> + * x32 uses the same binary layout as x86_64, which is differnet
> + * from other 32-bit architectures.
> + */
> +
> +struct msqid64_ds {
> +       struct ipc64_perm msg_perm;
> +       __kernel_time_t msg_stime;      /* last msgsnd time */
> +       __kernel_time_t msg_rtime;      /* last msgrcv time */
> +       __kernel_time_t msg_ctime;      /* last change time */
> +       __kernel_ulong_t msg_cbytes;    /* current number of bytes on queue */
> +       __kernel_ulong_t msg_qnum;      /* number of messages in queue */
> +       __kernel_ulong_t msg_qbytes;    /* max number of bytes on queue */
> +       __kernel_pid_t msg_lspid;       /* pid of last msgsnd */
> +       __kernel_pid_t msg_lrpid;       /* last receive pid */
> +       __kernel_ulong_t __unused4;
> +       __kernel_ulong_t __unused5;
> +};
> +
> +#endif /* __ASM_GENERIC_MSGBUF_H */
> diff --git a/arch/x86/include/uapi/asm/shmbuf.h b/arch/x86/include/uapi/asm/shmbuf.h
> index 83c05fc2de38..cdd7eec878fa 100644
> --- a/arch/x86/include/uapi/asm/shmbuf.h
> +++ b/arch/x86/include/uapi/asm/shmbuf.h
> @@ -1 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef __ASM_X86_SHMBUF_H
> +#define __ASM_X86_SHMBUF_H
> +
> +#if !defined(__x86_64__) || !defined(__ilp32__)
>  #include <asm-generic/shmbuf.h>
> +#else
> +/*
> + * The shmid64_ds structure for x86 architecture with x32 ABI.
> + *
> + * On x86-32 and x86-64 we can just use the generic definition, but
> + * x32 uses the same binary layout as x86_64, which is differnet
> + * from other 32-bit architectures.
> + */
> +
> +struct shmid64_ds {
> +       struct ipc64_perm       shm_perm;       /* operation perms */
> +       size_t                  shm_segsz;      /* size of segment (bytes) */
> +       __kernel_time_t         shm_atime;      /* last attach time */
> +       __kernel_time_t         shm_dtime;      /* last detach time */
> +       __kernel_time_t         shm_ctime;      /* last change time */
> +       __kernel_pid_t          shm_cpid;       /* pid of creator */
> +       __kernel_pid_t          shm_lpid;       /* pid of last operator */
> +       __kernel_ulong_t        shm_nattch;     /* no. of current attaches */
> +       __kernel_ulong_t        __unused4;
> +       __kernel_ulong_t        __unused5;
> +};
> +
> +struct shminfo64 {
> +       __kernel_ulong_t        shmmax;
> +       __kernel_ulong_t        shmmin;
> +       __kernel_ulong_t        shmmni;
> +       __kernel_ulong_t        shmseg;
> +       __kernel_ulong_t        shmall;
> +       __kernel_ulong_t        __unused1;
> +       __kernel_ulong_t        __unused2;
> +       __kernel_ulong_t        __unused3;
> +       __kernel_ulong_t        __unused4;
> +};
> +
> +#endif /* __ASM_X86_SHMBUF_H */
