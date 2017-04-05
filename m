From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH v2 3/5] clone: Disallown CLONE_THREAD with a
        shared sighand_struct
Date: Wed, 5 Apr 2017 18:24:59 +0200
Message-ID: <20170405162458.GF14536@redhat.com>
References: <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com> <874ly6a0h1.fsf_-_@xmission.com> <87k2728lrp.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87k2728lrp.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/02, Eric W. Biederman wrote:
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1515,6 +1515,13 @@ static __latent_entropy struct task_struct *copy_process(
>  	if ((clone_flags & CLONE_THREAD) && !(clone_flags & CLONE_SIGHAND))
>  		return ERR_PTR(-EINVAL);
>
> +	/* Disallow CLONE_THREAD with a shared SIGHAND structure.  No
> +	 * one cares

Well, can't resists... I won't argue, but we can't know if no one cares
or not. I agree that most probably this won't break something, but who
knows... I am always scared when we add the incompatible changes.

> and supporting it leads to unnecessarily complex
> +	 * code.
> +	 */
> +	if ((clone_flags & CLONE_THREAD) && (atomic_read(&current->sighand->count) > 1))
> +		return ERR_PTR(-EINVAL);

Perhaps the comment should explain why we do this and say that
sighand-unsharing in de_thread() depends on this.

Oleg.
