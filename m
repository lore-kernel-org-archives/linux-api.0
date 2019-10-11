From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracefs: Do not allocate and free proxy_ops for
 lockdown
Date: Fri, 11 Oct 2019 18:27:48 -0400
Message-ID: <20191011182748.23d6de31@gandalf.local.home>
References: <20191011135458.7399da44@gandalf.local.home>
        <CAHk-=wj7fGPKUspr579Cii-w_y60PtRaiDgKuxVtBAMK0VNNkA@mail.gmail.com>
        <20191011143610.21bcd9c0@gandalf.local.home>
        <87tv8f9cr7.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tv8f9cr7.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, 11 Oct 2019 23:46:20 +0200
Florian Weimer <fw@deneb.enyo.de> wrote:

> * Steven Rostedt:
> 
> > Once locked down is set, can it ever be undone without rebooting?  
> 
> I think this is the original intent with such patches, yes.  But then
> reality interferes and people add some escape hatch, so that it's
> possible again to load arbitrary kernel modules.  And for servers, you
> can't have a meaningful physical presence check, so you end up with a
> lot of complexity for something that offers absolutely zero gains in
> security.
> 
> The other practical issue is that general-purpose Linux distributions
> cannot prevent kernel downgrades, so even if there's a
> cryptographically signed chain from the firmware to the kernel, you
> can boot last year's kernel, use a root-to-ring-0 exploit to disable
> its particular implementation of lockdown, and then kexec the real
> kernel with lockdown disabled.
> 
> I'm sure that kernel lockdown has applications somewhere, but for
> general-purpose distributions (who usually want to support third-party
> kernel modules), it's an endless source of problems that wouldn't
> exist without it.

I just decided to keep the two separate. The tracing_disable is
permanent (unless you actually do something that writes into kernel
memory to change the variable). When set, there's nothing to clear it.

Thus, I decided not to couple that with lockdown, and let the lockdown
folks do whatever they damn well please ;-)

-- Steve
