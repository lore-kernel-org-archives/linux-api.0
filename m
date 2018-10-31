From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC PATCH] Minimal non-child process exit notification support
Date: Wed, 31 Oct 2018 17:44:24 +0000
Message-ID: <CAKOZuevXXqwJepmLNUtrU=f8jtdgdKAzUAnAA2+KVcWoMxMyFg@mail.gmail.com>
References: <20181029175322.189042-1-dancol@google.com> <CAKOZueuX6GL+rXZbtd_X2RaxF1MdNiEnHFbTRE2X8bsY9bOzuA@mail.gmail.com>
 <175DDE5D-E738-4C35-B664-6AD8B9CF446D@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <175DDE5D-E738-4C35-B664-6AD8B9CF446D@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Tim Murray <timmurray@google.com>, Joel Fernandes <joelaf@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 31, 2018 at 5:25 PM, Andy Lutomirski <luto@amacapital.net> wrot=
e:
> I had an old patch to do much the same thing:

It's a perennial idea. :-)

> https://lore.kernel.org/patchwork/patch/345098/
>
> Can you comment as to how your API compares to my old patch?

Sure. Basically, my approach is sort-of eventfd-esque, whereas your
approach involves adding a very unusual operation (poll support) to a
type of file (a directory) that normally doesn't support it. My
approach feels a bit more "conventional" than poll on a dfd.
Additionally, my approach is usable from the shell. In your model,
poll(2) returning *is* the notification, whereas in my approach, the
canonical notification is read() yielding EOF, with poll(2) acting
like a wakeup hint, just like for eventfd. (You can set O_NONBLOCK on
the exithand FD just like you would any other FD.)

The use of read() for notification of exit also allows for a simple
extension in which we return a siginfo_t with exit information to the
waiter, without changing the API model. My initial patch doesn't
include this feature because I wanted to keep the initial version as
simple as possible.

> You=E2=80=99re using
> some fairly gnarly global synchronization

The global synchronization only kicks for a particular process exit if
somebody has used an exithand FD to wait on that process. (Or more
precisely, that process's struct signal.) Since most process exits
don't require global synchronization, I don't think the global
waitqueue for exithand is a big problem, but if it is, there are
options for fixing it.

> , and that seems unnecessary

It is necessary, and I don't see how your patch is correct. In your
proc_task_base_poll, you call poll_wait() with &task->detach_wqh. What
prevents that waitqueue disappearing (and the poll table waitqueue
pointer dangling) immediately after proc_task_base_poll returns? The
proc_inode maintains a reference to a struct pid, not a task_struct,
but your waitqueue lives in task_struct.

The waitqueue living in task_struct is also wrong in the case that a
multithreaded program execs from a non-main thread; in this case (if
I'm reading the code in exec.c right) we destroy the old main thread
task_struct and have the caller-of-exec's task_struct adopt the old
main thread's struct pid. That is, identity-continuity of struct task
is not the same as identity-continuity of the logical thread group.
