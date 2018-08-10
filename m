From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 16:24:08 +0100
Message-ID: <20180810152408.GB6515@ZenIV.linux.org.uk>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <87d0uqpba5.fsf@xmission.com>
 <0F2FA70F-8C7E-4D7D-B685-244A76BDB459@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0F2FA70F-8C7E-4D7D-B685-244A76BDB459@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Theo
List-Id: linux-api@vger.kernel.org

On Fri, Aug 10, 2018 at 07:36:17AM -0700, Andy Lutomirski wrote:
> 
> 
> > On Aug 10, 2018, at 7:05 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > 
> > 
> > There is a serious problem with mount options today that fsopen does not
> > address.  The problem is that mount options are ignored for block based
> > filesystems, and any other type of filesystem that follows the same
> > pattern.
> > 
> 
> > /dev/loop0 /root/loop0-noacl-noquota-nouser_xattr ext4 rw,relatime,nouser_xattr,noacl 0 0
> > /dev/loop0 /root/loop0-acl-quota-user_xattr ext4 rw,relatime,nouser_xattr,noacl 0 0
> 
> To make sure I understand correctly: the problem is that the second mount ignored the options because the device was already mounted, right?
> 
> For the new API, I think the only remotely sane approach is to refuse to mount or init or whatever you call it an already mounted bdev. If user code genuinely needs to bind-mount an existing mount that is known only by its bdev, we can add a specific API just for that.

First of all, that does NOT belong anywhere other than fs itself.
Example: NFS.  Not every attempt to mount something leads to creation
of new fs instance; moreover, whether it will or not can't be predicted
in general.

PS: for pity sake, fix your MUA; 270-character lines are way over the
top.
