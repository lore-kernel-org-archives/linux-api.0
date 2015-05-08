From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Thu, 7 May 2015 20:24:49 -0700
Message-ID: <CALCETrUksu5ZB4QBfC8DMwYO2OFjfPW2eWsTweZGN_gybzcsmw@mail.gmail.com>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard> <20150507172053.GA659@lenny.home.zabbo.net> <20150508023711.GK4327@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150508023711.GK4327@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On May 8, 2015 8:11 AM, "Dave Chinner" <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>
> On Thu, May 07, 2015 at 10:20:53AM -0700, Zach Brown wrote:
> > On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
> > > On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
> > > > Add the O_NOMTIME flag which prevents mtime from being updated which can
> > > > greatly reduce the IO overhead of writes to allocated and initialized
> > > > regions of files.
> > >
> > > Hmmm. How do backup programs now work out if the file has changed
> > > and hence needs copying again? ie. applications using this will
> > > break other critical infrastructure in subtle ways.
> >
> > By using backup infrastructure that doesn't use cmtime.  Like btrfs
> > send/recv.  Or application level backups that know how to do
> > incrementals from metadata in giant database files, say, without
> > walking, comparing, and copying the entire thing.
>
> "Use magical thing that doesn't exist"? Really?
>
> e.g. you can't do incremental backups with tools like xfsdump if
> mtime is not being updated.  The last thing an admin wants when
> doing disaster recovery is to find out that the app started using
> O_NOMTIME as a result of the upgrade they did 6 months ago. Hence
> the last 6 months of production data isn't in the backups despite
> the backup procedure having been extensively tested and verified
> when it was first put in place.
>
> > > > The criteria for using O_NOMTIME is the same as for using O_NOATIME:
> > > > owning the file or having the CAP_FOWNER capability.  If we're not
> > > > comfortable allowing owners to prevent mtime/ctime updates then we
> > > > should add a tunable to allow O_NOMTIME.  Maybe a mount option?
> > >
> > > I dislike "turn off safety for performance" options because Joe
> > > SpeedRacer will always select performance over safety.
> >
> > Well, for ceph there's no safety concern.  They never use cmtime in
> > these files.
>
> Understood.
>
> > So are you suggesting not implementing this
>
> No.
>
> > Or are we talking about adding some speed bumps
> > that ceph can flip on that might give Joe Speedracer pause?
>
> Yes, but not just Joe Speedracer - if it can be turned on silently
> by apps then it's a great big landmine that most users and sysadmins
> will not know about until it is too late.

What about programs like tar that explicitly override mtime?  No admin
buy-in is required for that.  Admittedly, that doesn't affect ctime,
nor is it as likely to bite unexpectedly as a nomtime flag.

I think it would be reasonably safe if a mount option had to be set to
allow O_NOCMTIME or such.

--Andy

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
