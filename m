From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ptrace: use fsuid, fsgid, effective creds for fs access
 checks
Date: Mon, 9 Nov 2015 13:19:02 -0800
Message-ID: <20151109131902.db961a5fe7b7fcbeb14f72fc@linux-foundation.org>
References: <1446984516-1784-1-git-send-email-jann@thejh.net>
	<20151109125554.43e6a711e59d1b8bf99cdeb1@linux-foundation.org>
	<20151109211209.GA3236@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151109211209.GA3236@pc.thejh.net>
Sender: owner-linux-mm@kvack.org
To: Jann Horn <jann@thejh.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, security@kernel.org, Willy Tarreau <w@1wt.eu>, Kees Cook <keescook@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, 9 Nov 2015 22:12:09 +0100 Jann Horn <jann@thejh.net> wrote:
> 
> > Can we do
> > 
> > #define PTRACE_foo (PTRACE_MODE_READ|PTRACE_MODE_FSCREDS)
> > 
> > to avoid all that?
> 
> Hm. All combinations of the PTRACE_MODE_*CREDS flags with
> PTRACE_MODE_{READ,ATTACH} plus optionally PTRACE_MODE_NOAUDIT
> make sense, I think. So your suggestion would be to create
> four new #defines
> PTRACE_MODE_{READ,ATTACH}_{FSCREDS,REALCREDS} and then let
> callers OR in the PTRACE_MODE_NOAUDIT flag if needed?

If these flag combinations have an identifiable concept behind them then
sure, it makes sense to capture that via a well-chosen identifier.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
