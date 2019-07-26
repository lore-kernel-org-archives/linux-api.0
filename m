From: Christian Brauner <christian@brauner.io>
Subject: Regression in 5.3 for some FS_USERNS_MOUNT (aka
 user-namespace-mountable) filesystems
Date: Fri, 26 Jul 2019 13:59:59 +0200
Message-ID: <20190726115956.ifj5j4apn3tmwk64@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hey everyone,

We have another mount api regression. With current 5.3-rc1 it is not
possible anymore to mount filesystems that have FS_USERNS_MOUNT set and
their fs_context's global member set to true. At least sysfs is
affected, likely also cgroup{2}fs.

The commit that introduced the regression is:

commit 0ce0cf12fc4c6a089717ff613d76457052cf4303
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun May 12 15:42:48 2019 -0400

    consolidate the capability checks in sget_{fc,userns}()

    ... into a common helper - mount_capable(type, userns)

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

mount_capable() will select the user namespace in which to check for
CAP_SYS_ADMIN based on the global property of the filesystem's
fs_context.

Since sysfs has global set to true mount_capable() will check for
CAP_SYS_ADMIN in init_user_ns and fail the mount with EPERM for any
non-init userns root. The same check is present in sget_fc().

To me it looks like that global is overriding FS_USERNS_MOUNT which
seems odd. Afaict, there are two ways to fix this:
- remove global from sysfs
- remove the global check from mount_capable() and possibly sget_fc()

The latter feels more correct but I'm not sure *why* that global thing
got introduced. Seems there could be an additional flag on affected
filesystems instead of this "global" thing. But not sure.

I can whip up a patch in case that does make sense.
And it would probably be a good thing if we had some sort of test (if
there isn't one already) so that this doesn't happen again. It could be
as simple as:

unshare -U -m --map-root -n
mkdir whatever
mount -t sysfs sysfs ./whatever

Thanks!
Christian
