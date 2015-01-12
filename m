From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Input: uinput - fix ioctl numbers in uapi/uinput.h
Date: Sun, 11 Jan 2015 16:29:43 -0800
Message-ID: <20150112002943.GA31862@dtor-ws>
References: <1420893816-11620-1-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1420893816-11620-1-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Hutterer <peter.hutterer-Pf4JEFdB4epeoWH0uzbU5w@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Gabriel,

On Sat, Jan 10, 2015 at 01:43:34PM +0100, Gabriel Laskar wrote:
> Ioctls numbers for UI_GET_SYSNAME and UI_GET_VERSION are incorrectly numbered,
> since nr number is 8bit encoded, 300 and 301 will effectively get 44 and 45.
> these two patches fixes this
> 

Nice catch, thank you! I folded the patches together (as they are fixing
essentially the same thing) , changed hex to dec (because the rest of
ioctls in uinput use decimal) and applied.

I wonder if we need to put a BUILD_BUG_ON in one if _IO* defines to
catch such errors early on.

Thanks.

-- 
Dmitry
