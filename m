From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] selftests/seccomp: build on aarch64, document ABI
Date: Wed, 09 Sep 2015 23:20:18 +0200
Message-ID: <480615028.m9oKCRv0Vd@wuerfel>
References: <20150909193025.GA29244@www.outflux.net> <19228212.s6UOoYJca9@wuerfel> <CAGXu5jJw8hAVPKvut51D1jojsCEGEweWNu2TyWrgUfQ9hqsw3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJw8hAVPKvut51D1jojsCEGEweWNu2TyWrgUfQ9hqsw3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>, Andy Lutomirski <luto@amacapital.net>, Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 09 September 2015 13:52:39 Kees Cook wrote:
> On Wed, Sep 9, 2015 at 1:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 09 September 2015 12:30:27 Kees Cook wrote:

> > If this is intentional, it at least needs a comment to explain the
> > situation, and be extended to all other architectures that do not have
> > a poll() system call.
> >
> > The arm32 version of sys_poll should be available as 168 in both native
> > and compat mode.
> 
> Does ppoll still get interrupted like poll to require a restart_syscall call?

Yes, the only difference between the two is the optional signal mask
argument in ppoll.

> Regardless, the primary problem is this (emphasis added):
> 
> >> +        * - native ARM does _not_ expose true syscall.
> >> +        * - compat ARM on ARM64 _does_ expose true syscall.
> 
> When you ptrace or seccomp an arm32 binary under and arm32 kernel,
> restart_syscall is invisible. When you ptrace or seccomp an arm32
> binary under and arm64 kernel, suddenly it's visible. This means, for
> example, seccomp filters will break under an arm64 kernel.

Ok, I see.

> (And apologies if I'm not remembering pieces of this correctly, I
> don't have access to arm64 hardware at the moment, which is why I'm
> reaching out for some help on this... I'm trying to close out this old
> thread: https://lkml.org/lkml/2015/1/20/778 )

FWIW, it should not be too hard to get an image that runs in
qemu-system-arm64.

I suppose the same problem exists on all restartable system calls
(e.g. nanosleep, select, recvmsg, clock_nanosleep, ...)?

I also believe there are various architectures that cannot see the
original system call number for a restarted syscall, in particular
when the syscall number argument is in the same register as the
return code of the syscall and gets overwritten on the way out of 
the kernel. Is this the problem you are seeing? If so, we should
find a solution that works on all such architectures.

	Arnd
