From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/3] introduce new evdev interface type
Date: Fri, 27 Nov 2015 17:58:54 +0100
Message-ID: <8705201.iaeQDTRocP@wuerfel>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448618432-32357-1-git-send-email-pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: WEN Pingbo <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aksgarg1989-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Friday 27 November 2015 18:00:29 WEN Pingbo wrote:
> To solve the y2038 problem in input_event, I had some attempts before [1],
> and this is the second one.
> 
> We can force userspace to use monotonic time in event timestamp, so the
> 'struct timeval' is enough to keep y2038-safe, as Arnd suggested. But we
> can not find a way to make kernel compatible with old binaries, which use
> realtime, and there are still some devices, which depend on realtime.
> 
> So I get a idea to add a new evdev interface, which is y2038 safe. And
> userspace can switch between the old and new interface via ioctl.
> 
> The patch series add three evdev interface type:
> 
> - EV_IF_LEGACY
>   send event by input_event. This is the default option, keep kernel
>   backward compatible.

The problem I see with this approach is that it still breaks any
legacy source code that is compiled with a new libc that uses 64-bit
time_t. If we are requiring source code changes for building users
of input devices with a new libc, we can easily get them to handle
the overflow (they normally only care about the microsecond portion
anyway, so it doesn't matter in most cases), or to use monotonic time.

Did I miss something here?

	Arnd
