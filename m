From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 3/4] signal: support CLONE_PIDFD with pidfd_send_signal
Date: Wed, 17 Apr 2019 16:11:44 +0200
Message-ID: <20190417141144.k2kmg7hd7pdpywyw@brauner.io>
References: <20190416170233.10208-1-christian@brauner.io>
 <20190416170233.10208-4-christian@brauner.io>
 <20190417140106.GG32622@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190417140106.GG32622@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Wed, Apr 17, 2019 at 04:01:06PM +0200, Oleg Nesterov wrote:
> On 04/16, Christian Brauner wrote:
> >
> > @@ -3581,12 +3588,12 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
> >  	if (flags)
> >  		return -EINVAL;
> >
> > -	f = fdget_raw(pidfd);
> > +	f = fdget(pidfd);
> 
> could you explain this change?
> 
> I am just curious, I don't understand why should we disallow O_PATH and how
> this connects to this patch.

Sending a signal through a pidfd is considered to be on a par with a
"write" to that pidfd.
Additionally, we use the fops associated with the fd to detect whether
it is actually a pidfd or not. This is not possible with O_PATH since
f_ops will be set to dummy fops. So we already correctly error out since
we detect that it is an O_PATH before fdget_raw(). This just takes the
opportunity to fix it.

Christian
