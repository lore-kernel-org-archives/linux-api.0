From: Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH 09/10] usb: Add USB subsystem notifications [ver #3]
Date: Wed, 12 Jun 2019 09:58:33 +0300
Message-ID: <87h88v1e92.fsf@linux.intel.com>
References: <Pine.LNX.4.44L0.1906110950440.1535-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1906110950440.1535-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, linux-usb@vger.kernel.org, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Hi,

Alan Stern <stern@rowland.harvard.edu> writes:

> On Tue, 11 Jun 2019, Felipe Balbi wrote:
>
>> >> >> > So for "severe" issues, yes, we should do this, but perhaps not for all
>> >> >> > of the "normal" things we see when a device is yanked out of the system
>> >> >> > and the like.
>> >> >> 
>> >> >> Then what counts as a "severe" issue?  Anything besides enumeration 
>> >> >> failure?
>> >> >
>> >> > Not that I can think of at the moment, other than the other recently
>> >> > added KOBJ_CHANGE issue.  I'm sure we have other "hard failure" issues
>> >> > in the USB stack that people will want exposed over time.
>> >> 
>> >> From an XHCI standpoint, Transaction Errors might be one thing. They
>> >> happen rarely and are a strong indication that the bus itself is
>> >> bad. Either bad cable, misbehaving PHYs, improper power management, etc.
>> >
>> > Don't you also get transaction errors if the user unplugs a device in 
>> > the middle of a transfer?  That's not the sort of thing we want to sent 
>> > notifications about.
>> 
>> Mathias, do we get Transaction Error if user removes cable during a
>> transfer? I thought we would just get Port Status Change with CC bit
>> cleared, no?
>
> Even if xHCI doesn't give Transaction Errors when a cable is unplugged 
> during a transfer, other host controllers do.  Sometimes quite a lot -- 
> they continue to occur until the kernel polls the parent hub's 
> interrupt ep and learns that the port is disconnected, which can take 
> up to 250 ms.

my comment was specific about XHCI. It even started with "From an XHCI
standpoint" :-)

-- 
balbi
