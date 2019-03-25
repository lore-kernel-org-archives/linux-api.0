From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 13:14:58 -0700
Message-ID: <CAKOZueuYMKdkt8BoSj1+p7=mpe2PA8r7xT5QiF6q3cTK+6HsAA@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <CAKOZuetbZOs1Yur4OrW6hh3wVYdoKNkSqTszbpTWnuRBTmT9zA@mail.gmail.com>
 <CAGLj2rE1f4x36KFUjFLiFq8tF1RUmFuCSRTg_tCQ9W2G6LtizA@mail.gmail.com>
 <CAKOZuetCFgu0B53+mGmQ3+539MPT_tiu-PACx2ATvihHrrmUKg@mail.gmail.com> <CAGLj2rHETs+FjkOVP6PJ_EiePP7FKiDwxaWyjwg1gMZPYpU1fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGLj2rHETs+FjkOVP6PJ_EiePP7FKiDwxaWyjwg1gMZPYpU1fQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthus>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 12:42 PM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
>
> On Mon, Mar 25, 2019 at 6:57 PM Daniel Colascione <dancol@google.com> wrote:
> >
> > On Mon, Mar 25, 2019 at 11:19 AM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
> > >
> > > On Mon, Mar 25, 2019 at 5:53 PM Daniel Colascione <dancol@google.com> wrote:
> > > >
> > > > [..snip..]
> > > >
> > > > I don't like the idea of having one kind of pollfd be pollable and
> > > > another not. Such an interface would be confusing for users. If, as
> > > > you suggest below, we instead make the procfs-less FD the only thing
> > > > we call a "pidfd", then this proposal becomes less confusing and more
> > > > viable.
> > >
> > > That's certainly on the table, we remove the ability to open
> > > /proc/<PID> and use the dir fd with pidfd_send_signal. I'm in favor of
> > > this.
> > >
> > > > > But.. one thing we could do for Daniel usecase is if a /proc/pid directory fd
> > > > > can be translated into a "pidfd" using another syscall or even a node, like
> > > > > /proc/pid/handle or something. I think this is what Christian suggested in
> > > > > the previous threads.
> > > >
> > > > /proc/pid/handle, if I understand correctly, "translates" a
> > > > procfs-based pidfd to a non-pidfd one. The needed interface would have
> > > > to perform the opposite translation, providing a procfs directory for
> > > > a given pidfd.
> > > >
> > > > > And also for the translation the other way, add a syscall or modify
> > > > > translate_fd or something, to covert a anon_inode pidfd into a /proc/pid
> > > > > directory fd. Then the user is welcomed to do openat(2) on _that_ directory fd.
> > > > > Then we modify pidfd_send_signal to only send signals to pure pidfd fds, not
> > > > > to /proc/pid directory fds.
> > > >
> > > > This approach would work, but there's one subtlety to take into
> > > > account: which procfs? You'd want to take, as inputs, 1) the procfs
> > > > root you want, and 2) the pidfd, this way you could return to the user
> > > > a directory FD in the right procfs.
> > > >
> > >
> > > I don't think metadata access is in the scope of such a pidfd itself.
> >
> > It should be possible to write a race-free pkill(1) using pidfds.
> > Without metadata access tied to the pidfd somehow, that can't be done.
> >
> >
> > > > > Should we work on patches for these? Please let us know if this idea makes
> > > > > sense and thanks a lot for adding us to the review as well.
> > > >
> > > > I would strongly prefer that we not merge pidctl (or whatever it is)
> > > > without a story for metadata access, be it your suggestion or
> > > > something else.
> > >
> > > IMO, this is out of scope for a process handle. Hence, the need for
> > > metadata access musn't stall it as is.
> >
> > On the contrary, rather than metadata being out of scope, metadata
> > access is essential. Given a file handle (an FD), you can learn about
> > the file backing that handle by using fstat(2). Given a socket handle
> > (a socket FD), you can learn about the socket with getsockopt(2) and
> > ioctl(2). It would be strange not to be able, similarly, to learn
> > things about a process given a handle (a pidfd) to that process. I
> > want process handles to be "boring" in that they let users query and
> > manipulate processes mostly like they manipulate other resources.
> >
>
> Yes, but everything in /proc is not equivalent to an attribute, or an
> option, and depending on its configuration, you may not want to allow
> processes to even be able to see /proc for any PIDs other than those
> running as their own user (hidepid). This means, even if this new
> system call is added, to respect hidepid, it must, depending on if
> /proc is mounted (and what hidepid is set to, and what gid= is set
> to), return EPERM, because then there is a discrepancy between how the
> two entrypoints to acquire a process handle do access control.

That's why I proposed that this translation mechanism accept a procfs
root directory --- so you'd specify *which* procfs you want and let
the kernel apply whatever hidepid access restrictions it wants.

[snip]

> PIDs however are addressable with kill(2) even with hidepid enabled.
> For good reason, the capabilities you can exercise using a PID is
> limited in that case. The same logic applies to a process reference
> like pidfd.

Sure. I'm not proposing a mechanism that would grant anyone additional
access to anything --- I'm just suggesting that we provide a way to
"directly" open a procfs dirfd instead of having people parse an
fdinfo text file.

> I agree there should be some way (if you can take care of the hidepid
> gotcha) to return a dir fd of /proc entry, but I don't think it should
> be the pidfd itself.

It's fine that pidfds aren't procfs directory FDs so long as there's a
race-free way to go from the former to the latter.

> You can get it to work using the fdinfo thing for
> now.
>
> > > If you really need this, the pid this pidfd is mapped to can be
> > > exposed through fdinfo (which is perfectly fine for your case as you
> > > use /proc anyway). This means you can reliably determine if you're
> > > opening it for the same pid (and it hasn't been recycled) because this
> > > pidfd will be pollable for state change (in the future). Exposing it
> > > through fdinfo isn't a problem, pid ns is bound to the process during
> > > its lifetime, it's a process creation time property, so the value
> > > isn't going to change anyway. So you can do all metadata access you
> > > want subsequently.
> >
> > Thanks for the proposal. I'm a bit confused. Are you suggesting that
> > we report the numeric FD in fdinfo? Are you saying it should work
> > basically like this?
> >
>
> Yes, numeric PID that you would see from your namespace for the said
> process the pidfd is for.
> It could be -1 if this process is not in any
> of the namespaces (current or children) (which would happen, say if
> you pass it to some other pidns residing process, during fd
> installation on ithe target process we set that up properly).
>
> > int get_oom_score_adj(int pidfd) {
> >   unique_fd fdinfo_fd = open(fmt("/proc/self/fdinfo/%d", pidfd));
> >   string fdinfo = read_all(fdinfo_fd);
> >   numeric_pid = parse_fdinfo_for_line("pid");
> >   unique_fd procdir_fd = open(fmt("/proc/%d", numeric_pid), O_DIRECTORY);
> >   if(!is_pidfd_alive(pidfd)) { return -1; /* process died */ } /*
> > LIVENESS CHECK */
> >   // We know the process named by pidfd was called NUMERIC_PID
> >   // in our namespace (because fdinfo told us) and we know that the
> > named process
> >   // was alive after we successfully opened its /proc/pid directory, therefore,
> >   // PROCDIR_FD and PIDFD must refer to the same underlying process.
> >   unique_fd oom_adj_score_fd = openat(procdir_fd, "oom_score_adj");
> >   return parse_int(read_all(oom_adj_score_fd));
> > }
> >
> > While this interface functions correctly, I have two concerns: 1) the
> > number of system calls necessary is very large -- by my count,
> > starting with the pifd, we need six, not counting the follow-on
> > close(2) calls (which would bring the total to nine[1]),
>
> But hey, that's a bit rich if you're planning to collect metadata from
> /proc ;-).

Depends on which interface --- reading something like oom_score_adj is
pretty cheap.

> > and 2) it's
> > "fail unsafe": IMHO, most users in practice will skip the line marked
> > "LIVENESS CHECK", and as a result, their code will appear to work but
> > contain subtle race conditions. An explicit interface to translate
> > from a (PIDFD, PROCFS_ROOT) tuple to a /proc/pid directory file
> > descriptor would be both more efficient and fail-safe.
> >
> > [1] as a separate matter, it'd be nice to have a batch version of close(2).
>
> Since /proc is full of gunk,

People keep saying /proc is bad, but I haven't seen any serious
proposals for a clean replacement. :-)

> how about adding more to it and making
> the magic symlink of /proc/self/fd for the pidfd to lead to the dirfd
> of the /proc entry of the process it maps to, when one uses
> O_DIRECTORY while opening it? Otherwise, it behaves as it does today.
> It would be equivalent to opening the proc entry with usual access
> restrictions (and hidepid made to work) but without the races, and
> because for processes outside your and children pid ns, it shouldn't
> work anyway, and since they wouldn't have their entry on this procfs
> instance, it would all just fit in nicely?

Thanks. That'll work. It's a bit magical, but /proc/self/fd is magical
anyway, so that's okay.
