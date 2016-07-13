From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH review 08/12] quota: Ensure qids map to the filesystem
Date: Wed, 13 Jul 2016 13:45:33 +1000
Message-ID: <20160713034532.GN1922@dastard>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
	<20160706181212.16267-1-ebiederm@xmission.com>
	<20160706181212.16267-8-ebiederm@xmission.com>
	<20160711101424.GH12410@quack2.suse.cz>
	<878tx8dowu.fsf@x220.int.ebiederm.org>
	<20160713013436.GM1922@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160713013436.GM1922@dastard>
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

On Wed, Jul 13, 2016 at 11:34:36AM +1000, Dave Chinner wrote:
> On Mon, Jul 11, 2016 at 01:12:49PM -0500, Eric W. Biederman wrote:
> > The place where I am concerned about thorough review and testing is
> > someone poisoning quota files and then the kernel trying to use them.
> > In the preliminary work we have done in other places in the kernel and
> > for other filesystems there almost always winds up being some way to
> > confuse the kernel and get it to misbave if you can poison the disk
> > based inputs.  As poison disk based inputs is not something filesystems
> > are stronlgy concerned about.  In most cases the disk the filesystem
> > resides on is in the box and therefore under control of the OS at all
> > times.  Dave Chinner has even said he will never consider handling
> > poisoned disk based inputs for XFS as the run time cost is too high.
> 
> I didn't say that. I said that comprehensive checks to catch all
> possible malicious inputs is too expensive to consider a viable
> solution for allowing user-mounts of arbitrary filesystem images
> through the kernel.
[.....]
> To bring this back to quota files, the only way to validate that a
> quota file has not been tampered with is to run a quotacheck on the
> filesystem once it has been mounted. This requires visiting every
> inode in the filesystem, so it an expensive operation. Only XFS has
> this functionality in kernel, so for untrusted mounts we could
> simply run it on every mount that has quotas enabled. Of course,
> users won't care that mounting their filesystem now takes several
> minutes (hours, even, when we have millions of inodes in the fs)
> while these checks are run...

So, over lunch I realised the problem with this. quotacheck is
verifying the contents of the quota file, but we haven't verified
the structure of the quota file to begin with. Hence just enabling
quotas could cause the filesystem to do bad things in the kernel on
mount if the quota file metadata has been tampered with.

IOWs, it's not just quota data parsing that we have to be concerned
with here - parsing the quota file structure itself could be an
attack vector that triggers on mount.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
