From: Florian Weimer <fweimer@redhat.com>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Wed, 17 Apr 2019 14:19:29 +0200
Message-ID: <87v9zc6cz2.fsf@oldenburg2.str.redhat.com>
References: <20190414201436.19502-1-christian@brauner.io>
        <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
        <20190415195911.z7b7miwsj67ha54y@yavin>
        <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
        (Andy Lutomirski's message of "Mon, 15 Apr 2019 13:29:23 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

> I would personally *love* it if distros started setting no_new_privs
> for basically all processes.

Wouldn't no_new_privs inhibit all security transitions, including those
that reduce privileges?  And therefore effectively reduce security?

> Anyway, clone(2) is an enormous mess.  Surely the right solution here
> is to have a whole new process creation API that takes a big,
> extensible struct as an argument, and supports *at least* the full
> abilities of posix_spawn() and ideally covers all the use cases for
> fork() + do stuff + exec().  It would be nifty if this API also had a
> way to say "add no_new_privs and therefore enable extra functionality
> that doesn't work without no_new_privs".  This functionality would
> include things like returning a future extra-privileged pidfd that
> gives ptrace-like access.

I agree that consistent replacement for the clone system call makes
sense.  I'm not sure if covering everything that posix_spawn could do
would make sense.  There seems to be some demand to be able to do large
parts of container setup using posix_spawn, so we'll probably add
support for things like writing to arbitrary files eventually.  And of
course, proper error reporting, so that you can figure out which file
creation action failed.

Thanks,
Florian
