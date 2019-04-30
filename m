From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Tue, 30 Apr 2019 09:19:10 -0700
Message-ID: <CAHk-=wiM8VQ_Ny6Y=fTqE9Aq1LuDdU5bKfnXPyYXU1bi7GtU4w@mail.gmail.com>
References: <20190414201436.19502-1-christian@brauner.io> <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin> <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
 <20190420071406.GA22257@ip-172-31-15-78> <CAG48ez0gG4bd-t1wdR2p6-N2FjWbCqm_+ZThKfF7yKnD=KLqAQ@mail.gmail.com>
 <CAG48ez15bf1EJB0XTJsGFpvf8r5pj9+rv1axKVr13H1NW7ARZw@mail.gmail.com>
 <CAHk-=wi_N81mKYFz33ycoWiL7_tGbZBMJOsAs16inYzSza+OEw@mail.gmail.com>
 <CAG48ez1CV54c1xZ9s26ym=9avkihiNi=ppW-CWA1-qrCpYdc1A@mail.gmail.com>
 <CAHk-=wg73au-kvOwWpPDY+rXrz8O5gwrcPiw1FZx-Qr2PqpRFg@mail.gmail.com> <87r29jaoov.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87r29jaoov.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>, Kevin Easton <kevin@guarana.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@goog>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 30, 2019 at 1:21 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> > (In fact, if I recall correctly, the _reason_ we have an explicit
> > 'vfork()' entry point rather than using clone() with magic parameters
> > was that the lack of arguments meant that you didn't have to
> > save/restore any registers in user space, which made the whole stack
> > issue simpler. But it's been two decades, so my memory is bitrotting).
>
> That's an interesting point.  Using a callback-style interface avoids
> that because you never need to restore the registers in the new
> subprocess.  It's still appropriate to use an assembler implementation,
> I think, because it will be more obviously correct.

I agree that a callback interface would have been a whole lot more
obvious and less prone to subtle problems.

But if you want vfork() because the programs you want to build use it,
that's the interface you need..

Of course, if you *don't* need the exact vfork() semantics, clone
itself actually very much supports a callback model with s separate
stack. You can basically do this:

 - allocate new stack for the child
 - in trivial asm wrapper, do:
    - push the callback address on the child stack
    - clone(CLONE_VFORK|CLONE_VM|CLONE_SIGCHLD, chld_stack, NULL, NULL,NULL)
    - "ret"
 - free new stack

where the "ret" in the child will just go to the callback, while the
parent (eventually) just returns from the trivial wrapper and frees
the new stack (which by definition is no longer used, since the child
has exited or execve'd.

So you can most definitely create a "vfork_with_child_callback()" with
clone, and it would arguably be a much superior interface to vfork()
anyway (maybe you'd like to pass in some arguments to the callback too
- add more stack setup for the child as needed), but it wouldn't be
the right solution for programs that just want to use the standard BSD
vfork() model.

> vfork is also more benign from a memory accounting perspective.  In some
> environments, it's not possible to call fork from a large process
> because the accounting assumes (conservatively) that the new process
> will dirty a lot of its private memory.

Indeed.

                 Linus
