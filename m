From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 00/26] Fixing wait, exit, ptrace, exec, and CLONE_THREAD
Date: Wed, 07 Jun 2017 06:36:48 -0500
Message-ID: <87ink8vxkf.fsf@xmission.com>
References: <877f0pym71.fsf@xmission.com>
        <dd16b1bb-e99e-69f2-72f4-1be4cb24d18d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dd16b1bb-e99e-69f2-72f4-1be4cb24d18d-l3A5Bk7waGM@public.gmane.org> (Aleksa Sarai's
        message of "Wed, 7 Jun 2017 05:40:21 +1000")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org> writes:

>> Another easy entry point is to see that a multi-threaded setuid won't
>> change the credentials on a zombie thread group leader.  Which can allow
>> sending signals to a process that the credential change should forbid.
>> This is in violation of posix and the semantics we attempt to enforce in
>> linux.
>
> I might be completely wrong on this point (and I haven't looked at the patches),
> but I was under the impression that multi-threaded set[ug]id was implemented in
> userspace (by glibc's nptl(7) library that uses RT signals internally to get
> each thread to update their credentials). And given that, I wouldn't be
> surprised (as a user) that zombie threads will have stale credentials (glibc
> isn't running in those threads anymore).
>
> Am I mistaken in that belief?

Would you be surprised if you learned that if your first thread
exits, it will become a zombie and persist for the lifetime of your
process?

Furthermore all non-thread specific signals will permission check
against that first zombie thread.

Which I think makes this surprising even if you know that setuid is
implemented in userspace.

Eric
