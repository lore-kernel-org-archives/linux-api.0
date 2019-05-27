From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] arch: wire-up clone6() syscall on x86
Date: Mon, 27 May 2019 14:28:33 +0200
Message-ID: <CAK8P3a3q=5Ca0xoMp+kyCvOqNDRzDTgu28f+U8J-buMVcZcVaw@mail.gmail.com>
References: <20190526102612.6970-1-christian@brauner.io> <20190526102612.6970-2-christian@brauner.io>
 <CAK8P3a1Ltsna_rtKxhMU7X0t=UOXDA75tKpph6s=OZ4itJe7VQ@mail.gmail.com> <20190527104528.cao7wamuj4vduh3u@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527104528.cao7wamuj4vduh3u@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 27, 2019 at 12:45 PM Christian Brauner <christian@brauner.io> wrote:
> On Mon, May 27, 2019 at 12:02:37PM +0200, Arnd Bergmann wrote:
> > On Sun, May 26, 2019 at 12:27 PM Christian Brauner <christian@brauner.io> wrote:
> > >
> > > Wire up the clone6() call on x86.
> > >
> > > This patch only wires up clone6() on x86. Some of the arches look like they
> > > need special assembly massaging and it is probably smarter if the
> > > appropriate arch maintainers would do the actual wiring.
> >
> > Why do some architectures need special cases here? I'd prefer to have
> > new system calls always get defined in a way that avoids this, and
> > have a common entry point for everyone.
> >
> > Looking at the m68k sys_clone comment in
> > arch/m68k/kernel/process.c, it seems that this was done as an
> > optimization to deal with an inferior ABI. Similar code is present
> > in h8300, ia64, nios2, and sparc. If all of them just do this to
> > shave off a few cycles from the system call entry, I really
> > couldn't care less.
>
> I'm happy to wire all arches up at the same time in the next revision. I
> just wasn't sure why some of them were assemblying the living hell out
> of clone; especially ia64. I really didn't want to bother touching all
> of this just for an initial RFC.

Don't worry about doing all architectures for the RFC, I mainly want this
to be done consistently by the time it gets into linux-next.

One thing to figure out though is whether we need the stack_size argument
that a couple of architectures pass. It's usually hardwired to zero,
but not all the time, and I don't know the history of this.

       Arnd
