From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 23:48:24 -0500
Message-ID: <8736vlo6ef.fsf@xmission.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
        <87d0uqpba5.fsf@xmission.com>
        <20180810151606.GA6515@ZenIV.linux.org.uk>
        <87pnypiufr.fsf@xmission.com> <20180811014619.GA14368@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180811014619.GA14368@thunk.org> (Theodore Y. Ts'o's message of
        "Fri, 10 Aug 2018 21:46:19 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos
List-Id: linux-api@vger.kernel.org

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Fri, Aug 10, 2018 at 08:05:44PM -0500, Eric W. Biederman wrote:
>> 
>> My complaint is that the current implemented behavior of practically
>> every filesystem in the kernel, is that it will ignore mount options
>> when mounted a second time.
>
> The file system is ***not*** mounted a second time.
>
> The design bug is that we allow bind mounts to be specified via a
> block device.  A bind mount is not "a second mount" of the file
> system.  Bind mounts != mounts.
>
> I had assumed we had allowed bind mounts to be specified via the block
> device because of container use cases.  If the container folks don't
> want it, I would be pushing to simply not allow bind mounts to be
> specified via block device at all.

No it is not a container thing.

> The only reason why we should support it is because we don't want to
> break scripts; and if the goal is not to break scripts, then we have
> to keep to the current semantics, however broken you think it is.

But we don't have to support returning filesystems with mismatched mount
options in the new fsopen api.   That is my concern.  Confusing
userspace this way has been shown to be harmful let's not keep doing it.

Eric
