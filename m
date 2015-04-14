From: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Subject: Re: [v12 0/5] ext4: add project quota support
Date: Tue, 14 Apr 2015 12:07:50 +0200
Message-ID: <CALdWxcsMag1_9fG7vRRAcjM4cpK3je6p+5TyDiumHKZ5AMT+gQ@mail.gmail.com>
References: <1428592477-8212-1-git-send-email-lixi@ddn.com>
	<CAMXgnP6RF4HPDyugvnMKn3rDnuG7j1cz-xFtEMWx4Va1rEHVEQ@mail.gmail.com>
	<20150414082115.GB23327@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150414082115.GB23327-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 14, 2015 at 10:21 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Sun 12-04-15 17:36:53, Alban Crequy wrote:
>> On 9 April 2015 at 17:14, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > The following patches propose an implementation of project quota
>> > support for ext4. A project is an aggregate of unrelated inodes
>> > which might scatter in different directories. Inodes that belong
>> > to the same project possess an identical identification i.e.
>> > 'project ID', just like every inode has its user/group
>> > identification. The following patches add project quota as
>> > supplement to the former uer/group quota types.
>> > (...)
>>
>> Thanks for this work, I would like to use this for containers. I am
>> adding containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org in Cc.
>>
>> To make sure I understand correctly, I will describe the configuration
>> I have in mind and hopefully someone can tell me if it makes sense.
>>
>> Containers created by rkt (https://github.com/coreos/rkt) use an
>> overlay filesystem as root and the lowerdir/upperdir directories are
>> based on an ext4 filesystem outside of the container's reach. The
>> lowerdir is the base image, and several container instances can
>> potentially use the same lowerdir. Each container has its upperdir
>> containing their changes.
>>
>> With your patch set, I could assign a different projid to the upperdir
>> of each container with a specific quota. Then it will limit how much
>> the container will be able to write. I don't know if the overlay's
>> workdir would need to have projid too.
>   I don't think overlay's workdir needs project id. Limits will be simply
> checked when storing data into upperdir by overlayfs. Overlayfs will get
> EDQUOT which it will report back into the user.

Noted, thanks.

>> When a quota warning is sent on netlink, it is received only in the
>> initial user namespace and the processes in a different user namespace
>> will not be able to receive the netlink warnings. The user will only
>> receive a warning through the control terminal.
>   So I don't know much about namespaces but I don't see how quota netlink
> messages would be connected with *user* namespaces. But you are right that
> quota netlink messages will contain ID of the violator mapped into init
> user namespace so it won't make sense to processes in other user namespaces
> even if they were able to receive it.
>
>> Since rkt does not use user namespaces yet, a rkt container could
>> unfortunately receive quota warnings through netlink concerning the
>> host or other containers. Or is it restricted to init_net?
>   Quota netlink messages are sent only in init_net namespace (since quota
> netlink protocol wasn't made namespace aware). So this shouldn't be an
> issue.

You're right, I misread it, it references the init network namespace
and not the user namespace:

fs/quota/netlink.c:quota_send_warning() uses genlmsg_multicast() which
specifically references init_net:

         return genlmsg_multicast_netns(family, &init_net, skb,
                                        portid, group, flags);

>> quotactl() can be used in a rkt container if the proccesses in the
>> container can guess somehow which block device is used by the
>> filesystem hosting the overlay's upperdir and if they can mknod it
>> somewhere. Usually, containers don't restrict mknod but just restrict
>> read-write access through the device cgroup. The read-write access is
>> irrelevant for quotactl(): quotactl() just check that the device node
>> exists and that it is not on a nodev mount. The nodev check does not
>> restrict containers here because they usually have a /dev mounted as
>> tmpfs without the nodev option.
>   Correct. This raises a somewhat unrelated question: Does this mean that a
> container is able to mount arbitrary block device? Because also there we
> just pass a device path to the kernel...

The process would still need CAP_SYS_ADMIN and there are additional
checks when the user namespace is not the initial user namespace:

fs/namespace.c do_new_mount()
        if (user_ns != &init_user_ns) {
                if (!(type->fs_flags & FS_USERNS_MOUNT)) {
                        put_filesystem(type);
                        return -EPERM;
                }...

For example, FS_USERNS_MOUNT is set on devpts_fs_type but not on
ext4_fs_type. So it's not possible to mount ext4 in a different user
namespace. Containers that don't use user namespaces can avoid giving
CAP_SYS_ADMIN or restrict mount with some AppArmor rules.

>> Containers that don't use user namespaces (so no projid mapping) would
>> be able to query quotas for projid assigned to other containers
>> (unfortunately). They would be able to change the quota of other
>> containers if they are privileged enough to be given CAP_SYS_RESOURCE.
>   Yes.
>
>> Containers using user namespaces would not be able to change any quota
>> config because they don't have CAP_SYS_RESOURCE in the init user
>> namespace. If they are configured with a proper projid mapping, they
>> would only be able to query the projid they are assigned (they could
>> guess which projid to query by looking at /proc/self/projid_map).
>   Yes.
>
>> Do you know if someone is working on the documentation? It would be
>> nice if filesystems/quota.txt could say who can receive the quota
>> warnings on netlink (which namespace) and if it could give some
>   I have added that.
>
>> information about projid. But maybe this belong to the proc(5) and
>> user_namespaces(7) manpages as well.
>   Project ID in VFS quotas is fairly new thing. Once ext4 gains support for
> it, I can add some documentation.
>
>> Is there any suggestions how to allocate projid in userspace?
>> Something like /etc/subprojid similar to /etc/subuid?
>   I guess you need some coordination between namespaces?

Yes, I was thinking if Docker uses projid for some containers, rkt
uses other projid for other containers and the sysadmin also define
some projid manually.

> I only know that
> traditionally xfsprogs use /etc/projid for name->project id translation
> and /etc/projects contain roots of directory trees for which you wish to
> maintain directory quota together with project ids for each of the trees.

Thanks for the pointer.

Alban

>
>                                                                 Honza
> --
> Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> SUSE Labs, CR
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
