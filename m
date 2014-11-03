From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Mon, 3 Nov 2014 15:12:28 -0800
Message-ID: <CAGr1F2FuPQxLraYv7PstJ9c8H-XQsgawaAtj4AS77B+_0k2o+A@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-8-git-send-email-adityakali@google.com>
	<CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 31, 2014 at 5:07 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Fri, Oct 31, 2014 at 12:19 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> This patch enables cgroup mounting inside userns when a process
>> as appropriate privileges. The cgroup filesystem mounted is
>> rooted at the cgroupns-root. Thus, in a container-setup, only
>> the hierarchy under the cgroupns-root is exposed inside the container.
>> This allows container management tools to run inside the containers
>> without depending on any global state.
>> In order to support this, a new kernfs api is added to lookup the
>> dentry for the cgroupns-root.
>>
>> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/kernfs/mount.c      | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/kernfs.h |  2 ++
>>  kernel/cgroup.c        | 47 +++++++++++++++++++++++++++++++++++++++++++++--
>>  3 files changed, 95 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
>> index f973ae9..e334f45 100644
>> --- a/fs/kernfs/mount.c
>> +++ b/fs/kernfs/mount.c
>> @@ -62,6 +62,54 @@ struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
>>         return NULL;
>>  }
>>
>> +/**
>> + * kernfs_make_root - create new root dentry for the given kernfs_node.
>> + * @sb: the kernfs super_block
>> + * @kn: kernfs_node for which a dentry is needed
>> + *
>> + * This can used used by callers which want to mount only a part of the kernfs
>> + * as root of the filesystem.
>> + */
>> +struct dentry *kernfs_obtain_root(struct super_block *sb,
>> +                                 struct kernfs_node *kn)
>> +{
>
> I can't usefully review this, but kernfs_make_root and
> kernfs_obtain_root aren't the same string...
>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 7e5d597..250aaec 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1302,6 +1302,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>>
>>         memset(opts, 0, sizeof(*opts));
>>
>> +       /* Implicitly add CGRP_ROOT_SANE_BEHAVIOR if inside a non-init cgroup
>> +        * namespace.
>> +        */
>> +       if (current->nsproxy->cgroup_ns != &init_cgroup_ns) {
>> +               opts->flags |= CGRP_ROOT_SANE_BEHAVIOR;
>> +       }
>> +
>
> I don't like this implicit stuff.  Can you just return -EINVAL if sane
> behavior isn't requested?
>

I think the sane-behavior flag is only temporary and will be removed
anyways, right? So I didn't bother asking user to supply it. But I can
make the change as you suggested. We just have to make sure that tasks
inside cgroupns cannot mount non-default hierarchies as it would be a
regression.

>>         while ((token = strsep(&o, ",")) != NULL) {
>>                 nr_opts++;
>>
>> @@ -1391,7 +1398,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>>
>>         if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
>>                 pr_warn("sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
>> -               if (nr_opts != 1) {
>> +               if (nr_opts > 1) {
>>                         pr_err("sane_behavior: no other mount options allowed\n");
>>                         return -EINVAL;
>
> This looks wrong.  But, if you make the change above, then it'll be right.
>

It would have been nice if simple 'mount -t cgroup cgroup <mnt>' from
cgroupns does the right thing automatically.


>> @@ -1685,6 +1701,14 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>>         int ret;
>>         int i;
>>         bool new_sb;
>> +       struct cgroup_namespace *ns =
>> +               get_cgroup_ns(current->nsproxy->cgroup_ns);
>> +
>> +       /* Check if the caller has permission to mount. */
>> +       if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
>> +               put_cgroup_ns(ns);
>> +               return ERR_PTR(-EPERM);
>> +       }
>
> Why is this necessary?
>

Without this, if I unshare userns and mntns (but no cgroupns), I will
be able to mount my parent's cgroupfs hierarchy. This is deviation
from whats allowed today (i.e., today I can't mount cgroupfs even
after unsharing userns & mntns). This check is there to prevent the
unintended effect of cgroupns feature.

>> @@ -1862,6 +1904,7 @@ static struct file_system_type cgroup_fs_type = {
>>         .name = "cgroup",
>>         .mount = cgroup_mount,
>>         .kill_sb = cgroup_kill_sb,
>> +       .fs_flags = FS_USERNS_MOUNT,
>
> Aargh, another one!  Eric, can you either ack or nack my patch?
> Because if my patch goes in, then this line may need to change.  Or
> not, but if a stable release with cgroupfs and without my patch
> happens, then we'll have an ABI break.
>
> --Andy



-- 
Aditya
