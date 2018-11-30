From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Fri, 30 Nov 2018 11:17:51 +0100
Message-ID: <20181130101751.GA23670@redhat.com>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181129230826.GB4676@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181129230826.GB4676@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/29, Tycho Andersen wrote:
>
> /*
>  * These should never be seen by user programs.  To return one of ERESTART*
>  * codes, signal_pending() MUST be set.  Note that ptrace can observe these
>  * at syscall exit tracing, but they will never be left for the debugged user
>  * process to see.
>  */
> #define ERESTARTSYS     512
>
> So basically, if you respond with -ERESTARTSYS with no signal pending, you'll
> leak it to userspace.

Yes,

> It turns out this is already possible with
> SECCOMP_RET_TRAP (and probably ptrace alone,

Yes,

> The question is: do we care?

I think we do not care, debugger can do anything with the tracee.

Oleg.
