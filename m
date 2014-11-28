From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [CFT][PATCH] userns: Avoid problems with negative groups
Date: Fri, 28 Nov 2014 09:11:56 -0800
Message-ID: <CALCETrWsr9zV+9T9ba7Wy3q5q2SOpDyhSf4VUJ+C9rVf6R4Yfw@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
	<0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
	<546A3942.5040906@schaufler-ca.com>
	<CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com>
	<CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
	<546A43CE.2030706@schaufler-ca.com>
	<87lhmwwpey.fsf_-_@x220.int.ebiederm.org>
	<CALCETrUuWDq2akKfb50AiPHeDDWzPW7ijz1QwnuNiskyZbBEfA@mail.gmail.com>
	<87wq6frjcw.fsf@x220.int.ebiederm.org>
	<CALCETrX2s-7iaLMEKLQsExTEp3JyoAPQG44p0v5wkeED3-6dQA@mail.gmail.com>
	<874mtjp9m1.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <874mtjp9m1.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

cc: Serge and Stephane, since this may end up affecting LXC.

On Fri, Nov 28, 2014 at 8:34 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>
>> On Thu, Nov 27, 2014 at 9:21 PM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>>
>>>>> This change should break userspace by the minimal amount needed
>>>>> to fix this issue.
>>>>>
>>>>> This should fix CVE-2014-8989.
>>>>
>>>> I think this is both unnecessarily restrictive and that it doesn't fix
>>>> the bug.
>>>
>>> You are going to have to work very hard to convince me this is
>>> unnecessarily restrictive.
>>>
>>>>For example, I can exploit CVE-2014-8989 without ever
>>>> writing a uid map or a gid map.
>>>
>>> Yes.  I realized just after I sent the patch that setgroups(0, NULL)
>>> would still work without a mapping set.  That is a first glass grade a
>>> oversight that resulted in a bug.  None of the other uid or gid changing
>>> syscalls without a mapping set, and setgroups was just overlooked
>>> because it was different.  Oops.
>>>
>>> I will send an updated patch that stops setgroups from working without
>>> a mapping set shortly.
>>>
>>>> IIUC, the only real issue is that user namespaces allow groups to be
>>>> dropped using setgroups that wouldn't otherwise be dropped.  Can we
>>>> get away with adding a per-user-ns flag that determines whether
>>>> setgroups can be used?
>>>
>>> Being able to call setgroups is fundamental to login programs, and login
>>> programs are one of the things user namespaces need to support.  So
>>> adding an extra flag and an extra place where privilege is required
>>> is just noise, and will wind up breaking every user of user namespaces.
>>>
>>> Further being able to setup uid and gid mappings without privilege is
>>> primarily a nice to have.  The original design did not have unprivileged
>>> setting of uid and gid maps and if it proves insecure I goofed and the
>>> feature isn't safe so it needs to be removed.
>>
>> Being able to set a single-user uid map and gid map is very useful for
>> sandboxing.  This lets unprivileged users drop filesystem and network
>> access and still run most normal programs.  A surprising number of
>> normal unprivileged programs fail if run without a mapping.
>
> You can still set a single uid map unprivileged.  That should be enough
> to keep your capabilities inside the namespace as long as you need them.
>
> I am sad that in practice you can't set a single gid map, as everyone
> calls setgroups.
>

That's not the problem.  The problem is that a surprising number of
libraries expect getegid(), etc to return sensible values.

> Although I sort of think it might be worth scouring userspace for
> something that will call setgroups and drop all of your groups.  If we
> can find something preexisting that will solve this entire mess in a
> much more elegant way.
>
>>> This does mean that running a system with negative groups and users
>>> delegated subordinate gids in /etc/subuid is a bad idea and system
>>> administrators shouldn't do that as those negative groups won't prove
>>> effective in stopping their users.  But this is all under system
>>> administrator control so shrug.  There isn't a way to avoid that
>>> fundamental conflict.
>>>
>>>> setgroups would be unusable until the gid_map has been written and
>>>> then it would become usable if and only if the parent userns could use
>>>> setgroups and the opener of gid_map was privileged.
>>>
>>> That proposal sounds a lot more restrictive and a lot more of a pain
>>> to use than what I have implemented in my patch.
>>>
>>>> If we wanted to allow finer-grained control, we could allow writing
>>>> control lines like:
>>>>
>>>> options +setgroups
>>>>
>>>> or
>>>>
>>>> options -setgroups
>>>>
>>>> in gid_map, or we could add user_ns_flags that can only be written
>>>> once and only before either uid_map or gid_map is written.
>>>
>>> Definitely more complicated and I can't imagine a case where I need
>>> a gid map without needing to call setgroups.
>>
>> I do it all the time.  Unshare, set mappings (with no inner uid 0 at
>> all), set no_new_privs, drop caps, and go.
>>
>> Can we try the intermediate approach?  If you set gid_map without
>> privilege and you have supplementary groups, then let the write to
>> gid_map succeed but prevent setgroups from ever working?  That should
>> only be a couple of lines of code longer than your patch, and it will
>> avoid breaking sandbox use cases.
>
> I am torn.  Send me an incremental patch and I will be happy to evaluate
> it and if all is good fold the change in.  I hate breaking userspace but
> if I break it I would rather it be a clean break that is easy to spot
> and work around rather than something that almost works, and causes
> people a lot of difficulty debugging.

I'll play with it this afternoon or over the weekend.  I'm currently
on vacation, so I'll be a little slow.

>
> My expectation is that systems that are serious will have /etc/subuid
> and /etc/subgid and newuidmap and newgidmap setup.  Which is the other
> way to allow you to map your own gid.
>
>> If we want to get really fancy in the future, we could have a concept
>> of pinned groups.  That is, if you're in a userns and you're a member
>> of an unmapped group, then you can't drop that group.  (Actually, that
>> all by itself might be enough to fix this issue.)
>
> Not allowing you to drop groups really isn't enough.  One of the first
> things applications like ssh do is call setgroups(0, NULL) to drop the
> privileges granted by supplementary groups.  Further login program
> somewhere call setgroups(N, ....) and give you every group mapped
> by /etc/group.
>
> I don't think I want to run containers with every supplementary group I
> might want to drop mapped, and more than that, it would require changing
> a lot more userspace than just the userspace that just does unpriv
> containers with a single uid, and a single gid mapped.
>
> But please test and see if you really need to map your group, and send
> me an incremental patch if you see a way to do better.  Breaking
> userspace sucks.

I *know* I need the uid mapped, and I'm pretty sure I need the gid as
well.  FWIW, the code I care about won't object too strongly to a
one-time break, but it will object to needing to use subuids, since it
will have all kinds of problems if it starts to need to rely on setuid
helpers.

There's a third option: use your patch but require explicit userspace
opt-in for code that wants the setgroups-not-allowed mode.  I'll try
implementing that.

--Andy
