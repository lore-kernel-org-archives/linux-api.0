From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [RESEND] tools-powerpc: Return false instead of -1
Date: Mon, 14 Nov 2016 23:17:25 +1100 (AEDT)
Message-ID: <3tHTzn42Z9z9s5w@ozlabs.org>
References: <20161109085504.10799-1-andrew.shadura@collabora.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161109085504.10799-1-andrew.shadura@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Shadura <andrew.shadura@collabora.co.uk>, linuxppc-dev@lists.ozlabs.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, Paul Mackerras <paulus@samba.org>, Cyril Bur <cyrilbur@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 2016-09-11 at 08:55:04 UTC, Andrew Shadura wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Returning a negative value for a boolean function seem to have the
> undesired effect of returning true. require_paranoia_below() is a
> boolean function, but the variable used to store the return value is an
> integer, receiving -1 or 0. This patch convert rc to bool, replace -1
> by false, and 0 by true.
> 
> This issue was found by the following Coccinelle semantic patch:
> <smpl>
> @@
> identifier f, ret;
> constant C;
> typedef bool;
> @@
> bool f (...){
> <+...
> ret = -C;
> ...
> * return ret;
> ...+>
> }
> </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> Signed-off-by: Andrew Shadura <andrew.shadura@collabora.co.uk>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/0e27d27e0d6d92342797e0d37738c2

cheers
