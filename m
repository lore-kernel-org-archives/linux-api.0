From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH, v9 3/3] cgroups: introduce timer slack controller
Date: Mon, 14 Mar 2011 16:46:52 -0700
Message-ID: <20110314164652.5b44fb9e.akpm@linux-foundation.org>
References: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
	<1300111524-5666-4-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300111524-5666-4-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 14 Mar 2011 16:05:24 +0200
Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:

> +Overview
> +--------
> +
> +Every task_struct has timer_slack_ns value. This value uses to round up
> +poll() and select() timeout values. This feature can be useful in
> +mobile environment where combined wakeups are desired.
> +
> +Originally, prctl() was the only way to change timer slack value of
> +a process. So you was not able change timer slack value of another
> +process.
> +
> +cgroup subsys "timer_slack" implements timer slack controller. It
> +provides a way to set minimal timer slack value for a group of tasks.
> +If a task belongs to a cgroup with minimal timer slack value higher than
> +task's value, cgroup's value will be applied.
> +
> +Timer slack controller allows to implement setting timer slack value of
> +a process based on a policy. For example, you can create foreground and
> +background cgroups and move tasks between them based on system state.

(quoting myself from last time)

Why do we need a cgroup for this as opposed to (say) inheritance over
fork(), or a system-wide knob, or a per-process/threadgroup knob, or
just leaving the existing code as-is?  Presumably you felt that a
cgroup approach is better for manageability, but you didn't tell us
about this and you didn't explore alternative ways of solving the
problem-which-you-didn't-describe.




I'm still having trouble seeing why we should merge this.  Who will use
it, and for what reason and what benefits will they see?  Quantified
benefits, if possible!
