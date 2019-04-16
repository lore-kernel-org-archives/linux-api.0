From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add
 CLONE_PIDFD]
Date: Tue, 16 Apr 2019 20:45:43 +0200
Message-ID: <c783a83a-01a1-9813-e2f7-0516cf7a1c16@metux.net>
References: <20190414201436.19502-1-christian@brauner.io>
 <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin>
 <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On 15.04.19 22:29, Andy Lutomirski wrote:

<snip>

> I would personally *love* it if distros started setting no_new_privs> for basically all processes.

Maybe a pam module for that would be fine.
But this should be configurable per-user, as so many things still rely
on suid.

Actually, I'd like to move all authentication / privilege switching
to factotum (login(1), sshd, etc then also could run as unprivileged
users).

> And pidfd actually gets us part of the> way toward a straightforward way to make sudo and su still work in a>
no_new_privs world: su could call into a daemon that would spawn the>
privileged task, and su would get a (read-only!) pidfd back and then>
wait for the fd and exit.

How exactly would the pidfd improve this scenario ?
IMHO, would just need to pass the inherited fd's to that daemon (eg.
via unix socket) which then sets them up in the new child process.

> I suppose that, done naively, this might> cause some odd effects with respect to tty handling, but I bet it's>
solveable.

Yes, signals and process groups would be a bit tricky. Some signals
could be transmitted in a similar way as ssh does.

But: how can we handle things like cgroups ?


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
