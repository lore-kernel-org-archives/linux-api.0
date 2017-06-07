From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 03/26] signal: Do not perform permission checks when sending pdeath_signal
Date: Wed, 07 Jun 2017 06:23:12 -0500
Message-ID: <87fufcxcrj.fsf@xmission.com>
References: <877f0pym71.fsf@xmission.com>
        <20170606190338.28347-1-ebiederm@xmission.com>
        <20170606190338.28347-3-ebiederm@xmission.com>
        <CA+55aFya7CgNozFrhQ9qk40UhZAD8SMva1+Y1vQ0YUEbpUpQUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFya7CgNozFrhQ9qk40UhZAD8SMva1+Y1vQ0YUEbpUpQUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Linus Torvalds's message of "Tue, 6 Jun 2017 13:01:40 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:

> On Tue, Jun 6, 2017 at 12:03 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> As this is more permisssive there is no chance anything will break.
>
> Actually, I do worry about the security issues here.
>
> The thing is, the parent may be some system daemon that wants to catch
> SIGCHLD, but we've used prctl and changed pdeath_signal to something
> else (like SIGSEGV or something).
>
> Do we really want to be able to kill a system daemon that we couldn't
> use kill() on directly, just because that system daemon spawned us?
>
> So I think those permission checks may actually be a good idea.
> Although possibly they should be in prctl()..

To be clear.  pdeath signal is the signal we receive when our parent
dies.  It is the parent death signal.

AKA when the system daemon (or whatever is dies) what signal does the
child process that called the prctl get?

There is no chance of killing the system daemon that spawned us,
as the signal only gets sent to ourselves.

Eric
