From: Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Input: uinput - fix ioctl numbers in uapi/uinput.h
Date: Mon, 12 Jan 2015 10:57:02 -0500
Message-ID: <20150112155702.GA7941@mail.corp.redhat.com>
References: <1420893816-11620-1-git-send-email-gabriel@lse.epita.fr>
 <20150112002943.GA31862@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150112002943.GA31862@dtor-ws>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Hutterer <peter.hutterer-Pf4JEFdB4epeoWH0uzbU5w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Jan 11 2015 or thereabouts, Dmitry Torokhov wrote:
> Hi Gabriel,
> 
> On Sat, Jan 10, 2015 at 01:43:34PM +0100, Gabriel Laskar wrote:
> > Ioctls numbers for UI_GET_SYSNAME and UI_GET_VERSION are incorrectly numbered,
> > since nr number is 8bit encoded, 300 and 301 will effectively get 44 and 45.
> > these two patches fixes this
> > 
> 
> Nice catch, thank you! I folded the patches together (as they are fixing
> essentially the same thing) , changed hex to dec (because the rest of
> ioctls in uinput use decimal) and applied.
> 
> I wonder if we need to put a BUILD_BUG_ON in one if _IO* defines to
> catch such errors early on.
> 

As others said, nice catch, thanks a lot. I feel very embarrassed about
this :(

Cheers,
Benjamin
