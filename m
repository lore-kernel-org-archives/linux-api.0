From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 1/1] simplified security.nscapability xattr
Date: Tue, 03 May 2016 00:54:40 -0500
Message-ID: <87bn4nhejj.fsf@x220.int.ebiederm.org>
References: <1461345993-17526-1-git-send-email-serge.hallyn@ubuntu.com>
	<1461345993-17526-2-git-send-email-serge.hallyn@ubuntu.com>
	<CAGXu5jKFNQs8oxq+yD6_Q8HcNyf+GouSHFzkxT9u9BkK=ZLQ7Q@mail.gmail.com>
	<20160426222627.GA19307@mail.hallyn.com>
	<CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
	<20160502035452.GA31837@mail.hallyn.com>
	<87h9egp2oq.fsf@x220.int.ebiederm.org>
	<CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
	<20160503051921.GA31551@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160503051921.GA31551-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
	message of "Tue, 3 May 2016 00:19:21 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> Quoting Andrew G. Morgan (morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
>> 
>> I guess I'm confused how we have strayed so far that this isn't an obvious
>> requirement. Uid=0 as being the root of privilege was the basic problem
>> that capabilities were designed to change.
>
> The task executing the file can be any uid mapped into the namespace.  The
> file only has to be owned by the root of the user_ns.  Which I agree is
> unfortunate.  We can work around it by putting the root uid into the xattr
> itself (which still isn't orthogonal but allows the file to at least by
> owned by non-root), but the problem then is that a task needs to know its
> global root k_uid just to write the xattr.

The root kuid is just make_kuids(user_ns, 0) so it is easy to find.

It might be a hair better to use the userns->owner instead of the root
uid.  That would allow user namespaces without a mapped root to still
use file capabilities.

>> Uid is an acl concept. Capabilities are supposed to be independent of that.
>> 
>> If we want to support NS file capabilities I would look at replacing the
>> xattr syscall with a dedicated file capabilities modification syscall. Then
>
> That was one ofthe possibilities I'd mentioned in my earlier proposal,
> fwiw.  The problem is if we want tar to still work unmodified then
> simple xattr operations still have to work.
>
> Maybe there's workable semantics there though.  Worth thinking about.

If the problem is compatibilty please look at
posix_acl_fix_xattr_from_user.  With something similar for the
security.capability attribute we can perform whatever transformation
makes sense.  I admit adding 4 bytes is a bit of a pain in that context
but not a big one.

Eric
