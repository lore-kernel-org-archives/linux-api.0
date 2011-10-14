From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Sat, 15 Oct 2011 02:34:45 +0300
Message-ID: <20111014233445.GA28092@shutemov.name>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
 <20111014154348.ae6267aa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111014154348.ae6267aa.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 14, 2011 at 03:43:48PM -0700, Andrew Morton wrote:
> On Tue, 11 Oct 2011 19:15:29 +0300
> "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> 
> > Every task_struct has timer_slack_ns value. This value uses to round up
> > poll() and select() timeout values. This feature can be useful in
> > mobile environment where combined wakeups are desired.
> > 
> > Originally, prctl() was the only way to change timer slack value of
> > a process. So you was not able change timer slack value of another
> > process.
> > 
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

Putting a task to a cgroup isn't change task's timer slack, it may affect
"effective timer slack", if min timer slack for the cgroup > task's timer
slack.

Since we don't touch task's slack value we can drag tasks between cgroups
and always get the most relaxed slack value for a task without
saving/restoring it in userspace.

-- 
 Kirill A. Shutemov
