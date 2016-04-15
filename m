From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Fri, 15 Apr 2016 08:50:31 -0700
Message-ID: <CAGr1F2EZtts38SPDc9cuH1prc6NfUJiwUQmqyRp-RpNYM5UzxA@mail.gmail.com>
References: <20160321234133.GA22463@mail.hallyn.com> <20160413175736.GC3676@htj.duckdns.org>
 <20160414040436.GA3739@mail.hallyn.com> <87oa9c6ymf.fsf@x220.int.ebiederm.org>
 <20160414152747.GA12700@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160414152747.GA12700@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.osdl.org>, cgroups mailinglist <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 14, 2016 at 8:27 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>>
>> > This is so that userspace can distinguish a mount made in a cgroup
>> > namespace from a bind mount from a cgroup subdirectory.
>>
>> To do that do you need to print the path, or is an extra option that
>> reveals nothing except that it was a cgroup mount sufficient?
>>
>> Is there any practical difference between a mount in a namespace and a
>> bind mount?
>>
>> Given the way the conversation has been going I think it would be good
>> to see the answers to these questions.  Perhaps I missed it but I
>> haven't seen the answers to those questions.
>
> Yup, I tried to answer those in my last email, let me try again.
>
> Let's say I start a container using cgroup namespaces, /lxc/x1.  It mounts
> freezer at /sys/fs/cgroup so it has field three of mountinfo as /lxc/x1,
> and /sys/fs/cgroup/ is the path to the container's cgroup (/lxc/x1).  In
> that container, I start another container x1, not using cgroup namespaces.
> It also wants a cgroup mount, and a common way to handle that (to prevent
> container rewriting its limits) is to mount a tmpfs at /sys/fs/cgroup,
> create /sysfs/cgroup/lxc/x1, and bind mount /sys/fs/cgroup/lxc/x1 from
> the parent container onto /sys/fs/cgroup/lxc/x1 in the child container.
> Now for that bind mount, the mountinfo field 3 will show /lxc/x1/lxc/x1,
> with mount target /sys/fs/cgroup/lxc/x1, while /proc/self/cgroup for a task
> in that container will show '/lxc/x1'.  Unless it has been moved into
> /lxc/x1/lxc/x1 in the container (/lxc/x1/lxc/x1/lxc/x1 on the host)...
> Every time I've thought "maybe we can just..." I've found a case where it
> wouldn't work.
>
> At first in lxc we simply said if /proc/self/ns/cgroup exists assume that
> the cgroupfs mounts are not bind mounts.  However, old userspace (and
> container drivers) on new kernels is certainly possible, especially an
> older distro in a container on a newer distro on the host.  That completely
> breaks with this approach.
>

My main concern regarding making this a new kernel API is that its too
generic and exposes information about all system cgroups to every
process on the system, not just the container or the process inside it
that needs it. Not all containers need this information and not all
processes running inside the container needs this. I haven't spent too
much thought into it, but it seems you will still need to update the
container userspace to read this extra mount option. So seems like a
simpler approach where the host "cgroup manager" provides this
information to specific container cgroup manager via other user-space
channels (a config file, command-line args, environment vars, proper
container mounts, etc.) may also work, right?

> I also personally think there *is* value in letting a task know its
> place on the system, so hiding the full cgroup path is imo not only not
> a valid goal, it's counter-productive.  Part of making for better
> virtualization is to give userspace all the info it needs about its
> current limits.  Consider that with the unified hierarchy, you cannot
> have tasks in a cgroup that also has child cgroups - except for the
> root.  Cgroup namespaces do not make an exception for this, so knowing
> that you are not in the absolute cgroup root actually can prevent you
> from trying something that cannot work.  Or, I suppose, at least
> understanding why you're unable to do what you're trying to do (namely
> your container manager messed up).  I point this out because finding
> a way to only show the namespaced root in field 3 of mountinfo would
> fix the base problem, but at the cost of hiding useful information
> from a container.
>
>> Eric
>>
>>
>> >
>> > Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
>> > ---
>> > Changelog: 2016-04-13: pass kernfs_node rather than dentry to show_options
>> > ---
>> >  fs/kernfs/mount.c      |  2 +-
>> >  include/linux/kernfs.h |  3 ++-
>> >  kernel/cgroup.c        | 28 +++++++++++++++++++++++++++-
>> >  3 files changed, 30 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
>> > index f73541f..58e8a86 100644
>> > --- a/fs/kernfs/mount.c
>> > +++ b/fs/kernfs/mount.c
>> > @@ -36,7 +36,7 @@ static int kernfs_sop_show_options(struct seq_file *sf, struct dentry *dentry)
>> >     struct kernfs_syscall_ops *scops = root->syscall_ops;
>> >
>> >     if (scops && scops->show_options)
>> > -           return scops->show_options(sf, root);
>> > +           return scops->show_options(sf, dentry->d_fsdata, root);
>> >     return 0;
>> >  }
>> >
>> > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
>> > index c06c442..72b4081 100644
>> > --- a/include/linux/kernfs.h
>> > +++ b/include/linux/kernfs.h
>> > @@ -145,7 +145,8 @@ struct kernfs_node {
>> >   */
>> >  struct kernfs_syscall_ops {
>> >     int (*remount_fs)(struct kernfs_root *root, int *flags, char *data);
>> > -   int (*show_options)(struct seq_file *sf, struct kernfs_root *root);
>> > +   int (*show_options)(struct seq_file *sf, struct kernfs_node *kn,
>> > +                       struct kernfs_root *root);
>> >
>> >     int (*mkdir)(struct kernfs_node *parent, const char *name,
>> >                  umode_t mode);
>> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> > index 671dc05..4d26d07 100644
>> > --- a/kernel/cgroup.c
>> > +++ b/kernel/cgroup.c
>> > @@ -1593,7 +1593,31 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
>> >     return 0;
>> >  }
>> >
>> > -static int cgroup_show_options(struct seq_file *seq,
>> > +static void cgroup_show_nsroot(struct seq_file *seq, struct kernfs_node *knode,
>> > +                          struct kernfs_root *kroot)
>> > +{
>> > +   char *nsroot;
>> > +   int len, ret;
>> > +
>> > +   if (!kroot)
>> > +           return;
>> > +   len = kernfs_path_from_node(knode, kroot->kn, NULL, 0);
>> > +   if (len <= 0)
>> > +           return;
>> > +   nsroot = kzalloc(len + 1, GFP_ATOMIC);
>> > +   if (!nsroot)
>> > +           return;
>> > +   ret = kernfs_path_from_node(knode, kroot->kn, nsroot, len + 1);
>> > +   if (ret <= 0 || ret > len)
>> > +           goto out;
>> > +
>> > +   seq_show_option(seq, "nsroot", nsroot);
>> > +
>> > +out:
>> > +   kfree(nsroot);
>> > +}
>> > +
>> > +static int cgroup_show_options(struct seq_file *seq, struct kernfs_node *kn,
>> >                            struct kernfs_root *kf_root)
>> >  {
>> >     struct cgroup_root *root = cgroup_root_from_kf(kf_root);
>> > @@ -1619,6 +1643,8 @@ static int cgroup_show_options(struct seq_file *seq,
>> >             seq_puts(seq, ",clone_children");
>> >     if (strlen(root->name))
>> >             seq_show_option(seq, "name", root->name);
>> > +   cgroup_show_nsroot(seq, kn, kf_root);
>> > +
>> >     return 0;
>> >  }



-- 
Aditya
