From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the kernel
Date: Mon, 20 Oct 2014 19:06:47 +0200
Message-ID: <2166528.FFdzTaR0kp@wuerfel>
References: <20141016124741.GA3832@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141016124741.GA3832-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Santosh Shilimkar <santosh.shilimkar-l0cyMroinI0@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rebecca Schultz Zavin <rebecca-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anup Patel <anup.patel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 16 October 2014 14:47:41 Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> 
> The Android binder code has been "stable" for many years now.  No matter
> what comes in the future, we are going to have to support this API, so
> might as well move it to the "real" part of the kernel as there's no
> real work that needs to be done to the existing code.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> ---
> 
> This was discussed in the Android miniconf at the Plumbers conference.
> If anyone has any objections to this, please let me know, otherwise I'm
> queueing this up for 3.19-rc1

I'm worried about the user interface: since graduating binder out of
staging with the existing ioctl interface has never been discussed
as a real option and (I assume) everybody expected the way forward
would be to have a replacement, I don't think it ever received the
attention it should have. Specific concerns are:

- I don't think there has been an audit of which subset of the API
  is actually required. IIRC, it was said initially that actual
  applications don't use all the features, and that we should have
  a smaller attack surface.

- Using kernel pointers in user space interfaces is an information
  leak that can be used to construct an exploit. (I don't know if
  this is still used that way, I think it was doing it last
  time I checked).

- The driver supports two versions of the user interface (v7 and
  v8), but only one of them can be selected at compile-time, and
  an 'allmodconfig' kernel will only include the deprecated one
  on 32-bit machines.

- The implementation is not namespace-aware and will cause
  information to be shared across containers in a potentially
  harmful way.
  If we graduate the driver from staging, it should IMHO at least
  be useful in containers to run Android user space safely.

	Arnd
