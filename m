From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Wed, 28 Nov 2018 15:42:31 +0100
Message-ID: <20181128144230.GG30395@redhat.com>
References: <20181127225408.7553-1-j@bitron.ch>
 <20181127225408.7553-2-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181127225408.7553-2-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/27, Jürg Billeter wrote:
>
> @@ -704,6 +713,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>  	struct task_struct *p, *n;
>  	LIST_HEAD(dead);
>  
> +	if (group_dead && tsk->signal->kill_descendants_on_exit)
> +		walk_process_tree(tsk, kill_descendant_visitor, NULL);

Well, this is not exactly right, at least this is suboptimal in that
other sub-threads can too call walk_process_tree(kill_descendant_visitor)
later for no reason.
