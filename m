From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Sat, 14 Mar 2015 12:01:32 -0700
Message-ID: <20150314190132.GB22130@thin>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <20150314141414.GA11062@redhat.com>
 <20150314143235.GA12086@redhat.com>
 <28025621.k7WkrfHd4d@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <28025621.k7WkrfHd4d@tjmaciei-mobl4>
Sender: linux-kernel-owner@vger.kernel.org
To: Thiago Macieira <thiago.macieira@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 11:38:29AM -0700, Thiago Macieira wrote:
> On Saturday 14 March 2015 15:32:35 Oleg Nesterov wrote:
> > It is not clear to me what do_wait() should do with ->autoreap child, even
> > ignoring ptrace.
> > 
> > Just suppose that real_parent has a single "autoreap" child. Should
> > wait(NULL) hanf then?
> 
> It should ignore the child that is set to autoreap. wait(NULL) should return -
> ECHILD, indicating there are no children waiting to be reaped.

Right.  And I don't think the current code does this.  I think we need
to change wait_consider_task to early-return for ->autoreap just as it
does for task_state == EXIT_DEAD.  I'll do that in v2.

- Josh Triplett
