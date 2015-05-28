From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe
 as bind mounts (take 2)
Date: Thu, 28 May 2015 16:52:14 -0500
Message-ID: <20150528215214.GA15675@mail.hallyn.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
 <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87wq004im1.fsf@x220.int.ebiederm.org>
 <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
 <20150528140839.GD28842@ubuntumail>
 <87lhg8pwvz.fsf@x220.int.ebiederm.org>
 <20150528210438.GA14849@mail.hallyn.com>
 <871ti0fkfp.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871ti0fkfp.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Seth Forshee <seth.forshee@canonical.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 28, 2015 at 04:42:34PM -0500, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > On Thu, May 28, 2015 at 10:03:28AM -0500, Eric W. Biederman wrote:
> >> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> >> 
> >> > Quoting Andy Lutomirski (luto@amacapital.net):
> >> >> On Fri, May 22, 2015 at 10:39 AM, Eric W. Biederman
> >> >> <ebiederm@xmission.com> wrote:
> >> >> > I had hoped to get some Tested-By's on that patch series.
> >> >> 
> >> >> Sorry, I've been totally swamped.
> >> >> 
> >> >> I suspect that Sandstorm is okay, but I haven't had a chance to test
> >> >> it for real.  Sandstorm makes only limited use of proc and sysfs in
> >> >> containers, but I'll see if I can test it for real this weekend.
> >> >
> >> > Testing this with unprivileged containers, I get
> >> >
> >> > lxc-start: conf.c: lxc_mount_auto_mounts: 808 Operation not permitted
> >> > - error mounting sysfs on
> >> > /usr/lib/x86_64-linux-gnu/lxc/sys/devices/virtual/net flags 0
> >> 
> >> Grr..  I was afraid this would break something. :(
> >> 
> >> Looking at my system I see that sysfs is currently mounted
> >> "nosuid,nodev,noexec"
> >> 
> >> Looking at the lxc-start code I don't see it as including any of those
> >> mount options.  In practice for sysfs I think those options are
> >> meaningless (as there should be no devices and nothing executable in
> >> sysfs) but I can understand the past concerns with chmod on virtual
> >> filesystems that would incline people to use them, so I think the
> >> failure is reporting a legitimate security issue in the lxc userspace
> >> code where the the unprivileged code is currently attempting to give
> >> greater access to sysfs than was given by the original mount of sysfs.
> >> 
> >> As nosuid,nodev,noexec should not impair the operation of sysfs
> >> operation it looks like you can always specify those options and just
> >> make this concern go away.
> >> 
> >> Something like the untested patch below I expect.
> >> 
> >> diff --git a/src/lxc/conf.c b/src/lxc/conf.c
> >> index 9870455b3cae..d9ccd03afe68 100644
> >> --- a/src/lxc/conf.c
> >> +++ b/src/lxc/conf.c
> >> @@ -770,8 +770,8 @@ static int lxc_mount_auto_mounts(struct lxc_conf *conf, int flags, struct lxc_ha
> >>  		{ LXC_AUTO_PROC_MASK, LXC_AUTO_PROC_MIXED, "%r/proc/sysrq-trigger",                             "%r/proc/sysrq-trigger",        NULL,       MS_BIND,                        NULL },
> >>  		{ LXC_AUTO_PROC_MASK, LXC_AUTO_PROC_MIXED, NULL,                                                "%r/proc/sysrq-trigger",        NULL,       MS_REMOUNT|MS_BIND|MS_RDONLY,   NULL },
> >>  		{ LXC_AUTO_PROC_MASK, LXC_AUTO_PROC_RW,    "proc",                                              "%r/proc",                      "proc",     MS_NODEV|MS_NOEXEC|MS_NOSUID,   NULL },
> >> -		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_RW,     "sysfs",                                             "%r/sys",                       "sysfs",    0,                              NULL },
> >> -		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_RO,     "sysfs",                                             "%r/sys",                       "sysfs",    MS_RDONLY,                      NULL },
> >> +		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_RW,     "sysfs",                                             "%r/sys",                       "sysfs",    MS_NODEV|MS_NOEXEC|MS_NOSUID,   NULL },
> >> +		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_RO,     "sysfs",                                             "%r/sys",                       "sysfs",    MS_NODEV|MS_NOEXEC|MS_NOSUID|MS_RDONLY, NULL },
> >>  		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_MIXED,  "sysfs",                                             "%r/sys",                       "sysfs",    MS_NODEV|MS_NOEXEC|MS_NOSUID,   NULL },
> >>  		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_MIXED,  "%r/sys",                                            "%r/sys",                       NULL,       MS_BIND,                        NULL },
> >>  		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_MIXED,  NULL,                                                "%r/sys",                       NULL,       MS_REMOUNT|MS_BIND|MS_RDONLY,   NULL },
> >
> > fwiw - the first one works, the second one does not due to an apparent
> > inability to statvfs the origin.
> 
> Good to hear.  That confirms there are no other gotchas waiting in the
> wings.
> 
> Apparently my second suggested patch is buggy due to an invalid source
> string.  The source would need to be %r/proc or %r/sysfs to use statvfs
> productively.

Right, in these cases they're only passing in "sysfs".  The first way
is more explicit anyway (though may not help some people who have a
"lxc.mount.entry = sysfs sys sysfs ro 0 0" line in their configuration
instead, so maybe we'll have to go with the second after all, d'oh.
I'll have to look into it next week)
