From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Mon, 29 Apr 2019 19:16:11 -0700
Message-ID: <CAHk-=wg73au-kvOwWpPDY+rXrz8O5gwrcPiw1FZx-Qr2PqpRFg@mail.gmail.com>
References: <20190414201436.19502-1-christian@brauner.io> <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin> <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
 <20190420071406.GA22257@ip-172-31-15-78> <CAG48ez0gG4bd-t1wdR2p6-N2FjWbCqm_+ZThKfF7yKnD=KLqAQ@mail.gmail.com>
 <CAG48ez15bf1EJB0XTJsGFpvf8r5pj9+rv1axKVr13H1NW7ARZw@mail.gmail.com>
 <CAHk-=wi_N81mKYFz33ycoWiL7_tGbZBMJOsAs16inYzSza+OEw@mail.gmail.com> <CAG48ez1CV54c1xZ9s26ym=9avkihiNi=ppW-CWA1-qrCpYdc1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1CV54c1xZ9s26ym=9avkihiNi=ppW-CWA1-qrCpYdc1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Kevin Easton <kevin@guarana.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 29, 2019 at 5:39 PM Jann Horn <jannh@google.com> wrote:
>
> ... uuuh, whoops. Turns out I don't know what I'm talking about.

Well, apparently there's some odd libc issue accoprding to Florian, so
there *might* be something to it.

> Nevermind. For some reason I thought vfork() was just
> CLONE_VFORK|SIGCHLD, but now I see I got that completely wrong.

Well, inside the kernel, that's actually *very* close to what vfork() is:

  SYSCALL_DEFINE0(vfork)
  {
        return _do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0,
                        0, NULL, NULL, 0);
  }

but that's just an internal implementation detail. It's a real vfork()
and should act as the traditional BSD "share everything" without any
address space copying. The CLONE_VFORK flag is what does the "wait for
child to exit or execve" magic.

Note that vfork() is "exciting" for the compiler in much the same way
"setjmp/longjmp()" is, because of the shared stack use in the child
and the parent. It is *very* easy to get this wrong and cause massive
and subtle memory corruption issues because the parent returns to
something that has been messed up by the child.

That may be why some libc might end up just using "fork()", because it
ends up avoiding bugs in user space.
(In fact, if I recall correctly, the _reason_ we have an explicit
'vfork()' entry point rather than using clone() with magic parameters
was that the lack of arguments meant that you didn't have to
save/restore any registers in user space, which made the whole stack
issue simpler. But it's been two decades, so my memory is bitrotting).

Also, particularly if you have a big address space, vfork()+execve()
can be quite a bit faster than fork()+execve(). Linux fork() is pretty
efficient, but if you have gigabytes of VM space to copy, it's going
to take time even if you do it fairly well.

               Linus
