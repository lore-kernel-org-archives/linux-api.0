From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 11:39:02 -0400
Message-ID: <20180810153902.GH21087@thunk.org>
References: <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <22361.1533913891@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.orgMiklos Szeredi <m>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 10, 2018 at 04:11:31PM +0100, David Howells wrote:
> 
> Yes.  Since you *absolutely* *insist* on this being fixed *right* *now* *or*
> *else*, I'm working up a set of additional patches to give userspace the
> option of whether they want no sharing; sharing, but only with exactly the
> same parameters; or to ignore the parameter differences and just accept
> sharing of what's already already mounted (ie. the current behaviour).

But there's no way to support "no sharing", at least not in the
general case.  A file system can only be mounted once, and without
file system support, there's no way for a file system to be mounted
with the bsddf or minixdf mount simultaneously.

Even *with* file system support, there's no way today for the VFS to
keep track of whether a pathname resolution came through one
mountpoint or another, so I can't do something like this:

	mount /dev/sdXX -o casefold /android-data
	mount /dev/sdXX -o nocasefold /android-data-2

Which is a pity, since if we could we could much more easily get rid
of the horror which is Android's wrapfs...

So if the file system has been mounted with one set of mount options,
and you want to try to mount it with a conflicting set of mount
options and you don't want it to silently ignore the mount options,
the *only* thing we can today is to refuse the mount and return an
error.  

I'm not sure Eric would really consider that an improvement for the
container use case....

						- Ted

P.S.  And as Al has pointed out, this would require special, per-file
system support to determine whether the mount options are conflicting
or not....
