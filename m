From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 06/26] rlimit: Remove unnecessary grab of tasklist_lock
Date: Wed, 7 Jun 2017 14:36:57 +0200
Message-ID: <20170607123657.GA22199@redhat.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
 <20170606190338.28347-6-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170606190338.28347-6-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi Eric,

I'll try very much to read this series tomorrow, can't do this today...

On 06/06, Eric W. Biederman wrote:
>
> @@ -1380,13 +1380,6 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
>  			return -EPERM;
>  	}
>  
> -	/* protect tsk->signal and tsk->sighand from disappearing */
> -	read_lock(&tasklist_lock);
> -	if (!tsk->sighand) {
> -		retval = -ESRCH;
> -		goto out;
> -	}

Yes, the comment is wrong.

However we do need read_lock(tasklist_lock) to access ->group_leader. And the
->sighand != NULL check ensures that ->group_leader is the valid pointer.

Also, update_rlimit_cpu() is not safe without tasklist / sighand-check.

We can probably change this code to rely on rcu.

Oleg.
