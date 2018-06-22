From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 1/4] seccomp: add a return code to trap to userspace
Date: Fri, 22 Jun 2018 18:24:07 +0200
Message-ID: <CAG48ez0_k=6RmEaM4yTYyHe4B9uWKTLPxSX4Tz6ZXU5noKvCCQ@mail.gmail.com>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180621220416.5412-2-tycho@tycho.ws>
 <CAG48ez3Ek_KG54ejR=Q=XtW_HDs8hQ+cgFODzn4rQ0nVDVpODg@mail.gmail.com> <20180622151514.GM3992@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622151514.GM3992@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: tycho@tycho.ws
Cc: keescook@chromium.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, luto@amacapital.net, oleg@redhat.com, ebiederm@xmission.com, serge@hallyn.com, christian.brauner@ubuntu.com, tyhicks@canonical.com, suda.akihiro@lab.ntt.co.jp, me@tobin.cc
List-Id: linux-api@vger.kernel.org

On Fri, Jun 22, 2018 at 5:15 PM Tycho Andersen <tycho@tycho.ws> wrote:
>
> Hi Jann,
>
> On Fri, Jun 22, 2018 at 04:40:20PM +0200, Jann Horn wrote:
> > On Fri, Jun 22, 2018 at 12:05 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > This patch introduces a means for syscalls matched in seccomp to notify
> > > some other task that a particular filter has been triggered.
> > >
> > > The motivation for this is primarily for use with containers. For example,
> > > if a container does an init_module(), we obviously don't want to load this
> > > untrusted code, which may be compiled for the wrong version of the kernel
> > > anyway. Instead, we could parse the module image, figure out which module
> > > the container is trying to load and load it on the host.
> > >
> > > As another example, containers cannot mknod(), since this checks
> > > capable(CAP_SYS_ADMIN). However, harmless devices like /dev/null or
> > > /dev/zero should be ok for containers to mknod, but we'd like to avoid hard
> > > coding some whitelist in the kernel. Another example is mount(), which has
> > > many security restrictions for good reason, but configuration or runtime
> > > knowledge could potentially be used to relax these restrictions.
> > >
> > > This patch adds functionality that is already possible via at least two
> > > other means that I know about, both of which involve ptrace(): first, one
> > > could ptrace attach, and then iterate through syscalls via PTRACE_SYSCALL.
> > > Unfortunately this is slow, so a faster version would be to install a
> > > filter that does SECCOMP_RET_TRACE, which triggers a PTRACE_EVENT_SECCOMP.
> > > Since ptrace allows only one tracer, if the container runtime is that
> > > tracer, users inside the container (or outside) trying to debug it will not
> > > be able to use ptrace, which is annoying. It also means that older
> > > distributions based on Upstart cannot boot inside containers using ptrace,
> > > since upstart itself uses ptrace to start services.
> > >
> > > The actual implementation of this is fairly small, although getting the
> > > synchronization right was/is slightly complex.
> > >
> > > Finally, it's worth noting that the classic seccomp TOCTOU of reading
> > > memory data from the task still applies here, but can be avoided with
> > > careful design of the userspace handler: if the userspace handler reads all
> > > of the task memory that is necessary before applying its security policy,
> > > the tracee's subsequent memory edits will not be read by the tracer.
> >
> > I've been thinking about how one would actually write userspace code
> > that uses this API, and whether PID reuse is an issue here. As far as
> > I can tell, the following situation can happen:
> >
> >  - seccomped process tries to perform a syscall that gets trapped
> >  - notification is sent to the supervisor
> >  - supervisor reads the notification
> >  - seccomped process gets SIGKILLed
> >  - new process appears with the PID that the seccomped process had
> >  - supervisor tries to access memory of the seccomped process via
> > process_vm_{read,write}v or /proc/$pid/mem
> >  - supervisor unintentionally accesses memory of the new process instead
> >
> > This could have particularly nasty consequences if the supervisor has
> > to write to memory of the seccomped process for some reason.
> > It might make sense to explicitly document how the API has to be used
> > to avoid such a scenario from occuring. AFAICS,
> > process_vm_{read,write}v are fundamentally unsafe for this;
> > /proc/$pid/mem might be safe if you do the following dance in the
> > supervisor to validate that you have a reference to the right struct
> > mm before starting to actually access memory:
> >
> >  - supervisor reads a syscall notification for the seccomped process with PID $A
> >  - supervisor opens /proc/$A/mem [taking a reference on the mm of the
> > process that currently has PID $A]
> >  - supervisor reads all pending events from the notification FD; if
> > one of them says that PID $A was signalled, send back -ERESTARTSYS (or
> > -ERESTARTNOINTR?) and bail out
> >  - [at this point, the open FD to /proc/$A/mem is known to actually
> > refer to the mm struct of the seccomped process]
> >  - read and write on the open FD to /proc/$A/mem as necessary
> >  - send back the syscall result
>
> Yes, this is a nasty problem :(. We have the id in the
> request/response structs to avoid this race, so perhaps we can re-use
> that? So it would look like:
>
> - supervisor gets syscall notification for $A
> - supervisor opens /proc/$A/mem or /proc/$A/map_files/... or a dir fd
>   to the container's root or whatever

(or open a dir fd to /proc/$A; then later, you can use openat()
relative to that to open whatever you need)

> - supervisor calls seccomp(SECCOMP_NOTIFICATION_IS_VALID, req->id, listener_fd)
> - supervisor knows that the fds it has open are safe
>
> That way it doesn't have to flush the whole queue? Of course this
> makes things a lot slower, but it does enable safety for more than
> just memory accesses, and also isn't required for things which
> wouldn't read memory.

That sounds good to me. :)

> > It might be nice if the kernel was able to directly give the
> > supervisor an FD to /proc/$A/mem that is guaranteed to point to the
> > right struct mm, but trying to implement that would probably make this
> > patch set significantly larger?
>
> I'll take a look and see how big it is, it doesn't *seem* like it
> should be that hard. Famous last words :)

Good luck. :D

If you do manage to implement this, it might actually make sense to
hand out an O_PATH FD to /proc/$A (or perhaps more accurately,
/proc/$A/task/$A?) instead of an FD to /proc/*/mem. Then you could
safely open whatever files you need from the process' procfs directory
in a race-free manner.

I think you'd have to add some way to tell the kernel in which procfs
instance you want the lookup to happen; so I think you'd need to
supply an FD to the root of a procfs when opening a notification fd,
and then in the read handler, you'd have to perform a lookup in
procfs.
