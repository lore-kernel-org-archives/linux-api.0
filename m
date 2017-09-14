From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] fs/proc: report eip/esp in /prod/PID/stat for coredumping
Date: Thu, 14 Sep 2017 07:51:59 -0700
Message-ID: <CALCETrUPLUdw+Q699jB6tPpNLvbNGfCuZ5n7Qw_m+-5Fj30iwA@mail.gmail.com>
References: <87poatfwg6.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87poatfwg6.fsf@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: John Ogness <john.ogness@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tycho Andersen <tycho.andersen@canonical.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 14, 2017 at 2:42 AM, John Ogness <john.ogness@linutronix.de> wrote:
> Commit 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in
> /proc/PID/stat") stopped reporting eip/esp because it is
> racey and dangerous for executing tasks. The comment adds:
>
>     As far as I know, there are no use programs that make any
>     material use of these fields, so just get rid of them.
>
> However, existing userspace core-dump-handler applications (for
> example, minicoredumper) are using these fields since they
> provide an excellent cross-platform interface to these valuable
> pointers. So that commit introduced a user space visible
> regression.
>
> Partially revert the change and make the readout possible for
> tasks with the proper permissions and only if the target task
> has the PF_DUMPCORE flag set.

Looks okay to me.

Reviewed-by: Andy Lutomirski <luto@kernel.org>

--Andy
