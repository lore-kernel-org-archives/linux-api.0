From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Thu, 7 May 2015 10:26:17 +1000
Message-ID: <20150507002617.GJ4327@dastard>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430949612-21356-1-git-send-email-zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
> Add the O_NOMTIME flag which prevents mtime from being updated which can
> greatly reduce the IO overhead of writes to allocated and initialized
> regions of files.

Hmmm. How do backup programs now work out if the file has changed
and hence needs copying again? ie. applications using this will
break other critical infrastructure in subtle ways.

> ceph servers can have loads where they perform O_DIRECT overwrites of
> allocated file data and then sync to make sure that the O_DIRECT writes
> are flushed from write caches.  If the writes dirty the inode with mtime
> updates then the syncs also write out the metadata needed to track the
> inodes which can add significant iop and latency overhead.
> 
> The ceph servers don't use mtime at all.  They're using the local file
> system as a backing store and any backups would be driven by their upper
> level ceph metadata.  For ceph, slow IO from mtime updates in the file
> system is as daft as if we had block devices slowing down IO for
> per-block write timestamps that file systems never use.
> 
> In simple tests a O_DIRECT|O_NOMTIME overwriting write followed by a
> sync went from 2 serial write round trips to 1 in XFS and from 4 serial
> IO round trips to 1 in ext4.
> 
> file_update_time() checks for O_NOMTIME and aborts the update if it's
> set, just like the current check for the in-kernel inode flag
> S_NOCMTIME.  I didn't update any other mtime update sites. They could be
> added as we decide that it's appropriate to do so.
> 
> I opted not to name the flag O_NOCMTIME because I didn't want the name
> to imply that ctime updates would be prevented for other inode changes
> like updating i_size in truncate.  Not updating ctime is a side-effect
> of removing mtime updates when it's the only thing changing in the
> inode.

If adding this, wouldn't we want to unify O_NOMTIME and
FMODE_NOCMTIME at the same time?

i.e. it makes no sense to add O_NOMTIME and not add O_NOCMTIME,
likewise it makes no sense to have two different "no mtime"
detection mechanisms.  i.e. file_is_nomtime(file)) should return
true for both files opened with O_NOMTIME, files that have had
FMODE_NOCMTIME added to them and inodes with the S_NOCMTIME flag
set on them.

> The criteria for using O_NOMTIME is the same as for using O_NOATIME:
> owning the file or having the CAP_FOWNER capability.  If we're not
> comfortable allowing owners to prevent mtime/ctime updates then we
> should add a tunable to allow O_NOMTIME.  Maybe a mount option?

I dislike "turn off safety for performance" options because Joe
SpeedRacer will always select performance over safety.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
