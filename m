From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH, v8 1/3] hrtimer: introduce effective timer slack
Date: Thu, 3 Mar 2011 17:32:28 +0100
Message-ID: <201103031732.28964.arnd@arndb.de>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name> <1299161947-9903-2-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299161947-9903-2-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 03 March 2011, Kirill A. Shutsemov wrote:
> task_get_effective_timer_slack() returns timer slack value to be used
> to configure per-task timers. It can be equal or higher than task's
> timer slack value.
> 
> For now task_get_effective_timer_slack() returns timer_slack_ns of the
> task. Timer slack cgroup controller will implement a bit more
> sophisticated logic.

Some time ago, there was a discussion about a method for automatically
determining timer slack values, and I think nobody ever implemented it.

The idea was to penalize tasks that have timers expiring a lot, typically
a sign of programs that were not written with power consumption in mind.

I think that could be nicely combined with your patch. Instead of setting
the effective timer slack for the entire control group, you  could
set a target value that is applied only to tasks that have their timers
expire frequently. When a timer expires for a task, you increase the
effective slack up to the maximum, and when you set up a timer, you
decrease it again. The amount by which the effective slack gets changed
can depend on how long ago the last timer expired.

Does this make sense to you?

	Arnd
