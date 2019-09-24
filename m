From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Tue, 24 Sep 2019 22:07:36 +0200
Message-ID: <20190924200735.2dvqhan7ynnmfc7s@wittgenstein>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <87pnjr9rth.fsf@mid.deneb.enyo.de>
 <20190923142325.jowzbnwjw7g7si7j@wittgenstein>
 <90dd38d5-34b3-b72f-8e5a-b51f944f22fb@gmail.com>
 <20190924195701.7pw2olbviieqsg5q@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190924195701.7pw2olbviieqsg5q@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 24, 2019 at 09:57:04PM +0200, Christian Brauner wrote:
> On Tue, Sep 24, 2019 at 09:44:49PM +0200, Michael Kerrisk (man-pages) wrote:
> > Hello Christian,
> > 
> > On 9/23/19 4:23 PM, Christian Brauner wrote:
> > > On Mon, Sep 23, 2019 at 01:26:34PM +0200, Florian Weimer wrote:
> > >> * Michael Kerrisk:
> > >>
> > >>> SYNOPSIS
> > >>>        int pidfd_send_signal(int pidfd, int sig, siginfo_t info,
> > >>>                              unsigned int flags);
> > >>
> > >> This probably should reference a header for siginfo_t.
> > > 
> > > Agreed.
> > > 
> > >>
> > >>>        ESRCH  The target process does not exist.
> > >>
> > >> If the descriptor is valid, does this mean the process has been waited
> > >> for?  Maybe this can be made more explicit.
> > > 
> > > If by valid you mean "refers to a process/thread-group leader" aka is a
> > > pidfd then yes: Getting ESRCH means that the process has exited and has
> > > already been waited upon.
> > > If it had only exited but not waited upon aka is a zombie, then sending
> > > a signal will just work because that's currently how sending signals to
> > > zombies works, i.e. if you only send a signal and don't do any
> > > additional checks you won't notice a difference between a process being
> > > alive and a process being a zombie. The userspace visible behavior in
> > > terms of signaling them is identical.
> > 
> > (Thanks for the clarification. I added the text "(i.e., it has 
> > terminated and been waited on)" to the ESRCH error.)
> > 
> > >>>        The  pidfd_send_signal()  system call allows the avoidance of race
> > >>>        conditions that occur when using traditional interfaces  (such  as
> > >>>        kill(2)) to signal a process.  The problem is that the traditional
> > >>>        interfaces specify the target process via a process ID (PID), with
> > >>>        the  result  that the sender may accidentally send a signal to the
> > >>>        wrong process if the originally intended target process has termi‐
> > >>>        nated  and its PID has been recycled for another process.  By con‐
> > >>>        trast, a PID file descriptor is a stable reference to  a  specific
> > >>>        process;  if  that  process  terminates,  then the file descriptor
> > >>>        ceases to be  valid  and  the  caller  of  pidfd_send_signal()  is
> > >>>        informed of this fact via an ESRCH error.
> > >>
> > >> It would be nice to explain somewhere how you can avoid the race using
> > >> a PID descriptor.  Is there anything else besides CLONE_PIDFD?
> > > 
> > > If you're the parent of the process you can do this without CLONE_PIDFD:
> > > pid = fork();
> > > pidfd = pidfd_open();
> > > ret = pidfd_send_signal(pidfd, 0, NULL, 0);
> > > if (ret < 0 && errno == ESRCH)
> > > 	/* pidfd refers to another, recycled process */
> > 
> > Although there is still the race between the fork() and the
> > pidfd_open(), right?
> 
> Actually no and my code is even too complex.
> If you are the parent, and this is really a sequence that obeys the
> ordering pidfd_open() before waiting:
> 
> pid = fork();
> if (pid == 0)
> 	exit(EXIT_SUCCESS);
> pidfd = pidfd_open(pid, 0);
> waitid(pid, ...);
> 
> Then you are guaranteed that pidfd will refer to pid. No recycling can
> happen since the process has not been waited upon yet (That is,
> excluding special cases such as where you have a mainloop where a
> callback reacts to a SIGCHLD event and waits on the child behind your
> back and your next callback in the mainloop calls pidfd_open() while the
> pid has been recycled etc.).

If we wanted to be super nitpicky one could also get in that situation
where you do:

signal(SIGCHLD,SIG_IGN);

// or

struct sigaction sa;
sa.sa_handler = SIG_IGN;
sigemptyset(&sa.sa_mask);
sa.sa_flags = 0;
sigaction(SIGCHLD, &sa, 0)

pid = fork();
if (pid == 0)
	exit(EXIT_SUCCESS);
pidfd = pidfd_open();

because then the process gets autoreaped and can be recycled. But again,
that's just bad form and in that scenario one should again use
clone(CLONE_PIDFD) instead of fork().

Christian
