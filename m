From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 21:54:58 +0000
Message-ID: <CAGLj2rEODAg+Y5D5Oxy3Gp-Yg6mqeisPnLQJ334TWSdrPW1L7A@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <20190325201544.7o2kwuie3infcblp@brauner.io>
 <20190325211132.GA6494@google.com> <CAG48ez0K9xcSf28rXOy3k0dEL3b_4b-DfcdCO=JO7vVZeJoBcA@mail.gmail.com>
 <20190325214338.GA16969@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190325214338.GA16969@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Daniel Colascione <dancol@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusam>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 9:43 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Mon, Mar 25, 2019 at 10:19:26PM +0100, Jann Horn wrote:
> > On Mon, Mar 25, 2019 at 10:11 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > But often you don't just want to wait for a single thing to happen;
> > you want to wait for many things at once, and react as soon as any one
> > of them happens. This is why the kernel has epoll and all the other
> > "wait for event on FD" APIs. If waiting for a process isn't possible
> > with fd-based APIs like epoll, users of this API have to spin up
> > useless helper threads.
>
> This is true. I almost forgot about the polling requirement, sorry. So then a
> new syscall it is.. About what to wait for, that can be a separate parameter
> to pidfd_wait then.
>

This introduces a time window where the process changes state between
"get pidfd" and "setup waitfd", it would be simpler if the pidfd
itself supported .poll and on termination the exit status was made
readable from the file descriptor.

Further, in the clone4 patchset, there was a mechanism to autoreap
such a process so that it does not interfere with waiting a process
does normally. How do you intend to handle this case if anyone except
the parent is wanting to *wait* on the process (a second process,
without reaping, so as to not disrupt any waiting in the parent), and
for things like libraries that finally can manage their own set of
process when pidfd_clone is added, by excluding this process from the
process's normal wait handling logic.

Moreover, should anyone except the parent process be allowed to open a
readable pidfd (or waitfd), without additional capabilities?

> Thanks.
>
>  - Joel
>
