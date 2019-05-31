From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v1 1/2] fork: add clone3
Date: Fri, 31 May 2019 10:14:40 +0200
Message-ID: <CAK8P3a1zAk1qAkpmevO-AS6zxKdJneDe0ADouhZLW5SEUqoTuw@mail.gmail.com>
References: <20190529152237.10719-1-christian@brauner.io> <20190530132012.GS16415@port70.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530132012.GS16415@port70.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <nsz@port70.net>
Cc: Christian Brauner <christian@brauner.io>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 30, 2019 at 3:20 PM Szabolcs Nagy <nsz@port70.net> wrote:
> * Christian Brauner <christian@brauner.io> [2019-05-29 17:22:36 +0200]:

> > /* uapi */
> > struct clone_args {
> >         __aligned_u64 flags;
> >         __aligned_u64 pidfd;
> >         __aligned_u64 parent_tidptr;
> >         __aligned_u64 child_tidptr;
> >         __aligned_u64 stack;
> >         __aligned_u64 stack_size;
> >         __aligned_u64 tls;
> > };
>
> is this new linux syscall api style to pass pointers as u64?

This is common for ioctls passing structures now. I don't think
we've had many system calls with structures containing pointers,
but the idea is the same, i.e. we want structures to be identical
on 32-bit and 64-bit architectures.

> i think it will look a bit ugly in userspace where cast
> to u64 would signextend pointers on most 32bit targets, so
> user code would have to do something like
>
> arg.ptr = (uint64_t)(uintptr_t)ptr;
>
> such ugliness can be hidden by the libc with a different
> struct definition, but it will require bigendian and alignment
> hackery (or translation in libc, but that does not really work
> when user calls raw syscall).

Right. Note also that user space should do zero-extension
of the variables in order for the kernel to not care about
what called it. Just leaving padding fields in the structure
is not enough here.

User space that calls the raw syscall certainly has to
go through the uintptr_t cast, but I would also expect that
applications don't normally do that, and instead call a
library function that has regular C calling conventions
with individual arguments instead of a structure.

      Arnd
