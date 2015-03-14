From: Thiago Macieira <thiago.macieira@intel.com>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit notification via fd
Date: Sat, 14 Mar 2015 11:38:29 -0700
Message-ID: <28025621.k7WkrfHd4d@tjmaciei-mobl4>
References: <cover.1426180120.git.josh@joshtriplett.org> <20150314141414.GA11062@redhat.com> <20150314143235.GA12086@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150314143235.GA12086@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: josh@joshtriplett.org, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Saturday 14 March 2015 15:32:35 Oleg Nesterov wrote:
> It is not clear to me what do_wait() should do with ->autoreap child, even
> ignoring ptrace.
> 
> Just suppose that real_parent has a single "autoreap" child. Should
> wait(NULL) hanf then?

It should ignore the child that is set to autoreap. wait(NULL) should return -
ECHILD, indicating there are no children waiting to be reaped.

But now I realise that this might have implications for session management and 
job control.

> If yes, who will wake the parent up?
> 
> If no, I do not see the necessary changes in wait_cosnider_task().

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center
