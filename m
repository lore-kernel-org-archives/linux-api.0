From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 28/33] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #11]
Date: Thu, 09 Aug 2018 10:32:37 -0500
Message-ID: <87in4jwo6i.fsf@xmission.com>
References: <87in4n9zg0.fsf@xmission.com>
        <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
        <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk>
        <27374.1533824694@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <27374.1533824694@warthog.procyon.org.uk> (David Howells's
        message of "Thu, 09 Aug 2018 15:24:54 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

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

All I really care about is that when you ask for a set of paramaters
that you get a filesystem with that set of parameters.  Not the same
filsystem mounted a different way.

That has gone wrong twice badly.  There is no common case I know of that
requires returning the same filesystem twice.  AKA the pain of the
existing semantics seems much much worse than any benefit.  So I am
asking that we not propagate the existing semantics into the new API.
You are cleaning up dealing with mount options and this is one of the
places where they need cleaning up.

> However, as I have said, I *am* willing to add one of more flags to help with
> this, but I can't make any "legacy" fs honour them as this requires the
> fs_context to be passed down to sget_fc() and the filesystem - which is why I
> was considering leaving it for later.
>
>  (1) An FSOPEN_EXCL flag to tell sget_fc() to fail if the superblock already
>      exists at all.
>
>  (2) An FSOPEN_FAIL_ON_MISMATCH flag to explicitly say that we *don't* want a
>      superblock with different parameters.
>
> The implication of providing neither flag is that we are happy to accept a
> superblock from the same source but with different parameters.
>
> But it doesn't seem to be an absolute imperative to roll this out immediately,
> since what I have exactly mirrors what the kernel currently does - and forcing
> a change in that behaviour risks breaking userspace.  If it keeps you happy,
> however, I can try and work one up.

What I am asking is that the default behavior for the new API when using
FSCONFIG_CMD_CREATE is to call sget_fc with either FSOPEN_EXCL or
FSOPEN_FAIL_ON_MISMATCH.  I know FSOPEN_EXCL is trivial to implement.  I
don't know if there are any hidden gotcha's with
FSOPEN_FAIL_ON_MISMATCH.

This change in default behavior for your patch needs to be implemented
before this hits a released kernel.  Returning a filesystem with
different than the requested parameters has resulted in at least two
major issues, that are very hard to clean up after the fact.  A chroot
system changing the parameters on /dev/pts resulting in some
distributions keeping the suid pt_chown binary long past it's best buy
date, and other distributions instead choosing to break userspace.  Then
there is the current issue where in practice proc does not any of it's
mount paramaters which breaks the android security model.

The fact that these things happen silently and you have to be on your
toes to catch them is fundamentally a bug in the API.  If the mount
request had simply failed people would have noticed the issues much
sooner and silently b0rkend configuration would not have propagated.  As
such I do not believe we should propagate this misfeature from the old
API into the new API.

Conceptually I like FSOPEN_FAIL_ON_MISMATH as it looks like it is
sufficient to the needs, and with a little luck we could even change
the old API to those semantics.


Ultimately I want to close a giant mental model mismatch.

User:  I am creating the data structures to read filesystem X
       with parameters Y.

Kernel: He wants filesystem X.  If it is a slow day use parameters Y.

Given that historically the reuse of a superblock did not exist, and
that in practice it almost never happens.  It is quite reqsonable for
users to not expect the kernel to completely ignore the mount parameters
they pass to the kernel.

So please let's fix that now when it is easy.

Eric
