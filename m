From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Wed, 3 Jun 2015 10:58:00 -0600
Message-ID: <20150603165800.GF3337@hopstrocity>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <CANaxB-zacYuo21jLVZyEfyf=UdDnTjYvHdgNpfL+c_DXWRz-eg@mail.gmail.com>
 <20150602130506.GA1823@hopstrocity>
 <20150602184848.GA24907@redhat.com>
 <20150603161321.GD3337@hopstrocity>
 <20150603165451.GA20911@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150603165451.GA20911-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 03, 2015 at 06:54:51PM +0200, Oleg Nesterov wrote:
> On 06/03, Tycho Andersen wrote:
> >
> > On Tue, Jun 02, 2015 at 08:48:48PM +0200, Oleg Nesterov wrote:
> >
> > > Otherwise, if we use PTRACE_O_ instead, it goes away automatically if
> > > the tracer dies or does PTRACE_DETACH.
> >
> > IIRC the flag goes away, but we still have to do something in
> > __ptrace_unlink to clear the seccomp suspended, so I'm not sure if the
> > automatic-ness helps us.
> 
> But we do not need seccomp->suspended at all?
>
> Unless I missed something PTRACE_O_ needs a one-liner patch (ignoring
> the defines in include files),
> 
> --- x/kernel/seccomp.c
> +++ x/kernel/seccomp.c
> @@ -692,6 +692,9 @@ u32 seccomp_phase1(struct seccomp_data *
>  	int this_syscall = sd ? sd->nr :
>  		syscall_get_nr(current, task_pt_regs(current));
>  
> +	if (unlikely(current->ptrace & PT_NAME_OF_THIS_OPTION))
> +		return OK;
> +
>  	switch (mode) {
>  	case SECCOMP_MODE_STRICT:
>  		__secure_computing_strict(this_syscall);  /* may call do_exit */
> 	
> 
> OK, and the same check in secure_computing_strict().
> 
> No?

I see, I misunderstood. Yes, this is a lot nicer, thank you.

Tycho
