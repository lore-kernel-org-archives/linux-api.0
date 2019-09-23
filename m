From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Mon, 23 Sep 2019 16:23:27 +0200
Message-ID: <20190923142325.jowzbnwjw7g7si7j@wittgenstein>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <87pnjr9rth.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87pnjr9rth.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 23, 2019 at 01:26:34PM +0200, Florian Weimer wrote:
> * Michael Kerrisk:
> 
> > SYNOPSIS
> >        int pidfd_send_signal(int pidfd, int sig, siginfo_t info,
> >                              unsigned int flags);
> 
> This probably should reference a header for siginfo_t.

Agreed.

> 
> >        ESRCH  The target process does not exist.
> 
> If the descriptor is valid, does this mean the process has been waited
> for?  Maybe this can be made more explicit.

If by valid you mean "refers to a process/thread-group leader" aka is a
pidfd then yes: Getting ESRCH means that the process has exited and has
already been waited upon.
If it had only exited but not waited upon aka is a zombie, then sending
a signal will just work because that's currently how sending signals to
zombies works, i.e. if you only send a signal and don't do any
additional checks you won't notice a difference between a process being
alive and a process being a zombie. The userspace visible behavior in
terms of signaling them is identical.

> 
> >        The  pidfd_send_signal()  system call allows the avoidance of race
> >        conditions that occur when using traditional interfaces  (such  as
> >        kill(2)) to signal a process.  The problem is that the traditional
> >        interfaces specify the target process via a process ID (PID), with
> >        the  result  that the sender may accidentally send a signal to the
> >        wrong process if the originally intended target process has termi‐
> >        nated  and its PID has been recycled for another process.  By con‐
> >        trast, a PID file descriptor is a stable reference to  a  specific
> >        process;  if  that  process  terminates,  then the file descriptor
> >        ceases to be  valid  and  the  caller  of  pidfd_send_signal()  is
> >        informed of this fact via an ESRCH error.
> 
> It would be nice to explain somewhere how you can avoid the race using
> a PID descriptor.  Is there anything else besides CLONE_PIDFD?

If you're the parent of the process you can do this without CLONE_PIDFD:
pid = fork();
pidfd = pidfd_open();
ret = pidfd_send_signal(pidfd, 0, NULL, 0);
if (ret < 0 && errno == ESRCH)
	/* pidfd refers to another, recycled process */

> 
> >        static
> >        int pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
> >                unsigned int flags)
> >        {
> >            return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
> >        }
> 
> Please use a different function name.  Thanks.
