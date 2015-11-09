From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH] ptrace: use fsuid, fsgid, effective creds for fs access checks
Date: Mon, 9 Nov 2015 22:06:08 +0100
Message-ID: <20151109210608.GH26584@1wt.eu>
References: <1446984516-1784-1-git-send-email-jann@thejh.net> <20151109125554.43e6a711e59d1b8bf99cdeb1@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20151109125554.43e6a711e59d1b8bf99cdeb1@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jann Horn <jann@thejh.net>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, security@kernel.org, Kees Cook <keescook@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 09, 2015 at 12:55:54PM -0800, Andrew Morton wrote:
> > --- a/fs/proc/array.c
> > +++ b/fs/proc/array.c
> > @@ -395,7 +395,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
> >  
> >  	state = *get_task_state(task);
> >  	vsize = eip = esp = 0;
> > -	permitted = ptrace_may_access(task, PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT);
> > +	permitted = ptrace_may_access(task,
> > +		PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT | PTRACE_MODE_FSCREDS);
> 
> There's lots of ugliness in the patch to do with fitting code into 80 cols. 
> Can we do
> 
> #define PTRACE_foo (PTRACE_MODE_READ|PTRACE_MODE_FSCREDS)
> 
> to avoid all that?

Or even simply bypass the 80-cols rule. Making code ugly or less easy
to read for sake of an arbitrary rule is often not fun, and that's even
more so when it comes to security fixes that people are expected to
easily understand next time they put their fingers there.

Willy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
