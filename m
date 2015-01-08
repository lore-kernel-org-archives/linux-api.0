From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RESEND PATCH 2/3] epoll: Add implementation for epoll_pwait1
Date: Thu, 08 Jan 2015 12:10:51 +0100
Message-ID: <54AE65BB.1020707@redhat.com>
References: <1420708563-21743-1-git-send-email-famz@redhat.com> <1420708563-21743-3-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420708563-21743-3-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Miklos Szeredi <mszeredi@suse.cz>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fabian Frederick <fabf@skynet.be>, Josh Triplett <josh@joshtriplett.o>
List-Id: linux-api@vger.kernel.org



On 08/01/2015 10:16, Fam Zheng wrote:
> Unlike ppoll(2), which accepts a timespec argument "timeout_ts" to
> specify the timeout, epoll_wait(2) and epoll_pwait(2) expect a
> microsecond timeout in int type.
> 
> This is an obstacle for applications in switching from ppoll to epoll,
> if they want nanosecond resolution in their event loops.
> 
> Therefore, adding this variation of epoll wait interface, giving user an
> option with *both* advantages, is a reasonable move: there could be
> constantly scalable performance polling many fds, while having a
> nanosecond timeout precision (assuming it has properly set up timer
> slack with prctl(2)).
> 
> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
>  fs/eventpoll.c           | 24 ++++++++++++++++++++++++
>  include/linux/syscalls.h |  4 ++++
>  kernel/sys_ni.c          |  3 +++
>  3 files changed, 31 insertions(+)

As mentioned by Miklos in the non-resent version, please add a flags
argument.  Invalid flags should return -EINVAL.

In fact, we could already use the flags argument to specify an absolute
timeout, which is a nice thing to have for QEMU too.

Paolo
