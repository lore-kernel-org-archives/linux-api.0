From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH, v8 3/3] cgroups: introduce timer slack controller
Date: Mon, 7 Mar 2011 15:19:32 -0800
Message-ID: <20110307151932.4d73c3ff.akpm@linux-foundation.org>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name>
	<1299161947-9903-4-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299161947-9903-4-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu,  3 Mar 2011 16:19:07 +0200
"Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:

> --- /dev/null
> +++ b/Documentation/cgroups/timer_slack.txt
> @@ -0,0 +1,64 @@
> +Timer Slack Controller
> +=====================
> +
> +Overview
> +--------
> +
> +Every task_struct has timer_slack_ns value. This value uses to round up
> +poll() and select() timeout values. This feature can be useful in
> +mobile environment where combined wakeups are desired.
> +
> +cgroup subsys "timer_slack" implements timer slack controller. It
> +provides a way to set minimal timer slack value for a group of tasks.
> +If a task belongs to a cgroup with minimal timer slack value higher than
> +task's value, cgroup's value will be applied.

All I'm seeing here is a bunch of code, but no reason has been provided
for merging any of it.

Why do we need a cgroup for this as opposed to (say) inheritance over
fork(), or a system-wide knob, or a per-process/threadgroup knob, or
just leaving the existing code as-is?  Presumably you felt that a
cgroup approach is better for manageability, but you didn't tell us
about this and you didn't explore alternative ways of solving the
problem-which-you-didn't-describe.


Carefully describing the proposed feature and the overall value which
it brings does help to grease the wheels and is worth spending some
time over, please.  Don't expect the entire audience to be mind-readers!
