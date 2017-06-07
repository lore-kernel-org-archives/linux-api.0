From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 06/26] rlimit: Remove unnecessary grab of tasklist_lock
Date: Wed, 07 Jun 2017 09:08:30 -0500
Message-ID: <87vao7riu9.fsf@xmission.com>
References: <877f0pym71.fsf@xmission.com>
        <20170606190338.28347-1-ebiederm@xmission.com>
        <20170606190338.28347-6-ebiederm@xmission.com>
        <20170607123657.GA22199@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170607123657.GA22199-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Oleg Nesterov's message of
        "Wed, 7 Jun 2017 14:36:57 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Hi Eric,
>
> I'll try very much to read this series tomorrow, can't do this today...
>
> On 06/06, Eric W. Biederman wrote:
>>
>> @@ -1380,13 +1380,6 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
>>  			return -EPERM;
>>  	}
>>  
>> -	/* protect tsk->signal and tsk->sighand from disappearing */
>> -	read_lock(&tasklist_lock);
>> -	if (!tsk->sighand) {
>> -		retval = -ESRCH;
>> -		goto out;
>> -	}
>
> Yes, the comment is wrong.
>
> However we do need read_lock(tasklist_lock) to access ->group_leader. And the
> ->sighand != NULL check ensures that ->group_leader is the valid
> pointer.

As of 4.12-rc1 The code does not access group_leader anymore.

> Also, update_rlimit_cpu() is not safe without tasklist / sighand-check.
>
> We can probably change this code to rely on rcu.

Good point a NULL sighand will cause update_rlimit_cpu to OOPS.

Grr.  There is a point in my tree where this is perfectly safe.  But not
at this point.  Consider this patch dropped for the moment.

Eric
