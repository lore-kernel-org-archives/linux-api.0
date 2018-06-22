From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 1/4] seccomp: add a return code to trap to userspace
Date: Fri, 22 Jun 2018 16:40:20 +0200
Message-ID: <CAG48ez3Ek_KG54ejR=Q=XtW_HDs8hQ+cgFODzn4rQ0nVDVpODg@mail.gmail.com>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180621220416.5412-2-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621220416.5412-2-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 22, 2018 at 12:05 AM Tycho Andersen <tycho@tycho.ws> wrote:
> This patch introduces a means for syscalls matched in seccomp to notify
> some other task that a particular filter has been triggered.
>
> The motivation for this is primarily for use with containers. For example,
> if a container does an init_module(), we obviously don't want to load this
> untrusted code, which may be compiled for the wrong version of the kernel
> anyway. Instead, we could parse the module image, figure out which module
> the container is trying to load and load it on the host.
>
> As another example, containers cannot mknod(), since this checks
> capable(CAP_SYS_ADMIN). However, harmless devices like /dev/null or
> /dev/zero should be ok for containers to mknod, but we'd like to avoid hard
> coding some whitelist in the kernel. Another example is mount(), which has
> many security restrictions for good reason, but configuration or runtime
> knowledge could potentially be used to relax these restrictions.
>
> This patch adds functionality that is already possible via at least two
> other means that I know about, both of which involve ptrace(): first, one
> could ptrace attach, and then iterate through syscalls via PTRACE_SYSCALL.
> Unfortunately this is slow, so a faster version would be to install a
> filter that does SECCOMP_RET_TRACE, which triggers a PTRACE_EVENT_SECCOMP.
> Since ptrace allows only one tracer, if the container runtime is that
> tracer, users inside the container (or outside) trying to debug it will not
> be able to use ptrace, which is annoying. It also means that older
> distributions based on Upstart cannot boot inside containers using ptrace,
> since upstart itself uses ptrace to start services.
>
> The actual implementation of this is fairly small, although getting the
> synchronization right was/is slightly complex.
>
> Finally, it's worth noting that the classic seccomp TOCTOU of reading
> memory data from the task still applies here, but can be avoided with
> careful design of the userspace handler: if the userspace handler reads all
> of the task memory that is necessary before applying its security policy,
> the tracee's subsequent memory edits will not be read by the tracer.

I've been thinking about how one would actually write userspace code
that uses this API, and whether PID reuse is an issue here. As far as
I can tell, the following situation can happen:

 - seccomped process tries to perform a syscall that gets trapped
 - notification is sent to the supervisor
 - supervisor reads the notification
 - seccomped process gets SIGKILLed
 - new process appears with the PID that the seccomped process had
 - supervisor tries to access memory of the seccomped process via
process_vm_{read,write}v or /proc/$pid/mem
 - supervisor unintentionally accesses memory of the new process instead

This could have particularly nasty consequences if the supervisor has
to write to memory of the seccomped process for some reason.
It might make sense to explicitly document how the API has to be used
to avoid such a scenario from occuring. AFAICS,
process_vm_{read,write}v are fundamentally unsafe for this;
/proc/$pid/mem might be safe if you do the following dance in the
supervisor to validate that you have a reference to the right struct
mm before starting to actually access memory:

 - supervisor reads a syscall notification for the seccomped process with PID $A
 - supervisor opens /proc/$A/mem [taking a reference on the mm of the
process that currently has PID $A]
 - supervisor reads all pending events from the notification FD; if
one of them says that PID $A was signalled, send back -ERESTARTSYS (or
-ERESTARTNOINTR?) and bail out
 - [at this point, the open FD to /proc/$A/mem is known to actually
refer to the mm struct of the seccomped process]
 - read and write on the open FD to /proc/$A/mem as necessary
 - send back the syscall result

It might be nice if the kernel was able to directly give the
supervisor an FD to /proc/$A/mem that is guaranteed to point to the
right struct mm, but trying to implement that would probably make this
patch set significantly larger?
