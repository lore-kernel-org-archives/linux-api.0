From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task
	exit notification via fd
Date: Sat, 14 Mar 2015 19:54:24 +0100
Message-ID: <20150314185424.GA6813@redhat.com>
References: <cover.1426180120.git.josh@joshtriplett.org> <20150314141414.GA11062@redhat.com> <20150314143235.GA12086@redhat.com> <28025621.k7WkrfHd4d@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <28025621.k7WkrfHd4d@tjmaciei-mobl4>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Thiago Macieira <thiago.macieira@intel.com>
Cc: josh@joshtriplett.org, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 03/14, Thiago Macieira wrote:
>
> On Saturday 14 March 2015 15:32:35 Oleg Nesterov wrote:
> > It is not clear to me what do_wait() should do with ->autoreap child, even
> > ignoring ptrace.
> >
> > Just suppose that real_parent has a single "autoreap" child. Should
> > wait(NULL) hanf then?
>
> It should ignore the child that is set to autoreap. wait(NULL) should return -
> ECHILD, indicating there are no children waiting to be reaped.

I disagree. I won't really argue now, because I think that this needs
a separate discussion. And imo "autoreap" should come as a separate feature.

I think that wait(NULL) should hang like it hangs even if the parent ignores
SIGCHLD. But in this case the parent should be woken up when the "autoreap"
child exits.

If nothing else. Suppose that the parent does waitid(WEXITED|WSTOPPED).
Should WSTOPPED work? I think it should.

At the same time, if we add autoreap then probably it also makes sense to add
WEXITIED_UNLESS_AUTOREAP.

In short: this all certainly needs more discussion, but (afaics) this patch
is wrong in any case.



In fact I have some concerns about file descriptor from clone, it doesn't look
like a "right" interface to me. But I will not comment this part until at least
I read 0/4 ;)

Oleg.

