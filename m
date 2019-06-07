From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 09/10] usb: Add USB subsystem notifications [ver #3]
Date: Fri, 7 Jun 2019 10:01:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1906071000260.1612-100000@iolanthe.rowland.org>
References: <87imthdhjb.fsf@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87imthdhjb.fsf@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, linux-usb@vger.kernel.org, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 7 Jun 2019, Felipe Balbi wrote:

> Hi,
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > On Thu, Jun 06, 2019 at 10:55:24AM -0400, Alan Stern wrote:
> >> On Thu, 6 Jun 2019, Greg Kroah-Hartman wrote:
> >> 
> >> > On Thu, Jun 06, 2019 at 10:24:18AM -0400, Alan Stern wrote:
> >> > > On Thu, 6 Jun 2019, David Howells wrote:
> >> > > 
> >> > > > Add a USB subsystem notification mechanism whereby notifications about
> >> > > > hardware events such as device connection, disconnection, reset and I/O
> >> > > > errors, can be reported to a monitoring process asynchronously.
> >> > > 
> >> > > USB I/O errors covers an awfully large and vague field.  Do we really
> >> > > want to include them?  I'm doubtful.
> >> > 
> >> > See the other patch on the linux-usb list that wanted to start adding
> >> > KOBJ_CHANGE notifications about USB "i/o errors".
> >> 
> >> That patch wanted to add notifications only for enumeration failures
> >> (assuming you're talking about the patch from Eugeniu Rosca), not I/O
> >> errors in general.
> >
> > Yes, sorry, I was thinking that as a "I/O failed in enumeration" :)
> >
> >> > So for "severe" issues, yes, we should do this, but perhaps not for all
> >> > of the "normal" things we see when a device is yanked out of the system
> >> > and the like.
> >> 
> >> Then what counts as a "severe" issue?  Anything besides enumeration 
> >> failure?
> >
> > Not that I can think of at the moment, other than the other recently
> > added KOBJ_CHANGE issue.  I'm sure we have other "hard failure" issues
> > in the USB stack that people will want exposed over time.
> 
> From an XHCI standpoint, Transaction Errors might be one thing. They
> happen rarely and are a strong indication that the bus itself is
> bad. Either bad cable, misbehaving PHYs, improper power management, etc.

Don't you also get transaction errors if the user unplugs a device in 
the middle of a transfer?  That's not the sort of thing we want to sent 
notifications about.

Alan Stern
