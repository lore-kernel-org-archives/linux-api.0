From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 18:41:31 +0100
Message-ID: <20181206174129.taakmwekysbkaosu@brauner.io>
References: <20181206121858.12215-1-christian@brauner.io>
 <87sgzahf7k.fsf@xmission.com>
 <CAKOZuet4ayDu-54u2tO9tRDCgxa9JQ4avAiYS8xEtReN4MMhAA@mail.gmail.com>
 <878t12efg3.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878t12efg3.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 06, 2018 at 11:24:28AM -0600, Eric W. Biederman wrote:
> Daniel Colascione <dancol@google.com> writes:
> 
> > On Thu, Dec 6, 2018 at 7:02 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >>
> >> Christian Brauner <christian@brauner.io> writes:
> >>
> >> > The kill() syscall operates on process identifiers (pid). After a process
> >> > has exited its pid can be reused by another process. If a caller sends a
> >> > signal to a reused pid it will end up signaling the wrong process. This
> >> > issue has often surfaced and there has been a push [1] to address this
> >> > problem.
> >> >
> >> > This patch uses file descriptors (fd) from proc/<pid> as stable handles on
> >> > struct pid. Even if a pid is recycled the handle will not change. The fd
> >> > can be used to send signals to the process it refers to.
> >> > Thus, the new syscall taskfd_send_signal() is introduced to solve this
> >> > problem. Instead of pids it operates on process fds (taskfd).
> >>
> >> I am not yet thrilled with the taskfd naming.
> >
> > Both the old and new names were fine. Do you want to suggest a name at
> > this point? You can't just say "I don't like this. Guess again"
> > forever.
> 
> Both names suck, as neither name actually describes what the function is
> designed to do.
> 
> Most issues happen at the interface between abstractions.  A name that
> confuses your users will just make that confusion more likely.  So it is
> important that we do the very best with the name that we can do.
> 
> We are already having questions about what happens when you perform the
> non-sense operation of sending a signal to a zombie.  It comes up
> because there are races when a process may die and you are not expecting
> it.  That is an issue with the existing signal sending API, that has
> caused confusion.   That isn't half as confusing as the naming issue.
> 
> A task in linux is a single thread.  A process is all of the threads.
> If we are going to support both cases it doesn't make sense to hard code
> a single case in the name.
> 
> I would be inclined to simplify things and call the syscall something
> like "fdkill(int fd, struct siginfo *info, int flags)".  Or perhaps

No, definitely nothing with "kill" will be used because that's
absolutely not expressing what this syscall is doing.

> just "fd_send_signal(int fd, struct siginfo *info, int flags)".
> 
> Then we are not overspecifying what the system call does in the name.

I feel changing the name around by a single persons preferences is not
really a nice thing to do community-wise. So I'd like to hear other
people chime in first before I make that change.

> Plus it makes it clear that the fd specifies where the signal goes.
> Something I see that by your reply below that you were confused about.
> 
> >> Is there any plan to support sesssions and process groups?
> >
> > Such a thing could be added with flags in the future. Why complicate
> > this patch?
> 
> Actually that isn't the way this is designed.  You would have to have
> another kind of file descriptor.  I am asking because it goes to the
> question of naming and what we are trying to do here.
> 
> We don't need to implement that but we have already looked into this
> kind of extensibility.  If we want the extensibility we should make
> room for it, or just close the door.  Having the door half open and a
> confusing interface is a problem for users.
> 
> >> I am concerned about using kill_pid_info.  It does this:
> >>
> >>
> >>         rcu_read_lock();
> >>         p = pid_task(pid, PIDTYPE_PID);
> >>         if (p)
> >>                 error = group_send_sig_info(sig, info, p, PIDTYPE_TGID);
> >>         rcu_read_unlock();
> >>
> >> That pid_task(PIDTYPE_PID) is fine for existing callers that need bug
> >> compatibility.  For new interfaces I would strongly prefer pid_task(PIDTYPE_TGID).
> >
> > What is the bug that PIDTYPE_PID preserves?
> 
> I am not 100% certain all of the bits for this to matter have been
> merged yet but we are close enough that it would not be hard to make it
> matter.
> 
> There are two strange behaviours of ordinary kill on the linux kernel
> that I am aware of.
> 
> 1) kill(thread_id,...) where the thread_id is not the id of the first
>    thread and the thread_id thus the pid of the process sends the signal
>    to the entire process.  Something that arguably should not happen.
> 
> 2) kill(pid,...) where the original thread has exited performs the
>    permission checks against the dead signal group leader.  Which means
>    that the permission checks for sending a signal are very likely wrong
>    for a multi-threaded processes that calls a function like setuid.
> 
> To fix the second case we are going to have to perform the permission
> checks on a non-zombie thread.  That is something that is straight
> forward to make work with PIDTYPE_TGID.  It is not so easy to make work
> with PIDTYPE_PID.
> 
> I looked and it doesn't look like I have merged the logic of having
> PIDTYPE_TGID point to a living thread when the signal group leader
> exits and becomes a zombie.  It isn't hard but it does require some very
> delicate surgery on the code, so that we don't break some of the
> historic confusion of threads and process groups.

Then this seems irrelevant to the current patch. It seems we can simply
switch to PIDTYPE_PGID once your new logic lands but not right now.
