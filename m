From: Andy Lutomirski <luto@kernel.org>
Subject: Re: BUG: Mount ignores mount options
Date: Mon, 13 Aug 2018 09:48:53 -0700
Message-ID: <CALCETrXvtSLjwx0swXo5g-vU3PmF-_6J6j1a_2pAba7bhzO9QQ@mail.gmail.com>
References: <20180810153902.GH21087@thunk.org> <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk> <28045.1533916438@warthog.procyon.org.uk>
 <20180810161400.GA627@thunk.org> <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
 <20180813173502.1a7a1d9c@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180813173502.1a7a1d9c@alans-desktop>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, SELinux-NSA <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, LSM List <linux-security-module@vger.kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@ty>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 13, 2018 at 9:35 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>> If the same block device is visible, with rw access, in two different
>> containers, I don't see any anything good can happen.  Sure, with the
>
> At the raw level there are lots of use cases involving high performance
> data capture, media streaming and the like.
>
> At the file system layer you can use GFS2 for example.

Ugh.  I even thought of this case, and I should have been a bit more precise:

I would consider the GFS2 case to be essentially equivalent to the NFS
case.  I think we can probably divide all the filesystems into three
or four types:

pseudo file systems: Multiple instantiations of the same fs driver
pointing at the same backing store give separate filesystems.  (Same
backing store includes the case where there isn't any backing store.)
tmpfs is an example.  This isn't particularly interesting.

network-like file systems: Multiple instantiations of the same fs
driver pointing at the same backing store are expected.  This includes
NFS, GFS2, AFS, CIFS, etc.  This is only really interesting to the
extent that, if the fs driver internally wants to share state between
multiple instantiations, it should be smart enough to make sure the
options are compatible or that it can otherwise handle mismatched
options correctly.  NFS does this right.

non-network-like filesystems: There are complicated ones like btrfs
and ZFS and simple ones like ext4.  In either case, multiple totally
separate instantiations of the driver sharing the backing store will
lead to corruption.  In cases like ext4, we seem to support it for
legacy reasons, because we're afraid that there are scripts that try
to mount the same block device more than once, and I think the new API
has no need to support this.  In cases like btrfs, we also seem to
support multiple user requests for "mounts" with the same underlying
block devices because we need it for full functionality.  But I think
this is because our API is wrong.

Are there cases I'm missing?  It sounds like the API could be improved
to fully model the last case, and everything will work nicely.
