From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Sun, 19 Oct 2014 11:26:29 -0700
Message-ID: <CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-8-git-send-email-adityakali@google.com> <20141016211236.GA4308@mail.hallyn.com>
 <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
 <20141016214710.GA4759@mail.hallyn.com> <87iojgmy3o.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87iojgmy3o.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 18, 2014 at 10:23 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
>
>> Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
>>> On Thu, Oct 16, 2014 at 2:12 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>>> > Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
>>> >> setns on a cgroup namespace is allowed only if
>>> >> * task has CAP_SYS_ADMIN in its current user-namespace and
>>> >>   over the user-namespace associated with target cgroupns.
>>> >> * task's current cgroup is descendent of the target cgroupns-root
>>> >>   cgroup.
>>> >
>>> > What is the point of this?
>>> >
>>> > If I'm a user logged into
>>> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope and I start
>>> > a container which is in
>>> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope/x1
>>> > then I will want to be able to enter the container's cgroup.
>>> > The container's cgroup root is under my own (satisfying the
>>> > below condition0 but my cgroup is not a descendent of the
>>> > container's cgroup.
>>> >
>>> This condition is there because we don't want to do implicit cgroup
>>> changes when a process attaches to another cgroupns. cgroupns tries to
>>> preserve the invariant that at any point, your current cgroup is
>>> always under the cgroupns-root of your cgroup namespace. But in your
>>> example, if we allow a process in "session-c12.scope" container to
>>> attach to cgroupns root'ed at "session-c12.scope/x1" container
>>> (without implicitly moving its cgroup), then this invariant won't
>>> hold.
>>
>> Oh, I see.  Guess that should be workable.  Thanks.
>
> Which has me looking at what the rules are for moving through
> the cgroup hierarchy.
>
> As long as we have write access to cgroup.procs and are allowed
> to open the file for write, we can move any of our own tasks
> into the cgroup.  So the cgroup namespace rules don't seem
> to be a problem.
>
> Andy can you please take a look at the permission checks in
> __cgroup_procs_write.

The actual requirements for calling that function haven't changed,
right?  IOW, what does this have to do with cgroupns?  Is the idea
that you want a privileged user wrt a cgroupns's userns to be able to
use this?  If so:

Yes, that current_cred() thing is bogus.  (Actually, this is probably
exploitable right now if any cgroup.procs inode anywhere on the system
lets non-root write.)  (Can we have some kernel debugging option that
makes any use of current_cred() in write(2) warn?)

We really need a weaker version of may_ptrace for this kind of stuff.
Maybe the existing may_ptrace stuff is okay, actually.  But this is
completely missing group checks, cap checks, capabilities wrt the
userns, etc.

Also, I think that, if this version of the patchset allows non-init
userns to unshare cgroupns, then the issue of what permission is
needed to lock the cgroup hierarchy like that needs to be addressed,
because unshare(CLONE_NEWUSER|CLONE_NEWCGROUP) will effectively pin
the calling task with no permission required.  Bolting on a fix later
will be a mess.

--Andy

>
> As I read the code I see 3 security gaffaws in the permssion check.
> - Using current->cred instead of file->f_cred.
> - Not checking tcred->euid.
> - Checking GLOBAL_ROOT_UID instead of having a capable call.
>
> The file permission on cgroup.procs seem just sufficient to keep
> to keep those bugs from being easily exploitable.
>
> Eric



-- 
Andy Lutomirski
AMA Capital Management, LLC
