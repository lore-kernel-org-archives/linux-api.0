From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 28/33] vfs: syscall: Add fsconfig() for configuring and
 managing a context [ver #11]
Date: Thu, 9 Aug 2018 16:35:01 +0200
Message-ID: <CAJfpegvWE9htLjqeR6=2BWBSuvJzJpWcjBC_EmX_k1RCGXTfbw@mail.gmail.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk>
 <87in4n9zg0.fsf@xmission.com> <27374.1533824694@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <27374.1533824694@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 9, 2018 at 4:24 PM, David Howells <dhowells@redhat.com> wrote:
> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> First let me thank you for adding both FSCONFIG_CMD_CREATE and
>> FSCONFIG_CMD_RECONFIGURE.  Unfortunately the implementation is currently
>> broken.  So this patch gets my:
>>
>> This is broken in two specific ways.
>> ...
>> 2) FSCONFIG_CMD_CREATE will succeed even if the superblock already
>>    exists and it can not use all of the superblock parameters.
>>
>>    This happens because vfs_get_super will only call fill_super
>>    if the super block is created.  Which is reasonable on the face
>>    of it.  But it in practice this introduces security problems.
>>
>>    a) Either through reconfiguring a shared super block you did not
>>       realize was shared (as we saw with devpts).
>>
>>    b) Mounting a super block and not honoring it's mount options
>>       because something has already mounted it.  As we see today
>>       with proc.  Leaving userspace to think the filesystem will behave
>>       one way when in fact it behaves another.
>>
>> I have already explained this several times, and apparently I have been
>> ignored.  This fundamental usability issue that leads to security
>> problems.
>
> I've also explained why you're wrong or at least only partially right.  I *do*
> *not* want to implement sget() in userspace with the ability for userspace to
> lock out other mount requests - which is what it appears that you've been
> asking for.
>
> However, as I have said, I *am* willing to add one of more flags to help with
> this, but I can't make any "legacy" fs honour them as this requires the
> fs_context to be passed down to sget_fc() and the filesystem - which is why I
> was considering leaving it for later.

You can determine at fsopen() time whether the filesystem is able to
support the O_EXCL behavior?  If so, then it's trivial to enable this
conditionally.  I think that's what Eric is asking for, it's obviously
not fair to ask for a change in behavior of the legacy interface.

Thanks,
Miklos
