From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Fri, 8 May 2015 10:11:15 -0700
Message-ID: <20150508171115.GA13050@lenny.home.zabbo.net>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
 <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1505071752520.28239-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, May 07, 2015 at 06:01:23PM -0700, Sage Weil wrote:
> On Thu, 7 May 2015, Zach Brown wrote:
> > On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
> > > On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
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
> > 
> > So are you suggesting not implementing this and making them rework their
> > IO paths to avoid the fs maintaining mtime so that we don't give Joe
> > Speedracer more rope?  Or are we talking about adding some speed bumps
> > that ceph can flip on that might give Joe Speedracer pause?
> 
> I think this is the fundamental question: who do we give the ammunition 
> to, the user or app writer, or the sysadmin?

Yeah, I think this is right.  Dave doesn't want the possibility of it
bleeding in to installations through irresponsible default use in apps
without explicit buy-in from the people responsible for the backups.

> [...]
> 
> Or, we can be conservative and require a mount option so that the admin 
> has to explicitly allow behavior that might break some existing 
> assumptions about mtime/ctime ('-o user_noatime' I guess?).
> 
> I'm happy either way, so long as in the end an unprivileged ceph daemon 
> avoids the useless work.  In our case we always own the entire mount/disk, 
> so a mount option is just fine.

It seems that the thread has headed towards responding to my suggestion
of a possible mount option with an enthusiastic "yes, please, no
surprises."

So I'll try that.

- z
