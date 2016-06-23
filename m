From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: Documenting ptrace access mode checking
Date: Thu, 23 Jun 2016 14:04:43 -0500
Message-ID: <87por7hgl0.fsf@x220.int.ebiederm.org>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
	<87ziqewc3r.fsf@x220.int.ebiederm.org>
	<4c6a338f-619b-9e99-9fd8-1cf6d86ecfed@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4c6a338f-619b-9e99-9fd8-1cf6d86ecfed-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Michael
	Kerrisk's message of "Wed, 22 Jun 2016 21:20:32 +0200")
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi Eric,
>
> On 06/21/2016 09:55 PM, Eric W. Biederman wrote:
>> Hmm.
>>
>> When I gave this level of detail about the user namespace permission
>> checks you gave me some flack, because it was not particularly
>> comprehensible to the end users.  I think you deserve the same feedback.
>>
>> How do we say this in a way that does not describes a useful way to
>> think about it.  I read this and I know a lot of what is going on and my
>> mind goes numb.
>>
>> How about something like this:
>>
>>    If the callers uid and gid are the same as a processes uids and gids
>>    and the processes is configured to allow core dumps (aka it was never
>>    setuid or setgid) then the caller is allowed to ptrace a process.
>>
>>    Otherwise the caller must have CAP_SYS_PTRACE.
>>
>>    Linux security modules impose additional restrictions.
>>
>>    For consistency access to various process attributes are guarded with
>>    the same security checks as the ptrace system call itself.  As they are
>>    all methods to get information about a process.
>>
>> We certainly need something that gives a high level view so people
>> reading the man page can know what to expect.   If you get down into the
>> weeds we run the danger of people beginning to think they can depend
>> upon bugs in the implementation.
>
> Thanks for the feedback, but I think more detail is required than you
> suggest. (And I added all of that detail somewhat reluctantly.)
> See my other replies for my rationale.

What I saw badly missing from your description is not the level of
detail but bring things into a form that ordinary mortals can
understand.

For an explanation to be clear I think we very much need the high level
overview first.  Then we can expand that description with the very
detailed view.

I very much think we need to describe things in such a way that people
understand the principles behind the permission checks, and not just
have the documentation echo the code, so that people can know what weird
things LSMs like yama are likely to do, and how these checks are likely
to evolve in the future.

Because one thing is clear to me.  The evolution of these details is
clearly not done, and will continue to change in the future.

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
