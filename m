From: David Howells <dhowells@redhat.com>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 16:53:58 +0100
Message-ID: <28045.1533916438@warthog.procyon.org.uk>
References: <20180810153902.GH21087@thunk.org> <87d0uqpba5.fsf@xmission.com> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <22361.1533913891@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180810153902.GH21087@thunk.org>
Content-ID: <28044.1533916438.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: dhowells@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.o
List-Id: linux-api@vger.kernel.org

Theodore Y. Ts'o <tytso@mit.edu> wrote:

> Even *with* file system support, there's no way today for the VFS to
> keep track of whether a pathname resolution came through one
> mountpoint or another, so I can't do something like this:

Ummm...  Isn't that encoded in the vfsmount pointer in struct path?

However, the case folding stuff - is that a superblockism of a mountpointism?

> So if the file system has been mounted with one set of mount options,
> and you want to try to mount it with a conflicting set of mount
> options and you don't want it to silently ignore the mount options,
> the *only* thing we can today is to refuse the mount and return an
> error.  

With fsopen() there is the option to have the filesystem and the LSM attempt
to compare the non-key[*] mount options and reject the attempt to share if
they differ in any way.

David


[*] sget lookup keys, that is.
