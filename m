From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: BUG: Mount ignores mount options
Date: Sat, 11 Aug 2018 00:11:47 +0900
Message-ID: <79f05de7-e600-675d-7bbf-c56faafc3134@i-love.sakura.ne.jp>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <87d0uqpba5.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87d0uqpba5.fsf@xmission.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-api@vger.kernel.org

On 2018/08/10 23:05, Eric W. Biederman wrote:
> 
> There is a serious problem with mount options today that fsopen does not
> address.  The problem is that mount options are ignored for block based
> filesystems, and any other type of filesystem that follows the same
> pattern.
> 
> The script below demonstrates this bug.  Showing this bug can cause the
> ext4 "acl" "quota" and "user_xattr" options to be silently ignored.
> 
> fsopen has my nack until it addresses this issue.
> 
> I don't know if we can fix this in the context of sys_mount.  But we if
> we are redoing the option parsing of how we mount filesystems this needs
> to be fixed before we start worrying about bug compatibility.
> 
> Hopefully this report is simple and clear enough that we can at least
> agree on the problem.
> 
> Eric

This might be related to a problem that syzbot is failing to reproduce a problem.

  https://groups.google.com/forum/#!msg/syzkaller-bugs/R03vI7RCVco/0PijCTrcCgAJ

  syzbot found a reproducer, and the reproducer was working until next-20180803.
  But the reproducer is failing to reproduce this problem in next-20180806 despite
  there is no mm related change between next-20180803 and next-20180806.

  Therefore, I suspect that the reproducer is no longer working as intended. And
  there was parser change (David Howells' patch) between next-20180803 and next-20180806.

I'm waiting for response from David Howells...
