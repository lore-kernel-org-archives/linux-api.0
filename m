From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v6 0/1] ns: introduce binfmt_misc namespace
Date: Thu, 1 Nov 2018 15:44:23 +0100
Message-ID: <CAG48ez2vyk0ki1AMv0G_-3m2Pq8gAkO2yjVjs=3CaJNBP0JChA@mail.gmail.com>
References: <20181010161430.11633-1-laurent@vivier.eu> <7ed6f823-547b-922d-59ff-aba9c4c3ab39@vivier.eu>
 <1541041159.4632.6.camel@HansenPartnership.com> <CAG48ez3HnkRM6bUZMNjuTy5DgujgamEKhZOEWDfCjqW7fTJSzQ@mail.gmail.com>
 <1541081413.2853.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541081413.2853.6.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Laurent Vivier <laurent@vivier.eu>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, dima@arista.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 1, 2018 at 3:10 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2018-11-01 at 04:51 +0100, Jann Horn wrote:
> > On Thu, Nov 1, 2018 at 3:59 AM James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > >
> > > On Tue, 2018-10-16 at 11:52 +0200, Laurent Vivier wrote:
> > > > Hi,
> > > >
> > > > Any comment on this last version?
> > > >
> > > > Any chance to be merged?
> > >
> > > I've got a use case for this:  I went to one of the Graphene talks
> > > in Edinburgh and it struck me that we seem to keep reinventing the
> > > type of sandboxing that qemu-user already does.  However if you
> > > want to do an x86 on x86 sandbox, you can't currently use the
> > > binfmt_misc mechanism because that has you running *every* binary
> > > on the system emulated. Doing it per user namespace fixes this
> > > problem and allows us to at least cut down on all the pointless
> > > duplication.
> >
> > Waaaaaait. What? qemu-user does not do "sandboxing". qemu-user makes
> > your code slower and *LESS* secure. As far as I know, qemu-user is
> > only intended for purposes like development and testing.
>
> Sandboxing is about protecting the cloud service provider (and other
> tenants) from horizontal attack by reducing calls to the shared kernel.
>  I think it's pretty indisputable that full emulation is an effective
> sandbox in that regard.
>
> We can argue for about bugginess vs completeness, but technologically
> qemu-user already has most of the system calls, which seems to be a
> significant problem with other sandboxes.  I also can't dispute it's
> slower, but that's a tradeoff for people to make.

I'm pretty sure you don't understand how qemu-user works.

When the emulated code makes a syscall, QEMU just forwards the syscall
to the native kernel.

QEMU doesn't even prevent you from accessing the address space used by
the emulation logic.

qemu-user is not for sandboxing. qemu-user is not for security.
qemu-user is for running binaries from architecture A on architecture
B, with as much direct access to the kernel's syscall surface as
possible.


An example:

$ cat blah.c
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
int main(void) {
  open("/foo/bar/blah", O_RDONLY);
  char c;
  printf("ptr is %p\n", &c);
  read(1337, &c, 1);
  *(volatile char *)0x13371338;
}
$ aarch64-linux-gnu-gcc -static -o blah blah.c && strace -f qemu-aarch64 ./blah
[...]
[pid 14181] openat(AT_FDCWD, "/foo/bar/blah", O_RDONLY) = -1 ENOENT
(No such file or directory)
[pid 14181] fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 93), ...}) = 0
[pid 14181] write(1, "ptr is 0x40007fff2f\n", 20ptr is 0x40007fff2f
) = 20
[pid 14181] read(1337, 0x40007fff2f, 1) = -1 EBADF (Bad file descriptor)
[pid 14181] --- SIGSEGV {si_signo=SIGSEGV, si_code=SEGV_MAPERR,
si_addr=0x13371338} ---
[...]
