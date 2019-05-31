From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v1 1/2] fork: add clone3
Date: Fri, 31 May 2019 13:38:29 -0700
Message-ID: <CAHk-=whQP-Ykxi=zSYaV9iXsHsENa+2fdj-zYKwyeyed63Lsfw@mail.gmail.com>
References: <20190529152237.10719-1-christian@brauner.io> <20190529222414.GA6492@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190529222414.GA6492@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@gmail.com>
Cc: Christian Brauner <christian@brauner.io>, Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 3:24 PM Andrei Vagin <avagin@gmail.com> wrote:
>
> Thank you for thinking about time namespaces. I looked at this patch
> quickly and I would suggest to move a termination signal out of flags. I
> think we can add a separate field (exit_signal) into clone_args. Does it
> make sense? For me, exit_signal in flags always looked weird...

I agree - the child signal in flags was always just a "it fits" kind
of thing, and that was obviously true back then, but is not true now.

In fact, if we move it out of flags, we'd open up new flag values for
the new interface, in that now the low 8 bits are freed up for more
useful things.

In fact, even for the old ones, we might just say that instead of the
full 8-bit CSIGNAL field, nobody ever *used* more than 6 bits, because
_NSIG is 64, and we've never actually had named signals > 31.

(Yeah, yeah, somebody could use signal 64, and yes, mips has _NSIG
128, but realistically we could get two new clone signals in the old
interface and I think nobody would even notice).

In fact, all of the CSIGNAL bits are ignored if CLONE_THREAD or
CLONE_PARENT is set.

                   Linus
