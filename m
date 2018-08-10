From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 16:46:39 -0400
Message-ID: <20180810204639.GI627@thunk.org>
References: <20180810153902.GH21087@thunk.org>
 <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
 <28045.1533916438@warthog.procyon.org.uk>
 <20180810161400.GA627@thunk.org>
 <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, SELinux-NSA <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, LSM List <linux-security-module@vger.kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, open list:CONTROL GR
List-Id: linux-api@vger.kernel.org

On Fri, Aug 10, 2018 at 01:06:54PM -0700, Andy Lutomirski wrote:
> If the same block device is visible, with rw access, in two different
> containers, I don't see any anything good can happen.

It's worse than that.  I've fixed a lot of bugs which cause the kernel
to crash, and a few that might be levered into a privilege escalationh
attack, when you mount a maliciously corrupted file system using ext4.
I'm told told the security researcher filed similar reports with the
XFS community, and he was told, "that's what metadata checksums are
for; go away".  Given how much time it takes to work with these
security researchers, I don't blame them.

But in light of that, I'd make a somewhat stronger statement.  If you
let an untrusted container mount arbitrary block devices where they
have rw acccess to the underlying block device, nothing good can
happen.  Period.  :-)

Which is why I don't think the lack of being able to reject
"conflicting mount options" is really all that important.  It
certainly shouldn't block the fsopen patch series.  #1, it's a problem
we have today, and #2, I'm really not all sure supporting bind mounts
via specifying block device was ever a good idea to begin with.  And
#3, while I've been fixing ext4 against security issues caused by
maliciously corrupted file system images, I'm still sure that allowing
untrusted containers access to mount *any* file system via a block
device for which they have r/w access is a Really Bad Idea.

> It seems to me that the current approach mostly involves crossing our fingers.

Agreed!

						- Ted
