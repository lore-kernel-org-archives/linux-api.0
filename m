From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 00/34] VFS: Introduce filesystem context [ver #12]
Date: Thu, 04 Oct 2018 20:37:09 +0200
Message-ID: <87sh1ld0dm.fsf@xmission.com>
References: <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
        (David Howells's message of "Fri, 21 Sep 2018 17:30:08 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@redhat.com>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org


David,

I have been going through these and it is a wonderful proof of concept
patchset.  There are a couple significant problems with it however.

- Many patches do more than one thing that could benefit from being
  broken up into more patches so that there is only one logical change
  per patch.  I have attempted a little of that and have found several
  significant bugs.

- There are many unnecessary changes in this patchset that just add
  noise and make it difficult to review.

- There are many typos and thinkos in this patchset that while not hard
  to correct keep this from being anywhere close to being ready for
  prime time.

- Some of the bugs I have encountered.
  * proc that isn't pid_ns_prepare_proc does not set fc->user_ns to
    match the pid namespace.
  * mqueue does not set fc->user_ns to match the ipc namespace.
  * The cpuset filesystem always fails to mount
  * Non-converted filesystems don't have the old security hooks
    and only have a bit blob so don't call into the new security
    hooks either.
  * The changes to implement the new security hooks at least for
    selinux are riddled with typos, and thinkos.

I was hoping to get into the semantic questions but I can't get
there until I get a good solid baseline patch to work with.

I have been able to hoist the permission check out of sget_fc for
converted filesystems.  So progress is being made.  That absolutely
requires fc->user_ns to be set properly before vfs_get_tree.  Something
that still needs to be fixed.

I have also observed that by not allowing unconverted filesystems
to mount using the new api.  The compatbitility code can be
significantly simplified, and the who data_size problem goes away.

I am going to be travelling for the next couple of days so I
don't expect I will be able to answer questions in a timely manner.
In the hopes that it might help below is my work in progress git
tree where I have cleaned up some of these issues.

https://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git new-mount-api-testing

Eric
