From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add
 CLONE_PIDFD]
Date: Sat, 20 Apr 2019 16:28:55 +0100
Message-ID: <20190420152855.GG2217@ZenIV.linux.org.uk>
References: <20190414201436.19502-1-christian@brauner.io>
 <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin>
 <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 15, 2019 at 01:29:23PM -0700, Andy Lutomirski wrote:

> Anyway, clone(2) is an enormous mess.  Surely the right solution here
> is to have a whole new process creation API that takes a big,
> extensible struct as an argument, and supports *at least* the full
> abilities of posix_spawn() and ideally covers all the use cases for
> fork() + do stuff + exec().  It would be nifty if this API also had a
> way to say "add no_new_privs and therefore enable extra functionality
> that doesn't work without no_new_privs".  This functionality would
> include things like returning a future extra-privileged pidfd that
> gives ptrace-like access.

You had been two weeks too late with that, and a bit too obvious with the use
of "surely" too close to the beginning...

If it was _not_ a belated AFD posting, alt.tasteless is over -> that way...
