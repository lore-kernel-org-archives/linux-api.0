From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH review 08/12] quota: Ensure qids map to the filesystem
Date: Thu, 14 Jul 2016 12:03:19 -0500
Message-ID: <87oa60cfu0.fsf@x220.int.ebiederm.org>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
	<20160706181212.16267-1-ebiederm@xmission.com>
	<20160706181212.16267-8-ebiederm@xmission.com>
	<20160711101424.GH12410@quack2.suse.cz>
	<878tx8dowu.fsf@x220.int.ebiederm.org> <20160713013436.GM1922@dastard>
	<20160713054358.GB28635@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160713054358.GB28635@pc.thejh.net> (Jann Horn's message of
	"Wed, 13 Jul 2016 07:43:59 +0200")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jann Horn <jann@thejh.net>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Linux Containers <containers@lists.linux-foundation.org>, Seth Forshee <seth.forshee@canonical.com>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Jann Horn <jann@thejh.net> writes:

> On Wed, Jul 13, 2016 at 11:34:36AM +1000, Dave Chinner wrote:
>> On Mon, Jul 11, 2016 at 01:12:49PM -0500, Eric W. Biederman wrote:
>> > The place where I am concerned about thorough review and testing is
>> > someone poisoning quota files and then the kernel trying to use them.
>> > In the preliminary work we have done in other places in the kernel and
>> > for other filesystems there almost always winds up being some way to
>> > confuse the kernel and get it to misbave if you can poison the disk
>> > based inputs.  As poison disk based inputs is not something filesystems
>> > are stronlgy concerned about.  In most cases the disk the filesystem
>> > resides on is in the box and therefore under control of the OS at all
>> > times.  Dave Chinner has even said he will never consider handling
>> > poisoned disk based inputs for XFS as the run time cost is too high.
>> 
>> I didn't say that. I said that comprehensive checks to catch all
>> possible malicious inputs is too expensive to consider a viable
>> solution for allowing user-mounts of arbitrary filesystem images
>> through the kernel.

Dave you said that speaking as the XFS maintainer.  So I take that to be
your position and to refer to XFS.

> [...]
>> 
>> To bring this back to quota files, the only way to validate that a
>> quota file has not been tampered with is to run a quotacheck on the
>> filesystem once it has been mounted. This requires visiting every
>> inode in the filesystem, so it an expensive operation. Only XFS has
>> this functionality in kernel, so for untrusted mounts we could
>> simply run it on every mount that has quotas enabled. Of course,
>> users won't care that mounting their filesystem now takes several
>> minutes (hours, even, when we have millions of inodes in the fs)
>> while these checks are run...
>>
>> Detecting malicious corruptions that specifically manipulate the
>> on-disk structure within the bounds of format validity are difficult
>> to detect and costly to protect against. We'd need to move large
>> parts of fsck into the kernel and run it to validate every piece of
>> metadata read into the kernel. Then we've got a much larger attack
>> surface in the kernel (all the validity checking code needs to be
>> robust against invalid structures, too!), a lot more complexity
>> (more bugs!) and a lot of additional runtime overhead (slow
>> filesystem = unhappy users!). It's just not a practical solution to
>> the problem.

This critiqute as I read it confuses data integrity and safety from
privilege escalation.  If a filesystem image or it's backing store are
malicious there is no need to be concerned about data integrity.

> And ideally, you'd want to also guard against an evil disk that
> suddenly changes its contents after you've run fsck on it, and you
> can't easily do that without making things complicated.

I agree an evil disk definitely should be part of any threat analysis.

I also agree that anything that is complicated is not a practical
as complicated means lots of code, and bugs are in general a function
of the amount of code.

At the same time my only concern when analyzing something for safety
against a malicious filesystem is can the malicious data cause the
kernel to misbehave.  This includes things like stack overflows,
and memory corruption.

In the specific case of a quota file, if there is a quota file that has
little to no resemblence to reality but the kernel doesn't misbehave, I
don't think that is a problem from an unprivileged mount perspective.
On the flip side if a malicious quota file allows an in kernel quota
variable to go negative and that causes the kernel to misbehave that is
a show stopper for allowing an unprivileged mount.

Personally I see the quantity of code in current filesystems as making
it hard to have a low enough probability of problems to allow
unprivileged mounts.

Changes for all of the weird cases a backing store for unprivileged
mounts brings with it have been added to the VFS because that is the
right place to implement them.  Working at a filesystem independent
level allows all of the right people involved in the review, and it
allows clean and general solutions to the weird cases that come up
with a uid or gid does not map into the kernel.


All of that said the only filesystem with backing store that I see as a
reasonable target to support right now is fuse.  As fuse was designed
from the get go to support filesystems from unprivileged users.

Will fuse someday support quotas?  I don't know.  But the there is no
extra cost to support that case in fs/quota/quota.c so I have added the
necessary code.

Eric

