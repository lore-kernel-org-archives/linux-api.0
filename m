From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5] seccomp: add ptrace options for suspend/resume
Date: Mon, 15 Jun 2015 12:41:58 +0300
Message-ID: <557E9DE6.2040806@parallels.com>
References: <1434207768-16729-1-git-send-email-tycho.andersen@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434207768-16729-1-git-send-email-tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/13/2015 06:02 PM, Tycho Andersen wrote:
> This patch is the first step in enabling checkpoint/restore of processes
> with seccomp enabled.
> 
> One of the things CRIU does while dumping tasks is inject code into them
> via ptrace to collect information that is only available to the process
> itself. However, if we are in a seccomp mode where these processes are
> prohibited from making these syscalls, then what CRIU does kills the task.
> 
> This patch adds a new ptrace option, PTRACE_O_SUSPEND_SECCOMP, that enables
> a task from the init user namespace which has CAP_SYS_ADMIN and no seccomp
> filters to disable (and re-enable) seccomp filters for another task so that
> they can be successfully dumped (and restored). We restrict the set of
> processes that can disable seccomp through ptrace because although today
> ptrace can be used to bypass seccomp, there is some discussion of closing
> this loophole in the future and we would like this patch to not depend on
> that behavior and be future proofed for when it is removed.
> 
> Note that seccomp can be suspended before any filters are actually
> installed; this behavior is useful on criu restore, so that we can suspend
> seccomp, restore the filters, unmap our restore code from the restored
> process' address space, and then resume the task by detaching and have the
> filters resumed as well.
> 
> v2 changes:
> 
> * require that the tracer have no seccomp filters installed
> * drop TIF_NOTSC manipulation from the patch
> * change from ptrace command to a ptrace option and use this ptrace option
>   as the flag to check. This means that as soon as the tracer
>   detaches/dies, seccomp is re-enabled and as a corrollary that one can not
>   disable seccomp across PTRACE_ATTACHs.
> 
> v3 changes:
> 
> * get rid of various #ifdefs everywhere
> * report more sensible errors when PTRACE_O_SUSPEND_SECCOMP is incorrectly
>   used
> 
> v4 changes:
> 
> * get rid of may_suspend_seccomp() in favor of a capable() check in ptrace
>   directly
> 
> v5 changes:
> 
> * check that seccomp is not enabled (or suspended) on the tracer
> 
> Signed-off-by: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> CC: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> CC: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> CC: Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>
> CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Acked-by: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
