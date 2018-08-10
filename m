From: Andy Lutomirski <luto@kernel.org>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 13:06:54 -0700
Message-ID: <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
References: <20180810153902.GH21087@thunk.org> <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk> <28045.1533916438@warthog.procyon.org.uk>
 <20180810161400.GA627@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180810161400.GA627@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, SELinux-NSA <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, LSM List <linux-security-module@vger.kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.s
List-Id: linux-api@vger.kernel.org

On Fri, Aug 10, 2018 at 9:14 AM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> And I'm not really sure it helps the container use
> case, since the whole point is they want their "guest" to be able to
> blithely run "mount /dev/sda1 -o noxattr /mnt" and not worry about the
> fact that in some other container, someone had run "mount /dev/sda1 -o
> xattr /mnt".  But having the second mount fail because of conflicting
> mount option breaks the illusion that containers are functionally as
> rich as VM's.

If the same block device is visible, with rw access, in two different
containers, I don't see any anything good can happen.  Sure, with the
current somewhat erratic semantics of mount(2), something kind of sort
of reasonable happens if they both mount it.  But if one or both of
them try to use, say, tune2fs or fsck, it's not going to go well.  And
a situation where they mount with different options and the result
depends on the order of the mounts is just plain bad.

I see four sane ways to deal with this:

1. Don't put the block device in the container at all.  The container
manager mounts it.

2. Use seccomp or a similar mechanism to intercept and emulate the
mount request.

3. Teach the filesystem driver to do something sensible.  This will
inherently be per-fs, and probably involves some serious magic or
allowing filesystem-specific vfsmount options.

4. Introduce a concept of a special kind of fake block device that
refers to an existing superblock, doesn't allow direct read or write,
and does the right thing when mounted.  Not obviously worth the
effort.

It seems to me that the current approach mostly involves crossing our fingers.
