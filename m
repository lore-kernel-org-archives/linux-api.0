From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Hard-coding PTY device node numbers in userspace
Date: Fri, 17 Feb 2017 10:15:38 -0800
Message-ID: <20170217181538.GA9346@kroah.com>
References: <87bmu1jd0j.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87bmu1jd0j.fsf-ZqZwdwZz9NfTBotR3TxKnbNAH6kLmebB@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jslaby-IBi9RG/b67k@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 12:02:52PM +0100, Florian Weimer wrote:
> We want to reject PTY devices from other namespaces as valid input to
> the ttyname and ttyname_r functions, while still providing a hint to
> callers that the device is, in fact, a PTY.  Christian Brauner wrote a
> glibc patch for this:
> 
>   <https://sourceware.org/ml/libc-alpha/2017-01/msg00531.html>
> 
> It hard-codes the major PTY device number range.  Is this feasible?
> Is it part of the stable userspace ABI for the TTY subsystem?

What major numbers are you using in the patch '2' and '3'?  And yes,
major numbers are static and you should be fine to rely on them.  But
can't you test that the device is a pty to verify it?

thanks,

greg k-h
