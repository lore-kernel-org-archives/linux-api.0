From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, RFC -v2] random: introduce getrandom(2) system call
Date: Fri, 18 Jul 2014 11:39:17 +0200
Message-ID: <53C8EB45.20304@redhat.com>
References: <1405633100-4889-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405633100-4889-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linux Kernel Developers List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/17/2014 11:38 PM, Theodore Ts'o wrote:
> 	If the GRND_RANDOM flags bit is set, then draw from the
> 	/dev/random pool instead of the /dev/urandom pool.  The
> 	/dev/random pool is limited based on the entropy that can be
> 	obtained from environmental noise, so if there is insufficient
> 	entropy, the requested number of bytes may not be returned.
> 	If there is no entropy available at all, getrandom(2) will
> 	either block, or return an error with errno set to EAGAIN if
> 	the GRND_NONBLOCK bit is set in flags.

Can we get a GRND_INIT flag or something like that which means 
"block/return EAGAIN until the kernel pool is initialized"?  Thanks.

(See the previous discussion about pool initialization.)

-- 
Florian Weimer / Red Hat Product Security
