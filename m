From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH review 08/12] quota: Ensure qids map to the filesystem
Date: Wed, 13 Jul 2016 11:34:36 +1000
Message-ID: <20160713013436.GM1922@dastard>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
	<20160706181212.16267-1-ebiederm@xmission.com>
	<20160706181212.16267-8-ebiederm@xmission.com>
	<20160711101424.GH12410@quack2.suse.cz>
	<878tx8dowu.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <878tx8dowu.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 11, 2016 at 01:12:49PM -0500, Eric W. Biederman wrote:
> The place where I am concerned about thorough review and testing is
> someone poisoning quota files and then the kernel trying to use them.
> In the preliminary work we have done in other places in the kernel and
> for other filesystems there almost always winds up being some way to
> confuse the kernel and get it to misbave if you can poison the disk
> based inputs.  As poison disk based inputs is not something filesystems
> are stronlgy concerned about.  In most cases the disk the filesystem
> resides on is in the box and therefore under control of the OS at all
> times.  Dave Chinner has even said he will never consider handling
> poisoned disk based inputs for XFS as the run time cost is too high.

I didn't say that. I said that comprehensive checks to catch all
possible malicious inputs is too expensive to consider a viable
solution for allowing user-mounts of arbitrary filesystem images
through the kernel.

We already have runtime validation that bounds check most on-disk
fields when they are read - that deals with fuzz based poisoning
testing quite well and provides some protection against directed
structural attacks as well. IOWs, we already handle a large scope of
poisoned inputs safely, but it's not comprehensive because we can't
easily determine cross-object reference validity within the
format-determined limits.

e.g. we can check that the number of records in a btree block is
within the valid bounds of a block, but we cannot determine that the
record count has been incremented by 1 and a bogus record has been
inserted somewhere inside the block and the CRC recalculated to
match the modification. We can also check the records themselves for
being within bound (e.g. we can check a freespace record points to
block within range and of valid length) but we can't check that the
extent is actually free space. That requires doing a full filesystem
traversal to determine if the extent is actually free space or not.

Of course, we could look up the rmap tree (if we have one) to
determine if the space is actually used or not, but an attacker can
also insert/remove records in that tree, too, so if we can't trust
the free space tree, we can't trust the rmap tree either.
Hence we have to fall back to brute force validation if we
want to be certain that the metadata has not been tampered with.

To bring this back to quota files, the only way to validate that a
quota file has not been tampered with is to run a quotacheck on the
filesystem once it has been mounted. This requires visiting every
inode in the filesystem, so it an expensive operation. Only XFS has
this functionality in kernel, so for untrusted mounts we could
simply run it on every mount that has quotas enabled. Of course,
users won't care that mounting their filesystem now takes several
minutes (hours, even, when we have millions of inodes in the fs)
while these checks are run...

Detecting malicious corruptions that specifically manipulate the
on-disk structure within the bounds of format validity are difficult
to detect and costly to protect against. We'd need to move large
parts of fsck into the kernel and run it to validate every piece of
metadata read into the kernel. Then we've got a much larger attack
surface in the kernel (all the validity checking code needs to be
robust against invalid structures, too!), a lot more complexity
(more bugs!) and a lot of additional runtime overhead (slow
filesystem = unhappy users!). It's just not a practical solution to
the problem.

> Between actually finding issues that can cause problems, and the
> increased amount of kernel code executed (and thus the increase in
> kernel attack surface) I am very paranoid about enabling code that
> trusts data that could be poisoned data from a hostile party.
>
> At the same time I am very uncomfortable with the fact the kernel does
> not protect against malicious disks and poisoned disk images.  As
> poisoned disk images are a well known exploit vector in the wild.  A
> well known and demonstrated attack vector that works is to leave a usb
> stick in a public place, and helpful people will place it into their
> computer to try and figure out who it belongs to.  In trying to be
> helpful their computer will unbeknownst to them start executing code
> that does not serve the interests of the computer owner.  I hate that we
> can not currently protect people from shenanigans like that.

Yes, we know all about these problems. Unfortunately someone
appears to not be listening when they being repeatedly told that
hardening all the kernel filesystem implementations against poisoned
images is simply not a viable solution to the problem.

Move the parsing of untrusted structures out of the kernel - work
with the various filesystem teams to build viable FUSE
implementations (where it's much easier to incorporate parts of the
userspace fsck code) and provide the FUSE filesystems to container
users wanting to mount their own filesystem images.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
