From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: BUG: Mount ignores mount options
Date: Sat, 11 Aug 2018 02:58:15 +0100
Message-ID: <20180811015815.GD6515@ZenIV.linux.org.uk>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <87d0uqpba5.fsf@xmission.com>
 <20180810151606.GA6515@ZenIV.linux.org.uk>
 <87pnypiufr.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87pnypiufr.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>, Miklos
List-Id: linux-api@vger.kernel.org

On Fri, Aug 10, 2018 at 08:05:44PM -0500, Eric W. Biederman wrote:

> All I proposed was that we distinguish between a first mount and an
> additional mount so that userspace knows the options will be ignored.

For pity sake, just what does it take to explain to you that your
notions of "first mount" and "additional mount" ARE HEAVILY FS-DEPENDENT
and may depend upon the pieces of state userland (especially in container)
simply does not have?

One more time, slowly:

mount -t nfs4 wank.example.org:/foo/bar /mnt/a
mount -t nfs4 wank.example.org:/baz/barf /mnt/b

yield the same superblock.  Is anyone who mounts something over NFS
required to know if anybody else has mounted something from the same
server, and if so how the hell are they supposed to find that out,
so that they could decide whether they are creating the "first" or
"additional" mount, whatever that might mean in this situation?

And how, kernel-side, is that supposed to be handled by generic code
of any description?  

While we are at it,
mount -t nfs4 wank.example.org:/foo/bar -o wsize=16384 /mnt/c
is *NOT* the same superblock as the previous two.

> I don't know how the above wound up being construed as asking that the
> code call sget directly but that is what has happened.

Not by me.  What I'm saying is that the entire superblock-creating
machinery - all of it - is nothing but library helpers.  With the
decision of when/how/if they are to be used being down to filesystem
driver.  Your "first mount"/"additional mount" simply do not map
to anything universally applicable.

> > Having something like a second callback for mount_bdev() that would
> > be called when we'd found an existing instance for the same block
> > device?  Sure, no problem.  Having a helper for doing such comparison
> > that would work in enough cases to bother, so that different fs
> > could avoid boilerplate in that callback?  Again, more power to you.
> 
> Normal forms etc.  If we want to do that it just requires a wee bit of
> discipline.  And if all of the option parsing is being rewritten and
> retested anyway I don't see why we can't do something like that as well.
> So it does not sound unreasonable to me.

See above.
