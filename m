From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Fri, 8 May 2015 10:29:30 -0400
Message-ID: <21836.51274.843585.839614@quad.stoffel.home>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
	<20150507002617.GJ4327@dastard>
	<20150507172053.GA659@lenny.home.zabbo.net>
	<alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Cc: Zach Brown <zab@redhat.com>, Dave Chinner <david@fromorbit.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

>>>>> "Sage" == Sage Weil <sage@newdream.net> writes:

Sage> On Thu, 7 May 2015, Zach Brown wrote:
>> On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
>> > On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
>> > > The criteria for using O_NOMTIME is the same as for using O_NOATIME:
>> > > owning the file or having the CAP_FOWNER capability.  If we're not
>> > > comfortable allowing owners to prevent mtime/ctime updates then we
>> > > should add a tunable to allow O_NOMTIME.  Maybe a mount option?
>> > 
>> > I dislike "turn off safety for performance" options because Joe
>> > SpeedRacer will always select performance over safety.
>> 
>> Well, for ceph there's no safety concern.  They never use cmtime in
>> these files.
>> 
>> So are you suggesting not implementing this and making them rework their
>> IO paths to avoid the fs maintaining mtime so that we don't give Joe
>> Speedracer more rope?  Or are we talking about adding some speed bumps
>> that ceph can flip on that might give Joe Speedracer pause?

Sage> I think this is the fundamental question: who do we give the
Sage> ammunition to, the user or app writer, or the sysadmin?

Sage> One might argue that we gave the user a similar power with
Sage> O_NOATIME (the power to break applications that assume atime is
Sage> accurate).  Here we give developers/users the power to not
Sage> update mtime and suffer the consequences (like, obviously,
Sage> breaking mtime-based backups).  It should be pretty obvious to
Sage> anyone using the flag what the consequences are.

Not modifying atime doesn't really break anything except people who
think they can tell when a file was last accessed.  Which isn't
critical (unless your in a paranoid security conscious place...) but
MTIME is another beast entirely.   Turning that off is going to break
lots of hidden assumptions.  

Sage> Note that we can suffer similar lapses in mtime with fdatasync
Sage> followed by a system crash.  And as Andy points out it's
Sage> semi-broken for writable mmap.  The crash case is obviously a
Sage> slightly different thing, but the idea that mtime can't always
Sage> be trusted certainly isn't crazy talk.

True, but after a crash... people expect and understand there might be
corruption in a filesystem.  

Sage> Or, we can be conservative and require a mount option so that
Sage> the admin has to explicitly allow behavior that might break some
Sage> existing assumptions about mtime/ctime ('-o user_noatime' I
Sage> guess?).


Sage> I'm happy either way, so long as in the end an unprivileged ceph
Sage> daemon avoids the useless work.  In our case we always own the
Sage> entire mount/disk, so a mount option is just fine.

I agree with the mount option, makes it crystal clear.  And then it's
on the sysadmin/owner of the system to understand (ha!) the problems.

This is all me speaking with my Sysadmin hat firmly on my head.
