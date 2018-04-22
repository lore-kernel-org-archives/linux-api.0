From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] x86: ipc: fix x32 version of shmid64_ds and msqid64_ds
Date: Sun, 22 Apr 2018 22:17:18 +0200
Message-ID: <CAK8P3a2=nfW1YSJoTf_cj5DVSMVfzWYaYqG486FHD3vPw3YZfQ@mail.gmail.com>
References: <CAK8P3a3qAoR1afmTTK1CAp1L81dzwtBL+SKj=QMqD=dBr_8oRQ@mail.gmail.com>
 <20180420130346.3178914-1-arnd@arndb.de> <CAH8yC8mnfNnG86kgjnfwiZJ0=qN+w=5PVcLcxddaJdDtYbSanA@mail.gmail.com>
 <CAK8P3a0nL4B+t6BMRhr36RrZ_jDgwnY1BviNPD+cFzsUGeppmA@mail.gmail.com> <CAMe9rOrTzgDmCF+A7nYdGR6BHZBuK5SMnJxeRxBFQW00VmdXvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-91775-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAMe9rOrTzgDmCF+A7nYdGR6BHZBuK5SMnJxeRxBFQW00VmdXvg@mail.gmail.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Jeffrey Walton <noloader@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, y2038 Mailman List <y2038@lists.linaro.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Albert ARIBAUD <albert.aribaud@3adev.fr>, linux-s390 <linux-s390@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, James Hogan <jhogan@kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, sparclin
List-Id: linux-api@vger.kernel.org

On Sun, Apr 22, 2018 at 2:38 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Fri, Apr 20, 2018 at 7:38 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Apr 20, 2018 at 3:53 PM, Jeffrey Walton <noloader@gmail.com> wrote:
>
> Glibc has correct header files for system calls.  I have a very old
> program to check if Linux kernel header files are correct for user
> space:
>
> https://github.com/hjl-tools/linux-header
>
> It needs update to check uapi.

Simply running 'make' on a regular distro shows this output:

--- kernel.x32.out 2018-04-22 22:10:16.053432423 +0200
+++ glibc.x32.out 2018-04-22 22:10:16.073432838 +0200
@@ -10,9 +10,9 @@ size of daddr_t: 4
 size of __ipc_pid_t: 4
 size of struct ipc_perm: 48
 size of mqd_t: 4
-size of struct msqid_ds: 144
+size of struct msqid_ds: 120
 size of struct semid_ds: 104
-size of struct shmid_ds: 136
+size of struct shmid_ds: 112
 size of struct shminfo: 72
 size of struct timeval: 16
 size of struct timespec: 16
@@ -22,8 +22,8 @@ size of struct mq_attr: 64
 size of struct rlimit: 16
 size of struct rusage: 144
 size of struct stat: 144
-size of struct statfs: 64
-size of struct statfs64: 88
+size of struct statfs: 120
+size of struct statfs64: 120
 size of struct timex: 208
 size of struct msginfo: 32
 size of struct msgbuf: 16

This seems plausible, the statfs structure clearly has the same problem
as msqid_ds/shmid_ds based on its usage of '__statfs_word' which is
now defined as '__u32' rather than '__kernel_long_t'.

It should be trivial to override __statfs_word from
arch/x86/include/uapi/asm/statfs.h

I've checked the other uses of __BITS_PER_LONG in the uapi
headers now, and all the others are either not relevant for x32
(either definition is fine) or it has to be __BITS_PER_LONG=32.

        Arnd
