From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH] ptrace: use fsuid, fsgid, effective creds for fs access checks
Date: Mon,  7 Dec 2015 22:25:10 +0100
Message-ID: <1449523512-29200-1-git-send-email-jann@thejh.net>
References: <20151207203824.GA27364@pc.thejh.net>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151207203824.GA27364@pc.thejh.net>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@google.com>, Casey Schaufler <casey@schaufler-ca.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, security@kernel.org, Willy Tarreau <w@1wt.eu>
List-Id: linux-api@vger.kernel.org

Whoops. After Kees pointed out my last mistake, I decided to grep around a bit to make sure
I didn't miss anything else and noticed that apparently, Yama and Smack aren't completely
aware that the ptrace access mode can have flags ORed in? Until now, it was just the
NOAUDIT flag for /proc/$pid/stat, but with my patch, that would have been broken completely
as far as I can tell. I don't use either of those LSMs and didn't test with them.

Can the LSM maintainers have a look at this and say whether this looks okay now?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
