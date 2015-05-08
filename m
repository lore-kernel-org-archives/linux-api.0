From: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Fri, 8 May 2015 15:24:11 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
References: <1430949612-21356-1-git-send-email-zab@redhat.com> <20150507002617.GJ4327@dastard> <20150507172053.GA659@lenny.home.zabbo.net> <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net> <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150508221325.GM4327@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, 9 May 2015, Dave Chinner wrote:
> On Thu, May 07, 2015 at 09:23:24PM -0400, Trond Myklebust wrote:
> > On Thu, May 7, 2015 at 9:01 PM, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> wrote:
> > > On Thu, 7 May 2015, Zach Brown wrote:
> > >> On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
> > >> > On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
> > >> > > The criteria for using O_NOMTIME is the same as for using O_NOATIME:
> > >> > > owning the file or having the CAP_FOWNER capability.  If we're not
> > >> > > comfortable allowing owners to prevent mtime/ctime updates then we
> > >> > > should add a tunable to allow O_NOMTIME.  Maybe a mount option?
> > >> >
> > >> > I dislike "turn off safety for performance" options because Joe
> > >> > SpeedRacer will always select performance over safety.
> > >>
> > >> Well, for ceph there's no safety concern.  They never use cmtime in
> > >> these files.
> > >>
> > >> So are you suggesting not implementing this and making them rework their
> > >> IO paths to avoid the fs maintaining mtime so that we don't give Joe
> > >> Speedracer more rope?  Or are we talking about adding some speed bumps
> > >> that ceph can flip on that might give Joe Speedracer pause?
> > >
> > > I think this is the fundamental question: who do we give the ammunition
> > > to, the user or app writer, or the sysadmin?
> > >
> > > One might argue that we gave the user a similar power with O_NOATIME (the
> > > power to break applications that assume atime is accurate).  Here we give
> > > developers/users the power to not update mtime and suffer the consequences
> > > (like, obviously, breaking mtime-based backups).  It should be pretty
> > > obvious to anyone using the flag what the consequences are.
> > >
> > > Note that we can suffer similar lapses in mtime with fdatasync followed by
> > > a system crash.  And as Andy points out it's semi-broken for writable
> > > mmap.  The crash case is obviously a slightly different thing, but the
> > > idea that mtime can't always be trusted certainly isn't crazy talk.
> > >
> > > Or, we can be conservative and require a mount option so that the admin
> > > has to explicitly allow behavior that might break some existing
> > > assumptions about mtime/ctime ('-o user_noatime' I guess?).
> > >
> > > I'm happy either way, so long as in the end an unprivileged ceph daemon
> > > avoids the useless work.  In our case we always own the entire mount/disk,
> > > so a mount option is just fine.
> > >
> > 
> > So, what is the expectation here for filesystems that cannot support
> > this flag? NFSv3 in particular would break pretty catastrophically if
> > someone decided on a whim to turn off mtime: they will have turned off
> > the client's ability to detect cache incoherencies.
> 
> It's worse than that, now that I think about it. I think nomtime
> will break nfsv4 as the I_VERSION check is done *after* the
> NO[C]MTIME checks. e.g. the atomic change count used to detect file
> changes is only updated during the mtime update on write() calls in
> XFS. i.e. when the timestamp is changed, a transaction to change
> mtime is run, and that transaction commit bumps the change count.
> 
> So cutting out mtime updates at the VFS will prevent XFS and other
> I_VERSION aware filesystems from updating the change count that
> NFSv4 clients rely on to detect foreign data changes in a file.
> 
> Not sure what to do here, because the current NOCMTIME
> implementation intentionally cuts out the timestamp update because
> it's usage is fully invisible IO. i.e. it is used by utilities like
> xfs_fsr and HSMs to move data into and out of files without the
> application being able to detect the data movement in any way. These
> are not data modification operations, though - the file contents as
> read by the application do not change despite the fact we are moving
> data in and out of the file. In this case we don't want timestamps
> or change counters to change on the data movement, so I think we've
> actually got a difference in behaviour here between O_NOMTIME and
> O_NOCMTIME, right?
> 
> i.e. for nfsv4 sanity O_NOMTIME still needs to bump I_VERSION on
> write, just not modify the timestamp? In which case, not modifying
> the timestamps gains us nothing, because the inode is still dirtied?

Right: if we dirty the inode we've defeated the purpose of the patch.

> The list of caveats on O_NOMTIME seems to be growing...

...and remain consistent with our goals.  We couldn't care less if NFS or 
backup software or anything else doesn't notice these changes.  This is 
private data that is wholly managed by the ceph daemon.  The goal is to 
derive *some* value from the file system and avoid reimplementing it in 
userspace (without the bits we don't need).

I'm sure you realize what we're try to achieve is the same "invisible IO" 
that the XFS open by handle ioctls do by default.  Would you be more 
comfortable if this option where only available to the generic 
open_by_handle syscall, and not to open(2)?

sage
