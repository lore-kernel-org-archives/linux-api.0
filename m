From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 11:57:20 -0700
Message-ID: <CAKOZuetCFgu0B53+mGmQ3+539MPT_tiu-PACx2ATvihHrrmUKg@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <CAKOZuetbZOs1Yur4OrW6hh3wVYdoKNkSqTszbpTWnuRBTmT9zA@mail.gmail.com>
 <CAGLj2rE1f4x36KFUjFLiFq8tF1RUmFuCSRTg_tCQ9W2G6LtizA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGLj2rE1f4x36KFUjFLiFq8tF1RUmFuCSRTg_tCQ9W2G6LtizA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthus>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 11:19 AM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
>
> On Mon, Mar 25, 2019 at 5:53 PM Daniel Colascione <dancol@google.com> wrote:
> >
> > [..snip..]
> >
> > I don't like the idea of having one kind of pollfd be pollable and
> > another not. Such an interface would be confusing for users. If, as
> > you suggest below, we instead make the procfs-less FD the only thing
> > we call a "pidfd", then this proposal becomes less confusing and more
> > viable.
>
> That's certainly on the table, we remove the ability to open
> /proc/<PID> and use the dir fd with pidfd_send_signal. I'm in favor of
> this.
>
> > > But.. one thing we could do for Daniel usecase is if a /proc/pid directory fd
> > > can be translated into a "pidfd" using another syscall or even a node, like
> > > /proc/pid/handle or something. I think this is what Christian suggested in
> > > the previous threads.
> >
> > /proc/pid/handle, if I understand correctly, "translates" a
> > procfs-based pidfd to a non-pidfd one. The needed interface would have
> > to perform the opposite translation, providing a procfs directory for
> > a given pidfd.
> >
> > > And also for the translation the other way, add a syscall or modify
> > > translate_fd or something, to covert a anon_inode pidfd into a /proc/pid
> > > directory fd. Then the user is welcomed to do openat(2) on _that_ directory fd.
> > > Then we modify pidfd_send_signal to only send signals to pure pidfd fds, not
> > > to /proc/pid directory fds.
> >
> > This approach would work, but there's one subtlety to take into
> > account: which procfs? You'd want to take, as inputs, 1) the procfs
> > root you want, and 2) the pidfd, this way you could return to the user
> > a directory FD in the right procfs.
> >
>
> I don't think metadata access is in the scope of such a pidfd itself.

It should be possible to write a race-free pkill(1) using pidfds.
Without metadata access tied to the pidfd somehow, that can't be done.

> > > Should we work on patches for these? Please let us know if this idea makes
> > > sense and thanks a lot for adding us to the review as well.
> >
> > I would strongly prefer that we not merge pidctl (or whatever it is)
> > without a story for metadata access, be it your suggestion or
> > something else.
>
> IMO, this is out of scope for a process handle. Hence, the need for
> metadata access musn't stall it as is.

On the contrary, rather than metadata being out of scope, metadata
access is essential. Given a file handle (an FD), you can learn about
the file backing that handle by using fstat(2). Given a socket handle
(a socket FD), you can learn about the socket with getsockopt(2) and
ioctl(2). It would be strange not to be able, similarly, to learn
things about a process given a handle (a pidfd) to that process. I
want process handles to be "boring" in that they let users query and
manipulate processes mostly like they manipulate other resources.

> If you really need this, the pid this pidfd is mapped to can be
> exposed through fdinfo (which is perfectly fine for your case as you
> use /proc anyway). This means you can reliably determine if you're
> opening it for the same pid (and it hasn't been recycled) because this
> pidfd will be pollable for state change (in the future). Exposing it
> through fdinfo isn't a problem, pid ns is bound to the process during
> its lifetime, it's a process creation time property, so the value
> isn't going to change anyway. So you can do all metadata access you
> want subsequently.

Thanks for the proposal. I'm a bit confused. Are you suggesting that
we report the numeric FD in fdinfo? Are you saying it should work
basically like this?

int get_oom_score_adj(int pidfd) {
  unique_fd fdinfo_fd = open(fmt("/proc/self/fdinfo/%d", pidfd));
  string fdinfo = read_all(fdinfo_fd);
  numeric_pid = parse_fdinfo_for_line("pid");
  unique_fd procdir_fd = open(fmt("/proc/%d", numeric_pid), O_DIRECTORY);
  if(!is_pidfd_alive(pidfd)) { return -1; /* process died */ } /*
LIVENESS CHECK */
  // We know the process named by pidfd was called NUMERIC_PID
  // in our namespace (because fdinfo told us) and we know that the
named process
  // was alive after we successfully opened its /proc/pid directory, therefore,
  // PROCDIR_FD and PIDFD must refer to the same underlying process.
  unique_fd oom_adj_score_fd = openat(procdir_fd, "oom_score_adj");
  return parse_int(read_all(oom_adj_score_fd));
}

While this interface functions correctly, I have two concerns: 1) the
number of system calls necessary is very large -- by my count,
starting with the pifd, we need six, not counting the follow-on
close(2) calls (which would bring the total to nine[1]), and 2) it's
"fail unsafe": IMHO, most users in practice will skip the line marked
"LIVENESS CHECK", and as a result, their code will appear to work but
contain subtle race conditions. An explicit interface to translate
from a (PIDFD, PROCFS_ROOT) tuple to a /proc/pid directory file
descriptor would be both more efficient and fail-safe.

[1] as a separate matter, it'd be nice to have a batch version of close(2).
