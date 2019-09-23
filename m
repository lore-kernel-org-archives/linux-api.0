From: Daniel Colascione <dancol@google.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Mon, 23 Sep 2019 04:31:09 -0700
Message-ID: <CAKOZuetMK0eRxBrR8wXo_qCaQ7OGKQHqAy15cX437+Q+cvbbvA@mail.gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 23, 2019 at 2:12 AM Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
>        The  pidfd_send_signal()  system call allows the avoidance of race
>        conditions that occur when using traditional interfaces  (such  as
>        kill(2)) to signal a process.  The problem is that the traditional
>        interfaces specify the target process via a process ID (PID), with
>        the  result  that the sender may accidentally send a signal to the
>        wrong process if the originally intended target process has termi=
=E2=80=90
>        nated  and its PID has been recycled for another process.  By con=
=E2=80=90
>        trast, a PID file descriptor is a stable reference to  a  specific
>        process;  if  that  process  terminates,  then the file descriptor
>        ceases to be  valid

The file *descriptor* remains valid even after the process to which it
refers exits. You can close(2) the file descriptor without getting
EBADF. I'd say, instead, that "a PID file descriptor is a stable
reference to a specific process; process-related operations on a PID
file descriptor fail after that process exits".
