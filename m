From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/10] Removing SEND_SIG_FORCED
Date: Sat, 8 Sep 2018 13:03:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809081302350.1402@nanos.tec.linutronix.de>
References: <87musyl3fa.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87musyl3fa.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 3 Sep 2018, Eric W. Biederman wrote:
 
> SEND_SIG_FORCED has two functions.  It forces a pid namespace init to
> receive a signal it would ordinarily ignore, and it causes a siginfo to
> not be allocated for a signal.
> 
> This patchset makes __send_signal a little bit smarter so that it can
> detect when to apply these optimizations and the senders of signals
> don't have to worry about them.
> 
> The coupling of forcing a signal to the pid namespace init and not
> allocating siginfo resulted in serveral minor bugs where a signal
> sent by the kernel was marked SI_USER suggesting another userspace
> process sent that signal.  I have cc'd linux-api in case anyone cares
> about these minor userspace visible differences.
> 
> Unless someone notices a bug I intend to merge these changes through my
> tree during the next merge window.   While there are numerous fixes here
> none of them appear to be the kind that fixes real world problems so I
> don't see any urgency here.
> 
> Please look read and send my your review.  I will be out for about a
> week so I will address any comments when I get back.

Went through it carefuly and could not spot anything. Great work!

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
