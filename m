From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: BUG: Mount ignores mount options
Date: Mon, 13 Aug 2018 18:29:47 +0100
Message-ID: <20180813172947.GS6515@ZenIV.linux.org.uk>
References: <20180810153902.GH21087@thunk.org>
 <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
 <28045.1533916438@warthog.procyon.org.uk>
 <20180810161400.GA627@thunk.org>
 <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
 <20180813173502.1a7a1d9c@alans-desktop>
 <CALCETrXvtSLjwx0swXo5g-vU3PmF-_6J6j1a_2pAba7bhzO9QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXvtSLjwx0swXo5g-vU3PmF-_6J6j1a_2pAba7bhzO9QQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Theodore Y. Ts'o" <tytso@mit.edu>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, SELinux-NSA <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, LSM List <linux-security-module@vger.kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lis
List-Id: linux-api@vger.kernel.org

On Mon, Aug 13, 2018 at 09:48:53AM -0700, Andy Lutomirski wrote:

> I would consider the GFS2 case to be essentially equivalent to the NFS
> case.  I think we can probably divide all the filesystems into three
> or four types:
> 
> pseudo file systems: Multiple instantiations of the same fs driver
> pointing at the same backing store give separate filesystems.  (Same
> backing store includes the case where there isn't any backing store.)
> tmpfs is an example.  This isn't particularly interesting.
> 
> network-like file systems: Multiple instantiations of the same fs
> driver pointing at the same backing store are expected.  This includes
> NFS, GFS2, AFS, CIFS, etc.  This is only really interesting to the
> extent that, if the fs driver internally wants to share state between
> multiple instantiations, it should be smart enough to make sure the
> options are compatible or that it can otherwise handle mismatched
> options correctly.  NFS does this right.
> 
> non-network-like filesystems: There are complicated ones like btrfs
> and ZFS and simple ones like ext4.  In either case, multiple totally
> separate instantiations of the driver sharing the backing store will
> lead to corruption.  In cases like ext4, we seem to support it for
> legacy reasons, because we're afraid that there are scripts that try
> to mount the same block device more than once, and I think the new API
> has no need to support this.  In cases like btrfs, we also seem to
> support multiple user requests for "mounts" with the same underlying
> block devices because we need it for full functionality.  But I think
> this is because our API is wrong.
> 
> Are there cases I'm missing?  It sounds like the API could be improved
> to fully model the last case, and everything will work nicely.

	You know, that's starting to remind of this little gem of Borges:
http://www.alamut.com/subj/artiface/language/johnWilkins.html
Especially the delightful (fake) quote contained in there:
[...] it is written that the animals are divided into:
	(a) belonging to the emperor,
	(b) embalmed,
	(c) tame,
	(d) sucking pigs,
	(e) sirens,
	(f) fabulous,
	(g) stray dogs,
	(h) included in the present classification,
	(i) frenzied,
	(j) innumerable,
	(k) drawn with a very fine camelhair brush,
	(l) et cetera,
	(m) having just broken the water pitcher,
	(n) that from a long way off look like flies.
