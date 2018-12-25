From: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Tue, 25 Dec 2018 13:32:51 +0800
Message-ID: <CAJhGHyC=Zc=iG+iL+Ny8GsMd-5xypxdk4Et_1ZViMao5aXreCw@mail.gmail.com>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io> <20181202100304.labt63mzrlr5utdl@brauner.io>
 <8736rebl9s.fsf@oldenburg.str.redhat.com> <20181203180224.fkvw4kajtbvru2ku@brauner.io>
 <874lbtjvtd.fsf@oldenburg2.str.redhat.com> <CALCETrViXJ0gD34yVd8QpB-CSeKZzzncvkPHReycTiQin4r4WQ@mail.gmail.com>
 <87y392h4b7.fsf@oldenburg2.str.redhat.com> <C5E71146-DE79-4145-B54B-E161E7372D95@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C5E71146-DE79-4145-B54B-E161E7372D95@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Florian Weimer <fweimer@redhat.com>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Is it possible to avoid adding any syscall?

Since holding /proc/pid/reg_file can also hold the pid.
With this guarantee, /proc/pid/uuid (universally unique identifier ) can be
introduced to identify tasks, the kernel generates
a uuid for every task when created.

save_pid_uuid_pair_for_later_kill(int pid) {
  /* save via /proc/$pid/uuid */
  /* don't need to keep any fd after save */
}

safe_kill(pid, uuid, sig) {
    fd =3D open(/proc/$pid/uuid); /* also hold the pid until close() if
open() successes */
    if (open successes and read uuid from fd and if it equals to uuid)
        kill(pid, sig)
    close(fd)
}

All things needed to be done is to implement /proc/pid/uuid. And if pid can=
't
be recycled within 1 ticket, or the user can ensure it. The user can use
starttime(in /proc/pid/stat) instead.

save_pid_starttime_pair_for_later_kill(int pid) {
  /* save via /proc/$pid/stat */
  /* don't need to keep any fd after save or keep it for 1 ticket at most *=
/
}

safe_kill(pid, starttime, sig) {
    fd =3D open(/proc/$pid/stat); /* also hold the pid until close() if
open() successes */
    if (open successes and read starttime from fd and if it equals to start=
time)
        kill(pid, sig)
    close(fd)
}

In this case, zero LOC is added in the kernel. All of it depends on
the guarantee that holding /proc/pid/reg_file also holds the pid,
one of which I haven't checked carefully either.

On Fri, Dec 7, 2018 at 3:05 AM Christian Brauner <christian@brauner.io> wro=
te:
>
> On December 7, 2018 7:56:44 AM GMT+13:00, Florian Weimer <fweimer@redhat.=
com> wrote:
> >* Andy Lutomirski:
> >
> >>> I suppose that's fine.  Or alternatively, when thread group support
> >is
> >>> added, introduce a flag that applications have to use to enable it,
> >so
> >>> that they can probe for support by checking support for the flag.
> >>>
> >>> I wouldn't be opposed to a new system call like this either:
> >>>
> >>>  int procfd_open (pid_t thread_group, pid_t thread_id, unsigned
> >flags);
> >>>
> >>> But I think this is frowned upon on the kernel side.
> >>
> >> I have no problem with it, except that I think it shouldn=E2=80=99t re=
turn an
> >> fd that can be used for proc filesystem access.
> >
> >Oh no, my intention was that it would just be used with  *_send_signal
> >and related functions.
>
> Let's postpone that discussion a little.
> I think we don't need a syscall to base this off of pids.
> As I said I rather send my revived version of CLONE_NEWFD that would serv=
e the same task.
> The same way we could also just add a new open() flag that blocks fs acce=
ss completely.
> I just pitched that idea to Serge a few days back: O_NOCHDIR or similar.
> That could even be part of Aleksa's path resolution patchset.
>
> >
> >Thanks,
> >Florian
>
