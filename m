From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v4 0/9] epoll: Introduce new syscalls, epoll_ctl_batch
 and epoll_pwait1
Date: Thu, 12 Mar 2015 11:02:03 -0400
Message-ID: <5501AA6B.2020209@akamai.com>
References: <1425952155-27603-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425952155-27603-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, linux-fsdevel
List-Id: linux-api@vger.kernel.org

On 03/09/2015 09:49 PM, Fam Zheng wrote:
>
> Benchmark for epoll_pwait1
> ==========================
>
> By running fio tests inside VM with both original and modified QEMU, we can
> compare their difference in performance.
>
> With a small VM setup [t1], the original QEMU (ppoll based) has an 4k read
> latency overhead around 37 us. In this setup, the main loop polls 10~20 fds.
>
> With a slightly larger VM instance [t2] - attached a virtio-serial device so
> that there are 80~90 fds in the main loop - the original QEMU has a latency
> overhead around 49 us. By adding more such devices [t3], we can see the latency
> go even higher - 83 us with ~200 FDs.
>
> Now modify QEMU to use epoll_pwait1 and test again, the latency numbers are
> repectively 36us, 37us, 47us for t1, t2 and t3.
>
>

Hi,

So it sounds like you are comparing original qemu code (which was using
ppoll) vs. using epoll with these new syscalls. Curious if you have numbers
comparing the existing epoll (with say the timerfd in your epoll set), so
we can see the improvement relative to epoll.

Thanks,

-Jason
