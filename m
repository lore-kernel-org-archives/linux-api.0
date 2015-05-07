From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Thu, 7 May 2015 10:20:53 -0700
Message-ID: <20150507172053.GA659@lenny.home.zabbo.net>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150507002617.GJ4327@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
> On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
> > Add the O_NOMTIME flag which prevents mtime from being updated which can
> > greatly reduce the IO overhead of writes to allocated and initialized
> > regions of files.
> 
> Hmmm. How do backup programs now work out if the file has changed
> and hence needs copying again? ie. applications using this will
> break other critical infrastructure in subtle ways.

By using backup infrastructure that doesn't use cmtime.  Like btrfs
send/recv.  Or application level backups that know how to do
incrementals from metadata in giant database files, say, without
walking, comparing, and copying the entire thing.

> > I opted not to name the flag O_NOCMTIME because I didn't want the name
> > to imply that ctime updates would be prevented for other inode changes
> > like updating i_size in truncate.  Not updating ctime is a side-effect
> > of removing mtime updates when it's the only thing changing in the
> > inode.
> 
> If adding this, wouldn't we want to unify O_NOMTIME and
> FMODE_NOCMTIME at the same time?

I could see that, sure.

> > The criteria for using O_NOMTIME is the same as for using O_NOATIME:
> > owning the file or having the CAP_FOWNER capability.  If we're not
> > comfortable allowing owners to prevent mtime/ctime updates then we
> > should add a tunable to allow O_NOMTIME.  Maybe a mount option?
> 
> I dislike "turn off safety for performance" options because Joe
> SpeedRacer will always select performance over safety.

Well, for ceph there's no safety concern.  They never use cmtime in
these files.

So are you suggesting not implementing this and making them rework their
IO paths to avoid the fs maintaining mtime so that we don't give Joe
Speedracer more rope?  Or are we talking about adding some speed bumps
that ceph can flip on that might give Joe Speedracer pause?

- z
