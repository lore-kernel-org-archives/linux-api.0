From: josh@joshtriplett.org
Subject: Re: [PATCH v2 5/7] clone4: Add a CLONE_AUTOREAP flag to
 automatically reap the child process
Date: Fri, 20 Mar 2015 14:10:55 -0700
Message-ID: <20150320211055.GA13125@cloud>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <20150315233439.GA31890@thin>
 <20150320181404.GA26343@redhat.com>
 <1766646.jusoNDOCPE@tjmaciei-mobl4>
 <20150320190914.GA28357@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150320190914.GA28357@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thiago Macieira <thiago.macieira@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 20, 2015 at 08:09:14PM +0100, Oleg Nesterov wrote:
> On 03/20, Thiago Macieira wrote:
> >
> > On Friday 20 March 2015 19:14:04 Oleg Nesterov wrote:
> > > Also. I forgot that the kernel always resets ->exit_signal to SIGCHLD on
> > > exec or reparenting. Reparenting is probably fine. But what about exec?
> > > Should it keep ->exit_signal == 0 if "autoreap" ? I think it should not, to
> > > avoid the strange special case.
> >
> > Not delivering any signal was the objective of this patch series, so yes
> > exit_signal == 0 should survive an exec and even re-exec.
> 
> OK, but then perhaps we should never send SIGCHLD (on exit) if "autoreap",
> to make the logic simple.
> 
> And copy_process() should probably do
> 
> 	if ((clone_flags & CSIGNAL) && (clone_flags && CLONE_AUTOREAP))
> 		return -EINVAL;
> 
> so that we still can change this behaviour later.

I'm fine with that, as it would handle the particular use case we care
about.

However, the reset-signal-on-reparent thing might still make sense,
particularly for the ptrace-reparent case (less so for the
reparent-to-child-reaper case).

- Josh Triplett
