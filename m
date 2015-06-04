From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Thu, 4 Jun 2015 11:15:01 -0600
Message-ID: <20150604171501.GI3160@smitten>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
 <CAGXu5jLBm6ZBptsDTrNV6OrFSwoZ__k3867-Ji+6oYuTQ8ncWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLBm6ZBptsDTrNV6OrFSwoZ__k3867-Ji+6oYuTQ8ncWQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 04, 2015 at 09:44:36AM -0700, Kees Cook wrote:
> On Wed, Jun 3, 2015 at 3:09 PM, Tycho Andersen
> <tycho.andersen@canonical.com> wrote:
> > This patch is the first step in enabling checkpoint/restore of processes
> > with seccomp enabled.
> >
> > One of the things CRIU does while dumping tasks is inject code into them
> > via ptrace to collect information that is only available to the process
> > itself. However, if we are in a seccomp mode where these processes are
> > prohibited from making these syscalls, then what CRIU does kills the task.
> >
> > This patch adds a new ptrace option, PTRACE_O_SUSPEND_SECCOMP, that enables
> > a task from the init user namespace which has CAP_SYS_ADMIN and no seccomp
> > filters to disable (and re-enable) seccomp filters for another task so that
> > they can be successfully dumped (and restored). We restrict the set of
> > processes that can disable seccomp through ptrace because although today
> > ptrace can be used to bypass seccomp, there is some discussion of closing
> > this loophole in the future and we would like this patch to not depend on
> > that behavior and be future proofed for when it is removed.
> >
> > Note that seccomp can be suspended before any filters are actually
> > installed; this behavior is useful on criu restore, so that we can suspend
> > seccomp, restore the filters, unmap our restore code from the restored
> > process' address space, and then resume the task by detaching and have the
> > filters resumed as well.
> >
> > v2 changes:
> >
> > * require that the tracer have no seccomp filters installed
> > * drop TIF_NOTSC manipulation from the patch
> > * change from ptrace command to a ptrace option and use this ptrace option
> >   as the flag to check. This means that as soon as the tracer
> >   detaches/dies, seccomp is re-enabled and as a corrollary that one can not
> >   disable seccomp across PTRACE_ATTACHs.
> 
> This feature gives me the creeps, but I think it's okay.

:D

> Could it be
> further restricted so that the process doing the suspension is already
> ptracing the target?

As far as I understand it you do have to PTRACE_{ATTACH,SEIZE} to the
target before setting options in general. Is that not what you mean
here?

The rest of the changes sound good, I'll make those and resend.

>
> Thanks for working on this!

Thanks for the review.

Tycho
