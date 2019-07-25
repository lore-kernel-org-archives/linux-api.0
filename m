From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Thu, 25 Jul 2019 12:30:48 +0200
Message-ID: <20190725103048.GE4707@redhat.com>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-5-christian@brauner.io>
 <CAG48ez3nuY__qvctoOnX7mQbjjP4chEs4K-OPxSQficiPLS18w@mail.gmail.com>
 <CFB4D39F-24B9-4AD9-B19C-E2D14D38A808@brauner.io>
 <CAG48ez1vd4Yhd3DqHVjTWM-N0MaNnX9n8MNV7MEyU5m3XDu+kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez1vd4Yhd3DqHVjTWM-N0MaNnX9n8MNV7MEyU5m3XDu+kQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <christian@brauner.io>, kernel list <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, "Joel Fernandes (Google)" <joel@joelfernandes.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, kernel-team <kernel-team@android.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 07/24, Jann Horn wrote:
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1902,6 +1902,10 @@ static __latent_entropy struct task_struct *copy_process(
>         delayacct_tsk_init(p);  /* Must remain after dup_task_struct() */
>         p->flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER | PF_IDLE);
>         p->flags |= PF_FORKNOEXEC;
> +       if (!(clone_flags & CLONE_THREAD))
> +               p->flags &= ~PF_PF_WAIT_PID;
> +       if (clone_flags & CLONE_WAIT_PID)
> +               p->flags |= PF_PF_WAIT_PID;

agreed, but then the "if (!thread_group_leader(tsk))" block in de_thread()
should also copy PF_PF_WAIT_PID.

> An alternative would be to not use p->flags at all, but instead make
> this a property of the signal_struct - since the property is shared by
> all threads, that might make more sense?

I tend to agree.

Oleg.
