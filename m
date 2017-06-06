From: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/26] signal: Do not perform permission checks when
 sending pdeath_signal
Date: Tue, 6 Jun 2017 23:42:08 +0200
Message-ID: <CAFLxGvzLNaXb6b45_2uqmmzTQmWcpVkipxz5DO-hNZAqCQy2jA@mail.gmail.com>
References: <877f0pym71.fsf@xmission.com> <20170606190338.28347-1-ebiederm@xmission.com>
 <20170606190338.28347-3-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-3-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Eric,

On Tue, Jun 6, 2017 at 9:03 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> This fixes and old old regression.  When Roland switched from
> sending pdeath_signal with send_sig() to send_group_sig_info
> it gained a permission check, and started taking the tasklist
> lock.  Roland earlier fixed the double taking of the tasklist
> lock in 3f2a0d1df938 ("[PATCH] fix pdeath_signal SMP locking")
> but pdeath_signal still performs an unnecessary permission
> check.
>
> Ordinarily I would be hesitant at fixing an ancient regression but
> a permission check for our parent sending to us is almost never
> likely to fail (so it is unlikely anyone has noticed), and it
> is stupid.  It makes absolutely no sense to see if our
> parent has permission to send us a signal we requested be
> sent to us.

Another side effect of this change is that audit_signal_info() is no longer
being called. AFAICT this is a user space visible change.

-- 
Thanks,
//richard
