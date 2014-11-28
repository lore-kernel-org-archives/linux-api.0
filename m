From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [CFT][PATCH] userns: Avoid problems with negative groups
Date: Fri, 28 Nov 2014 07:11:51 -0800
Message-ID: <CALCETrX2s-7iaLMEKLQsExTEp3JyoAPQG44p0v5wkeED3-6dQA@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <546A3942.5040906@schaufler-ca.com> <CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com>
 <CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
 <546A43CE.2030706@schaufler-ca.com> <87lhmwwpey.fsf_-_@x220.int.ebiederm.org>
 <CALCETrUuWDq2akKfb50AiPHeDDWzPW7ijz1QwnuNiskyZbBEfA@mail.gmail.com> <87wq6frjcw.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87wq6frjcw.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 27, 2014 at 9:21 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>
>>> This change should break userspace by the minimal amount needed
>>> to fix this issue.
>>>
>>> This should fix CVE-2014-8989.
>>
>> I think this is both unnecessarily restrictive and that it doesn't fix
>> the bug.
>
> You are going to have to work very hard to convince me this is
> unnecessarily restrictive.
>
>>For example, I can exploit CVE-2014-8989 without ever
>> writing a uid map or a gid map.
>
> Yes.  I realized just after I sent the patch that setgroups(0, NULL)
> would still work without a mapping set.  That is a first glass grade a
> oversight that resulted in a bug.  None of the other uid or gid changing
> syscalls without a mapping set, and setgroups was just overlooked
> because it was different.  Oops.
>
> I will send an updated patch that stops setgroups from working without
> a mapping set shortly.
>
>> IIUC, the only real issue is that user namespaces allow groups to be
>> dropped using setgroups that wouldn't otherwise be dropped.  Can we
>> get away with adding a per-user-ns flag that determines whether
>> setgroups can be used?
>
> Being able to call setgroups is fundamental to login programs, and login
> programs are one of the things user namespaces need to support.  So
> adding an extra flag and an extra place where privilege is required
> is just noise, and will wind up breaking every user of user namespaces.
>
> Further being able to setup uid and gid mappings without privilege is
> primarily a nice to have.  The original design did not have unprivileged
> setting of uid and gid maps and if it proves insecure I goofed and the
> feature isn't safe so it needs to be removed.

Being able to set a single-user uid map and gid map is very useful for
sandboxing.  This lets unprivileged users drop filesystem and network
access and still run most normal programs.  A surprising number of
normal unprivileged programs fail if run without a mapping.

>
> This does mean that running a system with negative groups and users
> delegated subordinate gids in /etc/subuid is a bad idea and system
> administrators shouldn't do that as those negative groups won't prove
> effective in stopping their users.  But this is all under system
> administrator control so shrug.  There isn't a way to avoid that
> fundamental conflict.
>
>> setgroups would be unusable until the gid_map has been written and
>> then it would become usable if and only if the parent userns could use
>> setgroups and the opener of gid_map was privileged.
>
> That proposal sounds a lot more restrictive and a lot more of a pain
> to use than what I have implemented in my patch.
>
>> If we wanted to allow finer-grained control, we could allow writing
>> control lines like:
>>
>> options +setgroups
>>
>> or
>>
>> options -setgroups
>>
>> in gid_map, or we could add user_ns_flags that can only be written
>> once and only before either uid_map or gid_map is written.
>
> Definitely more complicated and I can't imagine a case where I need
> a gid map without needing to call setgroups.

I do it all the time.  Unshare, set mappings (with no inner uid 0 at
all), set no_new_privs, drop caps, and go.

Can we try the intermediate approach?  If you set gid_map without
privilege and you have supplementary groups, then let the write to
gid_map succeed but prevent setgroups from ever working?  That should
only be a couple of lines of code longer than your patch, and it will
avoid breaking sandbox use cases.

If we want to get really fancy in the future, we could have a concept
of pinned groups.  That is, if you're in a userns and you're a member
of an unmapped group, then you can't drop that group.  (Actually, that
all by itself might be enough to fix this issue.)

--Andy

>
> Eric



-- 
Andy Lutomirski
AMA Capital Management, LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
