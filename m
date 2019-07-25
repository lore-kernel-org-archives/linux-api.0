From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/5] pidfd: add pidfd_wait()
Date: Thu, 25 Jul 2019 12:16:27 +0200
Message-ID: <20190725101626.GD4707@redhat.com>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190724144651.28272-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/24, Christian Brauner wrote:
>
> +SYSCALL_DEFINE6(pidfd_wait, int, pidfd, int __user *, stat_addr,
> +		siginfo_t __user *, info, struct rusage __user *, ru,
> +		unsigned int, states, unsigned int, flags)
> +{

Oh, I too think that P_PIDFD makes more sense.

and could you explain in the changelog why? I am not arguing and if
nothing else this is consistent with other pidfd features, but if you
are parent/debugger you can't hit the problem with pid-reuse, unless
you races with your sub-threads.

Oleg.
