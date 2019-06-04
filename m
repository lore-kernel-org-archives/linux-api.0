From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 2/2] arch: wire-up clone3() syscall
Date: Tue, 4 Jun 2019 20:40:01 +0200
Message-ID: <CAK8P3a0OfBpx6y4m5uWX-DUg16NoFby5ik-3xCcD+yMrw0tbEw@mail.gmail.com>
References: <20190604160944.4058-1-christian@brauner.io> <20190604160944.4058-2-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604160944.4058-2-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 4, 2019 at 6:09 PM Christian Brauner <christian@brauner.io> wrote:
>
> Wire up the clone3() call on all arches that don't require hand-rolled
> assembly.
>
> Some of the arches look like they need special assembly massaging and it is
> probably smarter if the appropriate arch maintainers would do the actual
> wiring. Arches that are wired-up are:
> - x86{_32,64}
> - arm{64}
> - xtensa

The ones you did look good to me. I would hope that we can do all other
architectures the same way, even if they have special assembly wrappers
for the old clone(). The most interesting cases appear to be ia64, alpha,
m68k and sparc, so it would be good if their maintainers could take a
look.

What do you use for testing? Would it be possible to override the
internal clone() function in glibc with an LD_PRELOAD library
to quickly test one of the other architectures for regressions?

      Arnd
