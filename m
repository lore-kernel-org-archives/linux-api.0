From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] mnt: allow to add a mount into an existing group
Date: Tue, 09 May 2017 19:42:00 -0500
Message-ID: <87mvalr19j.fsf@xmission.com>
References: <20170428051831.20084-1-avagin@openvz.org>
        <CANaxB-y9W6E_6W70BPWduTcZ+A3u=w9ZLw2dvdrfe-gYcDvKhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANaxB-y9W6E_6W70BPWduTcZ+A3u=w9ZLw2dvdrfe-gYcDvKhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Andrey Vagin's message of "Tue, 9 May 2017 10:36:46 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "criu@openvz.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:

> On Tue, Jan 24, 2017 at 02:03:23PM +1300, Eric W. Biederman wrote:
>> Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:
>>
>> > Now a shared group can be only inherited from a source mount.
>> > This patch adds an ability to add a mount into an existing shared
>> > group.
>>
>> This sounds like a lot of the discussion on bind mounts accross
>> namespaces.  I am going to stay out of this for a bit until
>> we resolve my latest patch.
>
> Hi Eric,
>
> Your patches about shadow/side mounts were committed, can we resume
> the discussion about this patch?

We can.

Although personally I would rather get back to figuring out how
we can reduce the horrible time complexity of the worst case
for umount -l.

> As for security, a mount can be added to a shared group, only if a
> caller has CAP_SYS_ADMIN in namespaces of both mounts, so an
> unprivileged user can't create a shared mount with a parent mount
> namespace. If a user has CAP_SYS_ADMIN, I don't see a reason to
> restrict him to create shared mounts between namespaces, even if they
> are in different user-namespaces.

Can they create loops in mount propagation trees that we can not create
today?  It feels like that would be very simple to do with an interface
like this.

A loop in a mount propagation tree would be an absolute disaster.

I remember Al Viro had some very firm ideas about bind mounts from
foreign namespaces.  That I have never take the time to understand.
I suspect whatever objections he had will apply in this case.  Or else
this code might be made unnecessary by allowing bind mounts between
mount namespaces.


> Now I look at volume drivers in container services (like docker and
> kubernetes) and I think this functionality can be useful for them too.
> Now it is impossible to run a plugin driver in unprivileged containers
> (with sub-userns), because a container has to have a shared mount with
> a mount namespace where the service is running. The idea of these
> plugins is that a service requests a volume mount from a plugin and
> then starts a container with this volume, so the service need to have
> a way to get a mount from a service.

Interesting.  I personally think the checkpoint/restart use case
is more compelling.

>> Eric
>
>
> On Thu, Apr 27, 2017 at 10:18 PM, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>> Now a shared group can be only inherited from a source mount.
>> This patch adds an ability to add a mount into an existing shared
>> group.
>>
>> mount(source, target, NULL, MS_SET_GROUP, NULL)
>>
>> mount() with the MS_SET_GROUP flag adds the "target" mount into a group
>> of the "source" mount. The calling process has to have the CAP_SYS_ADMIN
>> capability in namespaces of these mounts. The source and the target
>> mounts have to have the same super block.
>>
>> This new functionality together with "mnt: Tuck mounts under others
>> instead of creating shadow/side mounts." allows CRIU to dump and restore
>> any set of mount namespaces.
>>
>> Currently we have a lot of issues about dumping and restoring mount
>> namespaces. The bigest problem is that we can't construct mount trees
>> directly due to several reasons:
>> * groups can't be set, they can be only inherited
>> * file systems has to be mounted from the specified user namespaces
>> * the mount() syscall doesn't just create one mount -- the mount is
>>   also propagated to all members of a parent group
>> * umount() doesn't detach mounts from all members of a group
>>   (mounts with children are not umounted)
>> * mounts are propagated underneath of existing mounts
>> * mount() doesn't allow to make bind-mounts between two namespaces
>> * processes can have opened file descriptors to overmounted files
>>
>> All these operations are non-trivial, making the task of restoring
>> a mount namespace practically unsolvable for reasonable time. The
>> proposed change allows to restore a mount namespace in a direct
>> manner, without any super complex logic.
>>
>> Cc: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>> Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
>> Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>> ---
>>  fs/namespace.c          | 66 ++++++++++++++++++++++++++++++++++++++++++++++---
>>  include/uapi/linux/fs.h |  6 +++++
>>  2 files changed, 68 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index cc1375ef..3bf0cd2 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -2355,6 +2355,57 @@ static inline int tree_contains_unbindable(struct mount *mnt)
>>         return 0;
>>  }
>>
>> +static int do_set_group(struct path *path, const char *sibling_name)
>> +{
>> +       struct mount *sibling, *mnt;
>> +       struct path sibling_path;
>> +       int err;
>> +
>> +       if (!sibling_name || !*sibling_name)
>> +               return -EINVAL;
>> +
>> +       err = kern_path(sibling_name, LOOKUP_FOLLOW, &sibling_path);
>> +       if (err)
>> +               return err;
>> +
>> +       sibling = real_mount(sibling_path.mnt);
>> +       mnt = real_mount(path->mnt);
>> +
>> +       namespace_lock();
>> +
>> +       err = -EPERM;
>> +       if (!sibling->mnt_ns ||
>> +           !ns_capable(sibling->mnt_ns->user_ns, CAP_SYS_ADMIN))
>> +               goto out_unlock;
>> +
>> +       err = -EINVAL;
>> +       if (sibling->mnt.mnt_sb != mnt->mnt.mnt_sb)
>> +               goto out_unlock;
>> +
>> +       if (IS_MNT_SHARED(mnt) || IS_MNT_SLAVE(mnt))
>> +               goto out_unlock;
>> +
>> +       if (IS_MNT_SLAVE(sibling)) {
>> +               struct mount *m = sibling->mnt_master;
>> +
>> +               list_add(&mnt->mnt_slave, &m->mnt_slave_list);
>> +               mnt->mnt_master = m;
>> +       }
>> +
>> +       if (IS_MNT_SHARED(sibling)) {
>> +               mnt->mnt_group_id = sibling->mnt_group_id;
>> +               list_add(&mnt->mnt_share, &sibling->mnt_share);
>> +               set_mnt_shared(mnt);
>> +       }
>> +
>> +       err = 0;
>> +out_unlock:
>> +       namespace_unlock();
>> +
>> +       path_put(&sibling_path);
>> +       return err;
>> +}
>> +
>>  static int do_move_mount(struct path *path, const char *old_name)
>>  {
>>         struct path old_path, parent_path;
>> @@ -2769,6 +2820,7 @@ long do_mount(const char *dev_name, const char __user *dir_name,
>>         struct path path;
>>         int retval = 0;
>>         int mnt_flags = 0;
>> +       unsigned long cmd;
>>
>>         /* Discard magic */
>>         if ((flags & MS_MGC_MSK) == MS_MGC_VAL)
>> @@ -2820,19 +2872,25 @@ long do_mount(const char *dev_name, const char __user *dir_name,
>>                 mnt_flags |= path.mnt->mnt_flags & MNT_ATIME_MASK;
>>         }
>>
>> +       cmd = flags & (MS_REMOUNT | MS_BIND |
>> +                      MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE |
>> +                      MS_MOVE | MS_SET_GROUP);
>> +
>>         flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
>>                    MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
>>                    MS_STRICTATIME | MS_NOREMOTELOCK | MS_SUBMOUNT);
>>
>> -       if (flags & MS_REMOUNT)
>> +       if (cmd & MS_REMOUNT)
>>                 retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
>>                                     data_page);
>> -       else if (flags & MS_BIND)
>> +       else if (cmd & MS_BIND)
>>                 retval = do_loopback(&path, dev_name, flags & MS_REC);
>> -       else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
>> +       else if (cmd & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
>>                 retval = do_change_type(&path, flags);
>> -       else if (flags & MS_MOVE)
>> +       else if (cmd & MS_MOVE)
>>                 retval = do_move_mount(&path, dev_name);
>> +       else if (cmd & MS_SET_GROUP)
>> +               retval = do_set_group(&path, dev_name);
>>         else
>>                 retval = do_new_mount(&path, type_page, flags, mnt_flags,
>>                                       dev_name, data_page);
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index 048a85e..33423aa 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -131,6 +131,12 @@ struct inodes_stat_t {
>>  #define MS_STRICTATIME (1<<24) /* Always perform atime updates */
>>  #define MS_LAZYTIME    (1<<25) /* Update the on-disk [acm]times lazily */
>>
>> +/*
>> + * Here are commands and flags. Commands are handled in do_mount()
>> + * and can intersect with kernel internal flags.
>> + */
>> +#define MS_SET_GROUP   (1<<26) /* Add a mount into a shared group */
>> +
>>  /* These sb flags are internal to the kernel */
>>  #define MS_SUBMOUNT     (1<<26)
>>  #define MS_NOREMOTELOCK        (1<<27)
>> --
>> 2.9.3
>>
