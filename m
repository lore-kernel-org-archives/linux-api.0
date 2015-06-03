From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Wed, 3 Jun 2015 10:13:21 -0600
Message-ID: <20150603161321.GD3337@hopstrocity>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <CANaxB-zacYuo21jLVZyEfyf=UdDnTjYvHdgNpfL+c_DXWRz-eg@mail.gmail.com>
 <20150602130506.GA1823@hopstrocity>
 <20150602184848.GA24907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150602184848.GA24907-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 02, 2015 at 08:48:48PM +0200, Oleg Nesterov wrote:
> On 06/02, Tycho Andersen wrote:
> >
> > > Do we need to re-enable seccomp if a tracer detaches unexpectedly.
> > > CRIU can be killed and we should try to not affect the task state even
> > > in this case.
> >
> > Yes, I think Pavel's suggestion on the CRIU list of simply
> > automatically re-enabling seccomp on ptrace detach
> 
> But note that you can't enable tsc if the tracer dies, in this case
> the tracee can be running.

Yes, this does complicate things. I think I'll get rid of the TSC
manipulation, since it's not clear to me how to resolve this. (I do
think it makes the API slightly incomplete, though, so suggestions how
to resolve it would be welcome.)

> Otherwise, if we use PTRACE_O_ instead, it goes away automatically if
> the tracer dies or does PTRACE_DETACH.

IIRC the flag goes away, but we still have to do something in
__ptrace_unlink to clear the seccomp suspended, so I'm not sure if the
automatic-ness helps us.

Tycho
