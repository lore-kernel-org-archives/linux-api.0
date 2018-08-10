From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 15:12:34 -0700
Message-ID: <20180810221234.GC4211@magnolia>
References: <20180810153902.GH21087@thunk.org>
 <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
 <28045.1533916438@warthog.procyon.org.uk>
 <20180810161400.GA627@thunk.org>
 <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
 <20180810204639.GI627@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180810204639.GI627@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, SELinux-NSA <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, LSM List <linux-security-module@vger.kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@ty>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 10, 2018 at 04:46:39PM -0400, Theodore Y. Ts'o wrote:
> On Fri, Aug 10, 2018 at 01:06:54PM -0700, Andy Lutomirski wrote:
> > If the same block device is visible, with rw access, in two different
> > containers, I don't see any anything good can happen.
> 
> It's worse than that.  I've fixed a lot of bugs which cause the kernel
> to crash, and a few that might be levered into a privilege escalationh
> attack, when you mount a maliciously corrupted file system using ext4.
> I'm told told the security researcher filed similar reports with the
> XFS community, and he was told, "that's what metadata checksums are
> for; go away".

Hey now, there was a little more nuance to it than that[1][2].  The
complaint in the first instance had much more to do with breaking
existing V4 filesystems by adding format requirements that mkfs didn't
know about when the filesystem was created.  Yes, you can create V4
filesystems that will hang the system if the log was totally unformatted
and metadata updates are made, but OTOH it's fairly obvious when that
happens, you have to be root to mount a disk filesystem, and we try to
avoid breaking existing users.

XFS developers have been and will continue to examine security problems
when they are brought to our attention and strengthen validation as
needed to minimize the risk of incorrect behaviors, but filesystems are
complex machines, complex machinery is risky, and we arbitrate some of
that risk by requiring administrators to elect to mount an XFS.

> Given how much time it takes to work with these security researchers,
> I don't blame them.
> 
> But in light of that, I'd make a somewhat stronger statement.  If you
> let an untrusted container mount arbitrary block devices where they
> have rw acccess to the underlying block device, nothing good can
> happen.  Period.  :-)
> 
> Which is why I don't think the lack of being able to reject
> "conflicting mount options" is really all that important.  It
> certainly shouldn't block the fsopen patch series.  #1, it's a problem
> we have today, and #2, I'm really not all sure supporting bind mounts
> via specifying block device was ever a good idea to begin with.  And
> #3, while I've been fixing ext4 against security issues caused by
> maliciously corrupted file system images, I'm still sure that allowing
> untrusted containers access to mount *any* file system via a block
> device for which they have r/w access is a Really Bad Idea.
> 
> > It seems to me that the current approach mostly involves crossing our fingers.
> 
> Agreed!

Crossing our fingers and demanding administrator intentionality when
mounting filesystems off some piece of storage.

--D

[1] https://lkml.org/lkml/2018/5/21/649
[2] https://lkml.org/lkml/2018/4/2/572
