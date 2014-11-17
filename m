From: "Eric W.Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups to drop groups
Date: Mon, 17 Nov 2014 17:41:33 -0500
Message-ID: <9f43a787-165e-4256-a097-f7691204d9d6@email.android.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org> <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org> <546A3942.5040906@schaufler-ca.com> <CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com> <CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On November 17, 2014 1:46:59 PM EST, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>On Mon, Nov 17, 2014 at 10:31 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>wrote:
>> On Mon, Nov 17, 2014 at 10:06 AM, Casey Schaufler
>> <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>>> On 11/15/2014 1:01 AM, Josh Triplett wrote:
>>>> Currently, unprivileged processes (without CAP_SETGID) cannot call
>>>> setgroups at all.  In particular, processes with a set of
>supplementary
>>>> groups cannot further drop permissions without obtaining elevated
>>>> permissions first.
>>>
>>> Has anyone put any thought into how this will interact with
>>> POSIX ACLs? I don't see that anywhere in the discussion.
>>
>> That means that user namespaces are a problem, too, and we need to
>fix
>> it.  Or we should add some control to turn unprivileged user
>namespace
>> creation on and off and document that turning it on defeats POSIX
>ACLs
>> with a group entry that is more restrictive than the other entry.
>>
>
>This is a significant enough issue that I posted it to oss-security:
>
>http://www.openwall.com/lists/oss-security/2014/11/17/19
>
>It's not at all obvious to me how to fix it.  We could disallow userns
>creation of any supplementary groups don't match fsuid, or we could
>keep negative-only groups around in the userns.
>
>It may be worth adding a sysctl to change the behavior, too.  IMO it's
>absurd to use groups to deny permissions that are otherwise available.

There is an obvious user namespace fix.  Don't allow dropping supplemental groups that are not mapped.

That will require a little bit of fancy footwork if you want to play with supplemental groups in your unprivileged user namespace.   I would like to get a grip on what hoops would be required before we add the additional restriction.  Possibly something as simple as calling sg.

I also want to look at what Tizen and any other concrete pieces of code I can find using this negative permission pattern are actually doing.   Bugs definitely exist, but I have this erie feeling that the bugs may be in instances of userspace using this negative group permission pattern.  I think we may have a hideous case of one setuid binary defeating a privilege check of another piece of code.

This issue looks like it is worth a full scale investigation.  Sigh.

Eric
