From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: BUG: Mount ignores mount options
Date: Mon, 13 Aug 2018 17:35:02 +0100
Message-ID: <20180813173502.1a7a1d9c@alans-desktop>
References: <20180810153902.GH21087@thunk.org>
        <87d0uqpba5.fsf@xmission.com>
        <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
        <22361.1533913891@warthog.procyon.org.uk>
        <28045.1533916438@warthog.procyon.org.uk>
        <20180810161400.GA627@thunk.org>
        <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, SELinux-NSA <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, LSM List <linux-security-module@vger.kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.s
List-Id: linux-api@vger.kernel.org

> If the same block device is visible, with rw access, in two different
> containers, I don't see any anything good can happen.  Sure, with the

At the raw level there are lots of use cases involving high performance
data capture, media streaming and the like.

At the file system layer you can use GFS2 for example.

So there are cases where it's possible. There are even cases where it's
actually useful at the filesystem level although not many I agree.

Alan
