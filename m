From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: Documenting ptrace access mode checking
Date: Tue, 21 Jun 2016 15:58:39 -0500
Message-ID: <878txyuum8.fsf@x220.int.ebiederm.org>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
	<87ziqewc3r.fsf@x220.int.ebiederm.org>
	<CAGXu5jLwuqS5w-Thpngc=hFhXOdM-Q5_G1v9np1sOnmq+v2c4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jLwuqS5w-Thpngc=hFhXOdM-Q5_G1v9np1sOnmq+v2c4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Kees Cook's message of "Tue, 21 Jun 2016 13:29:32 -0700")
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> writes:

> On Tue, Jun 21, 2016 at 12:55 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
>> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>
>>>        The  algorithm  employed for ptrace access mode checking det=
er=E2=80=90
>>>        mines whether the calling process is  allowed  to  perform  =
the
>>>        corresponding action on the target process, as follows:
>>>
>>>        1.  If the calling thread and the target thread are in the s=
ame
>>>            thread group, access is always allowed.
>>
>> This test only exsits because the LSMs historically and I suspect
>> continue to be broken and deny a process the ability to ptrace itsel=
f.
>
> Well, it's not that the LSMs are broken, it's that self-inspection is
> a short-circuited "allow". The LSMs aren't involved.

Long ago and far away.  I modified /proc/self/something to use the same
permissions as ptrace.  This broken everyone's selinux setups.  So the
short circuit was added.

Or in short the LSMs aren't involved because they got it wrong.

If the selinux breakage was not in the selinux rules that are loaded fr=
om
userspace but in the kernel module that short circuit check would have
been confined to selinux.

I have had an occasional thought and the occassional discussion about
removing that check and just fixing the LSMs but at this point I don't
think anyone cares enough to make that change.

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
