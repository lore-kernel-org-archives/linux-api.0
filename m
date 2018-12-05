From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Y2038: provide kernel support indication
Date: Wed, 5 Dec 2018 14:33:58 +0100
Message-ID: <CAK8P3a0vZhfW_o3OhYBhwRmKCXA0jAAuODxmzHt+rwJkKO45ZA@mail.gmail.com>
References: <20180919071303.26636-1-albert.aribaud@3adev.fr>
 <alpine.DEB.2.21.1809191300420.14910@digraph.polyomino.org.uk>
 <20180924235639.716a4cb4@athena> <alpine.DEB.2.21.1809251656190.14070@digraph.polyomino.org.uk>
 <20180925213635.70084f61@athena> <CAK8P3a17ZpOKx=p1Y2FgruM3GMcdOtiwaQqPvmg5xZQpFP2fCQ@mail.gmail.com>
 <20181205124926.7d433994@athena>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-97970-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20181205124926.7d433994@athena>
To: Albert ARIBAUD <albert.aribaud@3adev.fr>
Cc: Joseph Myers <joseph@codesourcery.com>, GNU C Library <libc-alpha@sourceware.org>, Firoz Khan <firoz.khan@linaro.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 5, 2018 at 12:49 PM Albert ARIBAUD <albert.aribaud@3adev.fr> wrote:
> On Tue, 25 Sep 2018 22:14:38 +0200, Arnd Bergmann <arnd@arndb.de> wrote :
> > On Tue, Sep 25, 2018 at 9:36 PM Albert ARIBAUD <albert.aribaud@3adev.fr> wrote:
> > I was undecided on this issue actually: it does make some sense to
> > me to have the syscall macros be the same in the long run, so that
> > glibc doesn't have to pick between __NR_clock_gettime and
> > __NR_clock_gettime64 in a few years, after all supported kernels
> > support __NR_clock_gettime64. Also, 64-bit architectures won't
> > reuse the number space that we reserve for the new calls on 32-bit
> > architectures, so the addition is essentially free.
> >
> > I don't have a strong preference here, and can do whichever
> > you like better in glibc.
>
> There does not seem to have been any other comment on this for a while,
> so, do we go for this approach? That is:
>
> - on 64-bit architectures, the kernel will define _NR symbols identical
>   to those added for Y2038, so that, for instance, on X86_64, there
>   will be an _NR_clock_gettime64 symbol (which will point to the same
>   syscall number as _NR_clock_gettime does).

There are a few new considerations for things that happened over the
last few months, so I'd still like to get more people involved before
we finally decide on this one:

- For cleaning up the kernel headers to make them more easily
  usable in glibc, I think it makes a lot of sense to define the new
  new macro names (as I said above). If we do that, maybe we should
  do it for other system calls (not time related) as well, in particular
  fcntl64, {f,}statfs64, {f,}truncate64, llseek, sendfile64, fstat{at,}64,
  mmap2, and fadvise64 as well as the associated structures.
  I already plan to do it independently for socketcall and ipc, which
  should be replaced with the separate entry points whenever we
  have the recent enough kernel.

- The work that Firoz Khan did for generating the asm/unistd.h
  kernel headers and syscall tables on all architectures makes it
  a little awkward to redirect new syscall macros to existing numbers,
  as the table file format uses the number as the primary key.
  The most logical way to do this in the kernel now is actually to
  have the newly assigned number point to the same syscall
  implementation on all architectures, both 32-bit and 64-bit.
  Not providing the number on 64-bit at all is fairly easy, but the
  redirect would require a permanent workaround on ppc, sparc,
  parisc, s390, and riscv as well as any future 64-bit architectures.

- Any Lutomirksi has some ideas for cleaning up the x86 syscall
  table, which may be relevant here. Adding him to Cc.

> - on 64-bit architectures, GLIBC will set __ASSUME_KERNEL_Y2038_SUPPORT
>   once the minimal kernel supported version for these architectures
>   provides the 'new' syscall symbols.
>
> - on all architectures, if __ASSUME_KERNEL_Y2038_SUPPORT is defined,
>   then GLIBC assumes the 'new' syscall symbols exist and can be used.

We have a couple of system calls that we add even on 64-bit architectures,
including statx() and likely the new version of waitid()/getrusage().
I think for those the logic has to be different, so a 64-bit architecture
will have to e.g. fall back to calling fstatat() when statx() is unavailable
on an older kernel.

> - on all architectures, if __ASSUME_KERNEL_Y2038_SUPPORT is NOT defined,
>   then GLIBC will try to use new syscalls for which a _NR symbol is
>   provided by the build-time kernel, and on ENOSYS, will fallback to old
>   syscalls.

I think it's important that we only do this when we are called from
an application with 64-bit time_t: When a user calls gettimeofday()
with 64-bit time_t, that should try clock_gettime64(2) and fall back
to clock_gettime(2) or gettimeofday(2) if that is unavailable. However
an application using gettimeofday() with a 32-bit time_t should
directly call gettimeofday(2) in the kernel but not try clock_gettime64()
first. Without that distinction, the kernel cannot return -ENOSYS
if we configure it to break compatibility with 32-bit time_t interfaces
and the application might seem to work correctly despite being
broken in 2038.

      Arnd
