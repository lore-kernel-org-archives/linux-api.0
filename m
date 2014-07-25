From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/5] RFC: CGroup Namespaces
Date: Fri, 25 Jul 2014 13:27:50 -0700
Message-ID: <CALCETrW7im0CHp9z_n4ZaaiNVqz6hcXdXqFpT9iO3P4c92aJyg@mail.gmail.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <20140724163628.GN26600@ubuntumail> <CAGr1F2GcAema-E2q6PFj=R0Z505iD7JshrMuMdfPTJ95wMiQMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGr1F2GcAema-E2q6PFj=R0Z505iD7JshrMuMdfPTJ95wMiQMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 12:29 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Thank you for your review. I have tried to respond to both your emails here.
>
> On Thu, Jul 24, 2014 at 9:36 AM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
>> 2. What would be the reprecussions of allowing cgroupns unshare so
>>    long as you have ns_capable(CAP_SYS_ADMIN) to the user_ns which
>>    created your current ns cgroup?  It'd be a shame if that wasn't
>>    on the roadmap.
>>
>
> Its certainly on the roadmap, just that some logistics were not clear
> at this time. As pointed out by Andy Lutomirski on [PATCH 5/5] of this
> series, if we allow cgroupns creation to ns_capable(CAP_SYS_ADMIN)
> processes, we may need some kind of explicit permission from the
> cgroup subsystem to allow this. One approach could be an explicit
> cgroup.may_unshare setting. Alternatively, the cgroup directory (which
> is going to become the cgroupns-root) ownership could also be used
> here. i.e., the process is ns_capable(CAP_SYS_ADMIN) && it owns the
> cgroup directory. There seems to be already a function that allows
> similar thing and might be sufficient:
>
> /**
>  * capable_wrt_inode_uidgid - Check nsown_capable and uid and gid mapped
>  * @inode: The inode in question
>  * @cap: The capability in question
>  *
>  * Return true if the current task has the given capability targeted at
>  * its own user namespace and that the given inode's uid and gid are
>  * mapped into the current user namespace.
>  */
> bool capable_wrt_inode_uidgid(const struct inode *inode, int cap)
>
> What do you think? We can enable this for non-init userns once this is
> decided on.
>

I think I'd rather it just check that it's owned by the userns owner
if we were going down that route.  But maybe there's a good reason to
do it this way.

>
>> 3. The un-namespaced view of /proc/self/cgroup from a sibling cgroupns
>>    makes me wonder whether it wouldn't be more appropriate to leave
>>    /proc/self/cgroup always un-filtered, and use /proc/self/nscgroup
>>    (or somesuch) to provide the namespaced view.  /proc/self/nscgroup
>>    would simply be empty (or say (invalid) or (unreachable)) from a
>>    sibling ns.  That will give criu and admin tools like lxc/docker all
>>    they need to do simple cgroup setup.
>>
>
> It may work for lxc/docker and new applications that use the new
> interface. But its difficult to change numerous existing user
> applications and libraries that depend on /proc/self/cgroup. Moreover,
> even with the new interface, /proc/self/cgroup will continue to leak
> system level cgroup information. And fixing this leak is critical to
> make the container migratable.
>
> Its easy to correctly handle the read of /proc/<pid>/cgroup from a
> sibling cgroupns. Instead of showing unfiltered view, we could just
> not show anything (same behavior when the cgroup hierarchy is not
> mounted). Will that be more acceptable? I can make that change in the
> next version of this series.
>
>


>>>   (5) setns() is not supported for cgroup namespace in the initial
>>>       version.
>>
>> This combined with the full-path reporting for peer ns cgroups could make
>> for fun antics when attaching to an existing container (since we'd have
>> to unshare into a new ns cgroup with the same roto as the container).
>> I understand you are implying this will be fixed soon though.
>>
>
> I am thinking the setns() will be only allowed if
> target_cgrpns->cgroupns_root is_descendant_of
> current_cgrpns->cgroupns_root. i.e., you will only be setns to a
> cgroup namespace which is rooted deeper in hierarchy than your own (in
> addition to checking capable_wrt_inode_uidgid(target_cgrpns_inode)).

I'm not sure why the capable_wrt_inode_uidgid is needed here -- I
imagine that the hierarchy check and the usual CAP_SYS_ADMIN check on
the cgroupns's userns would be sufficient.

>
> In addition to this, we need to decide whether its OK for setns() to
> also change the cgroup of the task. Consider following example:
>
> [A] ----> [B] ----> C
>     ----> D
>
> [A] and [B] are cgroupns-roots. Now, if a task in Cgroup D (which is
> under cgroupns [A]) attempts to setns() to cgroupns [B], then its
> cgroup should change from /A/D to /A/B. I am concerned about the
> side-effects this might cause. Though otherwise, this is a very useful
> feature for containers. One could argue that this is similar to
> setns() to a mount-namespace which is pivot_root'd somewhere else (in
> which case, the attaching task's root "/" moves implicitly with
> setns).

Off the top of my head, I think that making setns do this would be too
magical.  How about just requiring that you already be in (a
descendent of) the requested cgroupns's root cgroup if you try to
setns?

>
> Alternatively, we could only allow setns() if
> target_cgrpns->cgroupns_root == current->cgroup . I.e., taking above
> example again, if process in Cgroup D wants to setns() to cgroupns
> [B], then it will first need to move to Cgroup B, and only then the
> setns() will succeed. This makes sure that there is no implicit cgroup
> move.

I like this one, but I think that descendant cgroups should probably
be allowed, too.

--Andy
