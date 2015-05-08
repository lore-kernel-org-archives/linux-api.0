From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Fri, 8 May 2015 08:19:58 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1505080814521.28239@cobra.newdream.net>
References: <1430949612-21356-1-git-send-email-zab@redhat.com> <20150507002617.GJ4327@dastard> <20150507172053.GA659@lenny.home.zabbo.net> <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
 <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Zach Brown <zab@redhat.com>, Dave Chinner <david@fromorbit.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 7 May 2015, Trond Myklebust wrote:
> On Thu, May 7, 2015 at 9:01 PM, Sage Weil <sage@newdream.net> wrote:
> > On Thu, 7 May 2015, Zach Brown wrote:
> >> On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
> >> > On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
> >> > > The criteria for using O_NOMTIME is the same as for using O_NOATIME:
> >> > > owning the file or having the CAP_FOWNER capability.  If we're not
> >> > > comfortable allowing owners to prevent mtime/ctime updates then we
> >> > > should add a tunable to allow O_NOMTIME.  Maybe a mount option?
> >> >
> >> > I dislike "turn off safety for performance" options because Joe
> >> > SpeedRacer will always select performance over safety.
> >>
> >> Well, for ceph there's no safety concern.  They never use cmtime in
> >> these files.
> >>
> >> So are you suggesting not implementing this and making them rework their
> >> IO paths to avoid the fs maintaining mtime so that we don't give Joe
> >> Speedracer more rope?  Or are we talking about adding some speed bumps
> >> that ceph can flip on that might give Joe Speedracer pause?
> >
> > I think this is the fundamental question: who do we give the ammunition
> > to, the user or app writer, or the sysadmin?
> >
> > One might argue that we gave the user a similar power with O_NOATIME (the
> > power to break applications that assume atime is accurate).  Here we give
> > developers/users the power to not update mtime and suffer the consequences
> > (like, obviously, breaking mtime-based backups).  It should be pretty
> > obvious to anyone using the flag what the consequences are.
> >
> > Note that we can suffer similar lapses in mtime with fdatasync followed by
> > a system crash.  And as Andy points out it's semi-broken for writable
> > mmap.  The crash case is obviously a slightly different thing, but the
> > idea that mtime can't always be trusted certainly isn't crazy talk.
> >
> > Or, we can be conservative and require a mount option so that the admin
> > has to explicitly allow behavior that might break some existing
> > assumptions about mtime/ctime ('-o user_noatime' I guess?).
> >
> > I'm happy either way, so long as in the end an unprivileged ceph daemon
> > avoids the useless work.  In our case we always own the entire mount/disk,
> > so a mount option is just fine.
> >
> 
> So, what is the expectation here for filesystems that cannot support
> this flag? NFSv3 in particular would break pretty catastrophically if
> someone decided on a whim to turn off mtime: they will have turned off
> the client's ability to detect cache incoherencies.

Is this based on mtime or ctime?  If the former, would things could also 
break if a user does, say, some stat(2), write(2), utimes(2) shenanigans?

So, my assumption is that if the mount option isn't there allowing this 
then O_NOMTIME would be a no-op (as opposed to EPERM or something)... but 
maybe that's not the right thing to do.  Whatever we do there, though, I 
suppose NFS would do the same thing?

sage
