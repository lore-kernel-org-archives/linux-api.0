From: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v12 0/5] ext4: add project quota support
Date: Sun, 12 Apr 2015 17:36:53 +0200
Message-ID: <CAMXgnP6RF4HPDyugvnMKn3rDnuG7j1cz-xFtEMWx4Va1rEHVEQ@mail.gmail.com>
References: <1428592477-8212-1-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428592477-8212-1-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 9 April 2015 at 17:14, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The following patches propose an implementation of project quota
> support for ext4. A project is an aggregate of unrelated inodes
> which might scatter in different directories. Inodes that belong
> to the same project possess an identical identification i.e.
> 'project ID', just like every inode has its user/group
> identification. The following patches add project quota as
> supplement to the former uer/group quota types.
> (...)

Thanks for this work, I would like to use this for containers. I am
adding containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org in Cc.

To make sure I understand correctly, I will describe the configuration
I have in mind and hopefully someone can tell me if it makes sense.

Containers created by rkt (https://github.com/coreos/rkt) use an
overlay filesystem as root and the lowerdir/upperdir directories are
based on an ext4 filesystem outside of the container's reach. The
lowerdir is the base image, and several container instances can
potentially use the same lowerdir. Each container has its upperdir
containing their changes.

With your patch set, I could assign a different projid to the upperdir
of each container with a specific quota. Then it will limit how much
the container will be able to write. I don't know if the overlay's
workdir would need to have projid too.

When a quota warning is sent on netlink, it is received only in the
initial user namespace and the processes in a different user namespace
will not be able to receive the netlink warnings. The user will only
receive a warning through the control terminal.

Since rkt does not use user namespaces yet, a rkt container could
unfortunately receive quota warnings through netlink concerning the
host or other containers. Or is it restricted to init_net?

quotactl() can be used in a rkt container if the proccesses in the
container can guess somehow which block device is used by the
filesystem hosting the overlay's upperdir and if they can mknod it
somewhere. Usually, containers don't restrict mknod but just restrict
read-write access through the device cgroup. The read-write access is
irrelevant for quotactl(): quotactl() just check that the device node
exists and that it is not on a nodev mount. The nodev check does not
restrict containers here because they usually have a /dev mounted as
tmpfs without the nodev option.

Containers that don't use user namespaces (so no projid mapping) would
be able to query quotas for projid assigned to other containers
(unfortunately). They would be able to change the quota of other
containers if they are privileged enough to be given CAP_SYS_RESOURCE.

Containers using user namespaces would not be able to change any quota
config because they don't have CAP_SYS_RESOURCE in the init user
namespace. If they are configured with a proper projid mapping, they
would only be able to query the projid they are assigned (they could
guess which projid to query by looking at /proc/self/projid_map).

Do you know if someone is working on the documentation? It would be
nice if filesystems/quota.txt could say who can receive the quota
warnings on netlink (which namespace) and if it could give some
information about projid. But maybe this belong to the proc(5) and
user_namespaces(7) manpages as well.

Is there any suggestions how to allocate projid in userspace?
Something like /etc/subprojid similar to /etc/subuid?

Thanks!
Alban
