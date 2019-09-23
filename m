From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Mon, 23 Sep 2019 13:26:34 +0200
Message-ID: <87pnjr9rth.fsf@mid.deneb.enyo.de>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com> (Michael
        Kerrisk's message of "Mon, 23 Sep 2019 11:12:00 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Michael Kerrisk:

> SYNOPSIS
>        int pidfd_send_signal(int pidfd, int sig, siginfo_t info,
>                              unsigned int flags);

This probably should reference a header for siginfo_t.

>        ESRCH  The target process does not exist.

If the descriptor is valid, does this mean the process has been waited
for?  Maybe this can be made more explicit.

>        The  pidfd_send_signal()  system call allows the avoidance of race
>        conditions that occur when using traditional interfaces  (such  as
>        kill(2)) to signal a process.  The problem is that the traditional
>        interfaces specify the target process via a process ID (PID), with
>        the  result  that the sender may accidentally send a signal to the
>        wrong process if the originally intended target process has termi‐
>        nated  and its PID has been recycled for another process.  By con‐
>        trast, a PID file descriptor is a stable reference to  a  specific
>        process;  if  that  process  terminates,  then the file descriptor
>        ceases to be  valid  and  the  caller  of  pidfd_send_signal()  is
>        informed of this fact via an ESRCH error.

It would be nice to explain somewhere how you can avoid the race using
a PID descriptor.  Is there anything else besides CLONE_PIDFD?

>        static
>        int pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
>                unsigned int flags)
>        {
>            return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
>        }

Please use a different function name.  Thanks.
