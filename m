From: Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [RESEND PATCH 1/3] epoll: Extract epoll_wait_do and epoll_pwait_do
Date: Thu, 8 Jan 2015 09:51:32 -0800
Message-ID: <CAMEtUuzbFowGqSZYKH2Sej-4fq2kcQ7ALFR92=V1NcQ3c4y-YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Miklos Szeredi <mszeredi@suse.cz>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fabian Frederick <fabf@skynet.be>, Josh Triplett <josh@joshtri>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 8, 2015 at 1:16 AM, Fam Zheng <famz@redhat.com> wrote:
> +       if (!timeout || (timeout->tv_nsec == 0 && timeout->tv_sec == 0)) {
..
> +       } else if (timeout->tv_nsec >= 0 && timeout->tv_sec >= 0) {

the check for tv_nsec is not enough, which points
to the fragility of passing user timespec around.
I think it would be safer and cleaner to do it futex style:
  if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
      return -EFAULT;
  if (!timespec_valid(&ts))
      return -EINVAL;
  t = timespec_to_ktime(ts);
and then only pass ktime_t around.

> +               struct timespec end_time = ep_set_mstimeout(timeout);

the name is now wrong, since it's no longer MStimeout.

I think handling of compat is missing as well.
