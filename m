From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 08:17:18 -0800
Message-ID: <CAKOZuet4ayDu-54u2tO9tRDCgxa9JQ4avAiYS8xEtReN4MMhAA@mail.gmail.com>
References: <20181206121858.12215-1-christian@brauner.io> <87sgzahf7k.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87sgzahf7k.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 6, 2018 at 7:02 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Christian Brauner <christian@brauner.io> writes:
>
> > The kill() syscall operates on process identifiers (pid). After a process
> > has exited its pid can be reused by another process. If a caller sends a
> > signal to a reused pid it will end up signaling the wrong process. This
> > issue has often surfaced and there has been a push [1] to address this
> > problem.
> >
> > This patch uses file descriptors (fd) from proc/<pid> as stable handles on
> > struct pid. Even if a pid is recycled the handle will not change. The fd
> > can be used to send signals to the process it refers to.
> > Thus, the new syscall taskfd_send_signal() is introduced to solve this
> > problem. Instead of pids it operates on process fds (taskfd).
>
> I am not yet thrilled with the taskfd naming.

Both the old and new names were fine. Do you want to suggest a name at
this point? You can't just say "I don't like this. Guess again"
forever.

> Is there any plan to support sesssions and process groups?

Such a thing could be added with flags in the future. Why complicate this patch?

> I am concerned about using kill_pid_info.  It does this:
>
>
>         rcu_read_lock();
>         p = pid_task(pid, PIDTYPE_PID);
>         if (p)
>                 error = group_send_sig_info(sig, info, p, PIDTYPE_TGID);
>         rcu_read_unlock();
>
> That pid_task(PIDTYPE_PID) is fine for existing callers that need bug
> compatibility.  For new interfaces I would strongly prefer pid_task(PIDTYPE_TGID).

What is the bug that PIDTYPE_PID preserves?
