From: Jann Horn <jannh@google.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Wed, 25 Sep 2019 03:48:45 +0200
Message-ID: <CAG48ez17sqfpmzDKyPBm+h4P8LtCC8_V=StySK2gXcxGaD4mxg@mail.gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com> <87pnjr9rth.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87pnjr9rth.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 23, 2019 at 1:26 PM Florian Weimer <fw@deneb.enyo.de> wrote:
> * Michael Kerrisk:
> >        The  pidfd_send_signal()  system call allows the avoidance of ra=
ce
> >        conditions that occur when using traditional interfaces  (such  =
as
> >        kill(2)) to signal a process.  The problem is that the tradition=
al
> >        interfaces specify the target process via a process ID (PID), wi=
th
> >        the  result  that the sender may accidentally send a signal to t=
he
> >        wrong process if the originally intended target process has term=
i=E2=80=90
> >        nated  and its PID has been recycled for another process.  By co=
n=E2=80=90
> >        trast, a PID file descriptor is a stable reference to  a  specif=
ic
> >        process;  if  that  process  terminates,  then the file descript=
or
> >        ceases to be  valid  and  the  caller  of  pidfd_send_signal()  =
is
> >        informed of this fact via an ESRCH error.
>
> It would be nice to explain somewhere how you can avoid the race using
> a PID descriptor.  Is there anything else besides CLONE_PIDFD?

My favorite example here is that you could implement "killall" without
PID reuse races. With /proc/$pid file descriptors, you could do it
like this (rough pseudocode with missing error handling and resource
leaks and such):

for each pid {
  procfs_pid_fd =3D open("/proc/"+pid);
  if (procfs_pid_fd =3D=3D -1) continue;
  comm_fd =3D openat(procfs_pid_fd, "comm");
  if (comm_fd =3D=3D -1) continue;
  char buf[1000];
  int n =3D read(comm_fd, buf, sizeof(buf)-1);
  buf[n] =3D 0;
  if (strcmp(buf, expected_comm) =3D=3D 0) {
    pidfd_send_signal(procfs_pid_fd, SIGKILL, NULL, 0);
  }
}

If you want to avoid using a procfs fd for this, I think you can still
do it, the dance just gets more complicated:

for each pid {
  procfs_pid_fd =3D open("/proc/"+pid);
  if (procfs_pid_fd =3D=3D -1) continue;
  pid_fd =3D pidfd_open(pid, 0);
  if (pid_fd =3D=3D -1) continue;
  /* at this point procfs_pid_fd and pid_fd may refer to different processe=
s */
  comm_fd =3D openat(procfs_pid_fd, "comm");
  if (comm_fd =3D=3D -1) continue;
  /* at this point we know that procfs_pid_fd and pid_fd refer to the
same struct pid, because otherwise the procfs_pid_fd must point to a
directory that throws -ESRCH for everything */
  char buf[1000];
  int n =3D read(comm_fd, buf, sizeof(buf)-1);
  buf[n] =3D 0;
  if (strcmp(buf, expected_comm) =3D=3D 0) {
    pidfd_send_signal(pid_fd, SIGKILL, NULL, 0);
  }
}

But I don't think anyone is actually interested in using pidfds for
this kind of usecase right now.
