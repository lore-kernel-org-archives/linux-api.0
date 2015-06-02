From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Tue, 2 Jun 2015 23:27:22 +0200
Message-ID: <20150602212722.GA32356@redhat.com>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com> <20150602182829.GA23449@redhat.com> <556DFDB2.3050205@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <556DFDB2.3050205-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/02, Pavel Emelyanov wrote:
>
> > And I am not sure I understand why do we need the additional security
> > check, but I leave this to you and Andy.
> >
> > If you have the rights to trace this task, then you can do anything
> > the tracee could do without the filtering.
>
> I think _this_ check is required, otherwise the seccomp-ed task (in
> filtered mode) fork-s a child, then this child ptrace-attach to parent
> (allowed) then suspend its seccomd.

If you force (hack) that task to do this. And if the seccomp-ed task
does this by its own we do not care.

> And -- we have unpriviledged process
> de-seccomped.

Heh. The case when the priviledged CAP_SYS_ADMIN process escapes the
filtering is much worse I think ;)

But as I said I will nott argue, just I think this needs a bit of
documentantion. And I agree in advance with something like "better
be safe than sorry, we can always remove this later" comment or a
note in the changelog.

Oleg.
