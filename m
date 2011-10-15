From: Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Sat, 15 Oct 2011 13:20:09 +0200
Message-ID: <20111015112006.GA10173@tango.0pointer.de>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
 <20111014154348.ae6267aa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111014154348.ae6267aa.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk, greg@kroah.com, Matthew Garrett <mjg59@redhat.com>
List-Id: linux-api@vger.kernel.org

On Fri, 14.10.11 15:43, Andrew Morton (akpm@linux-foundation.org) wrote:

> > cgroup subsys "timer_slack" implements timer slack controller. It
> > provides a way to set minimal timer slack value for a group of tasks.
> > If a task belongs to a cgroup with minimal timer slack value higher than
> > task's value, cgroup's value will be applied.
> > 
> > Timer slack controller allows to implement setting timer slack value of
> > a process based on a policy. For example, you can create foreground and
> > background cgroups and move tasks between them based on system state.
> 
> I'm having trouble understanding the value of this feature.  Users can
> presently control the timer-slack of a group of processes via
> inherit-over-fork.
> 
> Perhaps there's a case for providing a way for process A to set process
> B's slack.  And perhaps B's children.  That would be a simpler patch
> and would have the considerable advantage that it doesn't require
> cgroups.
> 
> So.... why should we merge this?

Our usecase is basically this:

consider you have one or more desktop user sessions logged in, each one
in a timer slack cgroup. Now, userspace already tracks when sessions
become idle (i.e. currently desktop userspace then starts a screensaver,
or turns off the screen, or similar), and we'd like to increase the timer slack
for the session cgroups individually as the individual session becomes
idle, and decrease it again if the session stops being idle.

Matthew Garrett experimented with a logic like this based on existing
patches, and it showed quite positive effects on power consumption. If
you need hard data I am sure Matthew can fill you in (added him to CC).

What matters for us here is that the timer slack cgroup controller
provides us with a very nice way to change the timerslack for the whole
set of session processes in one go and from the outside. i.e. the idle
logic in userspace would be trivially easy to implement, since we
already track per-session idle states and with the timerlsack cgroup
controller we'd have to touch only a single kernel file to make our
changes.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
