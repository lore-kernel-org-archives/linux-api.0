From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 23:43:20 -0500
Message-ID: <87mutto6mv.fsf@xmission.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
        <87d0uqpba5.fsf@xmission.com>
        <20180810151606.GA6515@ZenIV.linux.org.uk>
        <87pnypiufr.fsf@xmission.com>
        <20180811015815.GD6515@ZenIV.linux.org.uk>
        <20180811021704.GE6515@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180811021704.GE6515@ZenIV.linux.org.uk> (Al Viro's message of
        "Sat, 11 Aug 2018 03:17:04 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>, Miklos
List-Id: linux-api@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Aug 11, 2018 at 02:58:15AM +0100, Al Viro wrote:
>> On Fri, Aug 10, 2018 at 08:05:44PM -0500, Eric W. Biederman wrote:
>> 
>> > All I proposed was that we distinguish between a first mount and an
>> > additional mount so that userspace knows the options will be ignored.
>> 
>> For pity sake, just what does it take to explain to you that your
>> notions of "first mount" and "additional mount" ARE HEAVILY FS-DEPENDENT
>> and may depend upon the pieces of state userland (especially in container)
>> simply does not have?
>> 
>> One more time, slowly:
>> 
>> mount -t nfs4 wank.example.org:/foo/bar /mnt/a
>> mount -t nfs4 wank.example.org:/baz/barf /mnt/b
>> 
>> yield the same superblock.  Is anyone who mounts something over NFS
>> required to know if anybody else has mounted something from the same
>> server, and if so how the hell are they supposed to find that out,
>> so that they could decide whether they are creating the "first" or
>> "additional" mount, whatever that might mean in this situation?
>> 
>> And how, kernel-side, is that supposed to be handled by generic code
>> of any description?  
>> 
>> While we are at it,
>> mount -t nfs4 wank.example.org:/foo/bar -o wsize=16384 /mnt/c
>> is *NOT* the same superblock as the previous two.
>
> s/as the previous two/as in the previous two cases/, that is - the first two
> examples yield one superblock, this one - another.

Exactly because the mount options differ.

I don't have a problem if we have something sophisticated like nfs that
handles all of the hairy details and does not reuse a superblock unless the
mount options match.

What I have a problem with is the helper for ordinary filesystems that
are not as sophisticated as nfs that don't handle all of the option
magic and give userspace something different from what userspace asked
for.

It may take a little generalization of the definitions I proposed but it
still remains simple and straight forward.

CMD_THESE_MOUNT_OPTIONS_NO_SURPRISES
CMD_WHATEVER_ALREADY_EXISTS

Or we can make the filesystems more sophisticated when we move
them to the new API and perform the comparisons there.  I think
that is what David Howells is working on.

Eric
