From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: Re: [C/R v20][PATCH 15/96] cgroup freezer: Fix buggy resume test for tasks frozen with cgroup freezer
Date: Fri, 26 Mar 2010 23:53:26 +0100
Message-ID: <201003262353.26181.rjw@sisk.pl>
References: <1268842164-5590-1-git-send-email-orenl@cs.columbia.edu> <201003230028.40915.rjw@sisk.pl> <4BA8E659.1030702@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BA8E659.1030702-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Cedric Le Goater <legoater-GANU6spQydw@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 23 March 2010, Oren Laadan wrote:
> 
> Rafael J. Wysocki wrote:
> > On Wednesday 17 March 2010, Oren Laadan wrote:
> >> From: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >>
> >> When the cgroup freezer is used to freeze tasks we do not want to thaw
> >> those tasks during resume. Currently we test the cgroup freezer
> >> state of the resuming tasks to see if the cgroup is FROZEN.  If so
> >> then we don't thaw the task. However, the FREEZING state also indicates
> >> that the task should remain frozen.
> >>
> >> This also avoids a problem pointed out by Oren Ladaan: the freezer state
> >> transition from FREEZING to FROZEN is updated lazily when userspace reads
> >> or writes the freezer.state file in the cgroup filesystem. This means that
> >> resume will thaw tasks in cgroups which should be in the FROZEN state if
> >> there is no read/write of the freezer.state file to trigger this
> >> transition before suspend.
> >>
> >> NOTE: Another "simple" solution would be to always update the cgroup
> >> freezer state during resume. However it's a bad choice for several reasons:
> >> Updating the cgroup freezer state is somewhat expensive because it requires
> >> walking all the tasks in the cgroup and checking if they are each frozen.
> >> Worse, this could easily make resume run in N^2 time where N is the number
> >> of tasks in the cgroup. Finally, updating the freezer state from this code
> >> path requires trickier locking because of the way locks must be ordered.
> >>
> >> Instead of updating the freezer state we rely on the fact that lazy
> >> updates only manage the transition from FREEZING to FROZEN. We know that
> >> a cgroup with the FREEZING state may actually be FROZEN so test for that
> >> state too. This makes sense in the resume path even for partially-frozen
> >> cgroups -- those that really are FREEZING but not FROZEN.
> >>
> >> Reported-by: Oren Ladaan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
> >> Signed-off-by: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> Cc: Cedric Le Goater <legoater-GANU6spQydw@public.gmane.org>
> >> Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> >> Cc: Rafael J. Wysocki <rjw-KKrjLPT3xs0@public.gmane.org>
> >> Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
> >> Cc: linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> > 
> > Looks reasonable.
> > 
> > Is anyone handling that already or do you want me to take it to my tree?
> 
> Yes, please do.

Applied.

Rafael
