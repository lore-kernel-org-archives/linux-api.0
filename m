From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 18:19:16 +0000
Message-ID: <CAGLj2rE1f4x36KFUjFLiFq8tF1RUmFuCSRTg_tCQ9W2G6LtizA@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <CAKOZuetbZOs1Yur4OrW6hh3wVYdoKNkSqTszbpTWnuRBTmT9zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetbZOs1Yur4OrW6hh3wVYdoKNkSqTszbpTWnuRBTmT9zA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthus>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 5:53 PM Daniel Colascione <dancol@google.com> wrote:
>
> [..snip..]
>
> I don't like the idea of having one kind of pollfd be pollable and
> another not. Such an interface would be confusing for users. If, as
> you suggest below, we instead make the procfs-less FD the only thing
> we call a "pidfd", then this proposal becomes less confusing and more
> viable.

That's certainly on the table, we remove the ability to open
/proc/<PID> and use the dir fd with pidfd_send_signal. I'm in favor of
this.

> > But.. one thing we could do for Daniel usecase is if a /proc/pid directory fd
> > can be translated into a "pidfd" using another syscall or even a node, like
> > /proc/pid/handle or something. I think this is what Christian suggested in
> > the previous threads.
>
> /proc/pid/handle, if I understand correctly, "translates" a
> procfs-based pidfd to a non-pidfd one. The needed interface would have
> to perform the opposite translation, providing a procfs directory for
> a given pidfd.
>
> > And also for the translation the other way, add a syscall or modify
> > translate_fd or something, to covert a anon_inode pidfd into a /proc/pid
> > directory fd. Then the user is welcomed to do openat(2) on _that_ directory fd.
> > Then we modify pidfd_send_signal to only send signals to pure pidfd fds, not
> > to /proc/pid directory fds.
>
> This approach would work, but there's one subtlety to take into
> account: which procfs? You'd want to take, as inputs, 1) the procfs
> root you want, and 2) the pidfd, this way you could return to the user
> a directory FD in the right procfs.
>

I don't think metadata access is in the scope of such a pidfd itself.

> > Should we work on patches for these? Please let us know if this idea makes
> > sense and thanks a lot for adding us to the review as well.
>
> I would strongly prefer that we not merge pidctl (or whatever it is)
> without a story for metadata access, be it your suggestion or
> something else.

IMO, this is out of scope for a process handle. Hence, the need for
metadata access musn't stall it as is.

If you really need this, the pid this pidfd is mapped to can be
exposed through fdinfo (which is perfectly fine for your case as you
use /proc anyway). This means you can reliably determine if you're
opening it for the same pid (and it hasn't been recycled) because this
pidfd will be pollable for state change (in the future). Exposing it
through fdinfo isn't a problem, pid ns is bound to the process during
its lifetime, it's a process creation time property, so the value
isn't going to change anyway. So you can do all metadata access you
want subsequently.

The upshot is that this same pidfd can then be returned from a future
extension of clone(2) Christian is planning to work on. It is still
undecided whether this fd should be only readable by the parent
process or everyone (which would just be a matter of changing the
access mode depending on the caller), but that we can discuss all that
when the patchset is posted.
