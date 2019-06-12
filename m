From: Christian Brauner <christian@brauner.io>
Subject: Regression for MS_MOVE on kernel v5.1
Date: Thu, 13 Jun 2019 00:54:33 +0200
Message-ID: <20190612225431.p753mzqynxpsazb7@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dhowells@redhat.com
List-Id: linux-api@vger.kernel.org

Hey,

Sorry to be the bearer of bad news but I think I observed a pretty
gnarly regression for userspace with MS_MOVE from kernel v5.1 onwards.

When propagating mounts across mount namespaces owned by different user
namespaces it is not possible anymore to move the mount in the less
privileged mount namespace.
Here is a reproducer:

sudo mount -t tmpfs tmpfs /mnt
sudo --make-rshared /mnt

# create unprivileged user + mount namespace and preserve propagation
unshare -U -m --map-root --propagation=unchanged

# now change back to the original mount namespace in another terminal:
sudo mkdir /mnt/aaa
sudo mount -t tmpfs tmpfs /mnt/aaa

# now in the unprivileged user + mount namespace
mount --move /mnt/aaa /opt

This will work on kernels prior to 5.1 but will fail on kernels starting
with 5.1.
Unfortunately, this is a pretty big deal for userspace. In LXD - which I
maintain when not doing kernel stuff - we use this mechanism to inject
mounts into running unprivileged containers. Users started reporting
failures against our mount injection feature just a short while ago
(cf.  [1], [2]) and I just came around to looking into this today.

I tracked this down to commit:

commit 3bd045cc9c4be2049602b47505256b43908b4e2f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Jan 30 13:15:45 2019 -0500

    separate copying and locking mount tree on cross-userns copies

    Rather than having propagate_mnt() check doing unprivileged copies,
    lock them before commit_tree().

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

reverting it makes MS_MOVE to work correctly again.
The commit changes the internal logic to lock mounts when propagating
mounts (user+)mount namespaces and - I believe - causes do_mount_move()
to fail at:

if (old->mnt.mnt_flags & MNT_LOCKED)
        goto out;

If that's indeed the case we should either revert this commit (reverts
cleanly, just tested it) or find a fix.

Thanks!
Christian

[1]: https://github.com/lxc/lxd/issues/5788
[2]: https://github.com/lxc/lxd/issues/5836
