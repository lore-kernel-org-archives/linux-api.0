From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] seccomp: add ptrace options for suspend/resume
Date: Sat, 6 Jun 2015 01:48:00 +0200
Message-ID: <20150605234800.GA31991@redhat.com>
References: <1433539312-3999-1-git-send-email-tycho.andersen@canonical.com> <20150605215208.GA27105@redhat.com> <20150605220619.GI31599@hopstrocity>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150605220619.GI31599@hopstrocity>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/05, Tycho Andersen wrote:
>
> right thing to do, just leave out the definition of
> may_suspend_seccomp all together, or add in another if defined() in
> the header?

Just declare it unconditionally in .h. The kernel relies on this kind
of dead-code elimination anyway. For example, please look at
"extern void __put_user_bad(void)" in uaccess.h.

IOW,

	extern void undefined_func(void);

	if (0)
		undefined_func();

should be safe.

> Maybe we will get rid of this pesky function all together though...

Yes ;)

Oleg.
