From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Tue, 2 Jun 2015 07:05:06 -0600
Message-ID: <20150602130506.GA1823@hopstrocity>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <CANaxB-zacYuo21jLVZyEfyf=UdDnTjYvHdgNpfL+c_DXWRz-eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANaxB-zacYuo21jLVZyEfyf=UdDnTjYvHdgNpfL+c_DXWRz-eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 02, 2015 at 12:36:16PM +0300, Andrey Wagin wrote:
> 2015-06-01 22:28 GMT+03:00 Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>:
> > This patch is the first step in enabling checkpoint/restore of processes
> > with seccomp enabled.
> >
> > One of the things CRIU does while dumping tasks is inject code into them
> > via ptrace to collect information that is only available to the process
> > itself. However, if we are in a seccomp mode where these processes are
> > prohibited from making these syscalls, then what CRIU does kills the task.
> >
> > This patch adds a new ptrace command, PTRACE_SUSPEND_SECCOMP that enables a
> > task from the init user namespace which has CAP_SYS_ADMIN to disable (and
> > re-enable) seccomp filters for another task so that they can be
> > successfully dumped (and restored).
> 
> Do we need to re-enable seccomp if a tracer detaches unexpectedly.
> CRIU can be killed and we should try to not affect the task state even
> in this case.

Yes, I think Pavel's suggestion on the CRIU list of simply
automatically re-enabling seccomp on ptrace detach is the right way to
go here; it should cover this case. The only question is whether or
not to leave the explicit ability to re-enable seccomp before detach
or not. I don't think it's necessary for CRIU, so perhaps I'll remove
it in the next version.

Tycho
