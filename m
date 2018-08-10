From: David Howells <dhowells@redhat.com>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 16:13:11 +0100
Message-ID: <22558.1533913991@warthog.procyon.org.uk>
References: <0F2FA70F-8C7E-4D7D-B685-244A76BDB459@amacapital.net> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <87d0uqpba5.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0F2FA70F-8C7E-4D7D-B685-244A76BDB459@amacapital.net>
Content-ID: <22557.1533913991.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.o
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> > /dev/loop0 /root/loop0-noacl-noquota-nouser_xattr ext4 rw,relatime,nouser_xattr,noacl 0 0
> > /dev/loop0 /root/loop0-acl-quota-user_xattr ext4 rw,relatime,nouser_xattr,noacl 0 0
> 
> To make sure I understand correctly: the problem is that the second mount
> ignored the options because the device was already mounted, right?
> 
> For the new API, I think the only remotely sane approach is to refuse to
> mount or init or whatever you call it an already mounted bdev. If user code
> genuinely needs to bind-mount an existing mount that is known only by its
> bdev, we can add a specific API just for that.

I'm adding some flags to fsopen() to allow userspace to say whether it wants
no sharing, same parameters-only sharing or anything-goes sharing (as now).

I'm also adding a flag whereby userspace can forbid anyone else from sharing a
new superblock it has just set up.

David
