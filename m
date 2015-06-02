From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: UAPI headers including non-UAPI headers by accident?
Date: Tue, 2 Jun 2015 09:36:53 -0700
Message-ID: <CALCETrVaWJVDFydhXv320iCuFhTMi9txx+MpzsA_Q7yeZxMDSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

include/uapi/linux/signal.h starts with:

#ifndef _UAPI_LINUX_SIGNAL_H
#define _UAPI_LINUX_SIGNAL_H

#include <asm/signal.h>
#include <asm/siginfo.h>

This causes it to include <asm/signal.h>, which is not the same thing
as <uapi/asm/signal.h>.  Changing that will break userspace use of
this header, though, as the uapi/ won't get removed.

What's the correct fix?  This is causing trouble with a UML build for me.

Thanks,
Andy
