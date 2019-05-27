From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] arch: wire-up clone6() syscall on x86
Date: Mon, 27 May 2019 11:48:13 -0700
Message-ID: <CAHk-=wgixXANa=2U0AeKud9zk9XvaV4mVRNNpkOWKpy+uuvtsg@mail.gmail.com>
References: <20190526102612.6970-1-christian@brauner.io> <20190526102612.6970-2-christian@brauner.io>
 <CAK8P3a1Ltsna_rtKxhMU7X0t=UOXDA75tKpph6s=OZ4itJe7VQ@mail.gmail.com>
 <20190527104528.cao7wamuj4vduh3u@brauner.io> <CAK8P3a3q=5Ca0xoMp+kyCvOqNDRzDTgu28f+U8J-buMVcZcVaw@mail.gmail.com>
 <20190527123414.rv2r6g6de6y3ay6w@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527123414.rv2r6g6de6y3ay6w@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-ia64@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 27, 2019 at 5:34 AM Christian Brauner <christian@brauner.io> wrote:
>
> Afaict, stack_size is *only* used on ia64:

That's because ia64 "stacks" are an odd non-stack thing (like so much
of the architecture).

In computer science, a stack is a FIFO that grows/shrinks according to
use. In practical implementations, it also has a direction, but the
"size" is basically not relevant if you just allow it to grow
dynamically. The key word here being "dynamically": the stack size is
inherently a dynamic thing.

So you don't really need a "stack size". The whole concept doesn't
make sense, outside of the obvious maximum limit things (ie
RLIMIT_STACK) and simply just hitting other allocations.

But ia64 is "special".

The ia64 stack isn't actually a stack. It's *two* stacks, growing in
opposite directions. One for the hardware spilling of the register
state and call frame ("backing store"), and one for the traditional
software stack.

So on ia64, the stack size suddenly becomes a fixed thing, because
it's not a dynamically growing single stack that grows in one
direction, it's literally a fixed virtual area that has two different
stacks growing towards each other.

Btw, don't get me wrong. Two stacks can be a good thing, and a lot of
security people want to have two stacks - one for actual call frame
data, and a separate one for automatic stack variables that have their
address taken.

Having separate stacks avoids the whole traditional stack smash model
(well, it avoids the one that overwrites the return frame - you can
still possibly have security issues because one function smashes the
automatic stack of a caller and then cause the caller to be confused
and do something insecure).

And the ia64 double stack kind of works that way automatically. So
"double stack" very much isn't wrong per se, but doing it the way ia64
did was too inflexible and the register stack (and rotation) was and
is just a bad idea.

Two stacks without the hw register renaming and flushing can be
lovely, and can even merit some hw support (ie the whole "Shadow
stack" model).

              Linus
