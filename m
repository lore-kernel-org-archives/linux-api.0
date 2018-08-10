From: David Howells <dhowells@redhat.com>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 17:11:55 +0100
Message-ID: <30317.1533917515@warthog.procyon.org.uk>
References: <f199f22e-f064-b089-25bd-6e37ed1a73bd@schaufler-ca.com> <87d0uqpba5.fsf@xmission.com> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <22361.1533913891@warthog.procyon.org.uk> <20180810153902.GH21087@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f199f22e-f064-b089-25bd-6e37ed1a73bd@schaufler-ca.com>
Content-ID: <30316.1533917515.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Mi
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> > P.S.  And as Al has pointed out, this would require special, per-file
> > system support to determine whether the mount options are conflicting
> > or not....
> 
> This extends to LSMs that support mount options (SELinux and Smack)
> as well. 

Yes.  I'm doing that.

David
