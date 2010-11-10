From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Wed, 10 Nov 2010 11:16:07 +0100
Message-ID: <201011101116.08038.arnd@arndb.de>
References: <cover.1288897198.git.richard.cochran@omicron.at> <201011080756.50930.arnd@arndb.de> <1289338622.9434.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289338622.9434.46.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: john stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tuesday 09 November 2010, john stultz wrote:
> I wonder thought if it would be worth having a syscall to convert from
> fd to clock_id so it could be more flexible in the future. But it may
> not be worth it, as we're probably already limited by the cpuclock
> implementation.

If the file descriptor comes from a character device, we don't even need
a syscall, it could simply be an ioctl on the device.

	Arnd
