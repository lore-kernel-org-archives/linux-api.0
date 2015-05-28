From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe
 as bind mounts (take 2)
Date: Thu, 28 May 2015 14:08:39 +0000
Message-ID: <20150528140839.GD28842@ubuntumail>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
 <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87wq004im1.fsf@x220.int.ebiederm.org>
 <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Fri, May 22, 2015 at 10:39 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> > I had hoped to get some Tested-By's on that patch series.
> 
> Sorry, I've been totally swamped.
> 
> I suspect that Sandstorm is okay, but I haven't had a chance to test
> it for real.  Sandstorm makes only limited use of proc and sysfs in
> containers, but I'll see if I can test it for real this weekend.

Testing this with unprivileged containers, I get

lxc-start: conf.c: lxc_mount_auto_mounts: 808 Operation not permitted - error mounting sysfs on /usr/lib/x86_64-linux-gnu/lxc/sys/devices/virtual/net flags 0

> > Oh well.  The fundamentals seem sound, and my biggest concern the
> > implicit nodev does not apply so I will put this patchset in linux-next
> > and aim at merging it in the next merge window.  Hopefully that will
> > leave enough time catch problems.
> >
> > Eric
> >
> 
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
