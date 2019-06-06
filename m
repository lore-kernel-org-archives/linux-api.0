From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 09/10] usb: Add USB subsystem notifications [ver #3]
Date: Thu, 6 Jun 2019 17:31:50 +0200
Message-ID: <20190606153150.GB28997@kroah.com>
References: <20190606143306.GA11294@kroah.com>
 <Pine.LNX.4.44L0.1906061051310.1641-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1906061051310.1641-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, linux-usb@vger.kernel.org, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 06, 2019 at 10:55:24AM -0400, Alan Stern wrote:
> On Thu, 6 Jun 2019, Greg Kroah-Hartman wrote:
> 
> > On Thu, Jun 06, 2019 at 10:24:18AM -0400, Alan Stern wrote:
> > > On Thu, 6 Jun 2019, David Howells wrote:
> > > 
> > > > Add a USB subsystem notification mechanism whereby notifications about
> > > > hardware events such as device connection, disconnection, reset and I/O
> > > > errors, can be reported to a monitoring process asynchronously.
> > > 
> > > USB I/O errors covers an awfully large and vague field.  Do we really
> > > want to include them?  I'm doubtful.
> > 
> > See the other patch on the linux-usb list that wanted to start adding
> > KOBJ_CHANGE notifications about USB "i/o errors".
> 
> That patch wanted to add notifications only for enumeration failures
> (assuming you're talking about the patch from Eugeniu Rosca), not I/O
> errors in general.

Yes, sorry, I was thinking that as a "I/O failed in enumeration" :)

> > So for "severe" issues, yes, we should do this, but perhaps not for all
> > of the "normal" things we see when a device is yanked out of the system
> > and the like.
> 
> Then what counts as a "severe" issue?  Anything besides enumeration 
> failure?

Not that I can think of at the moment, other than the other recently
added KOBJ_CHANGE issue.  I'm sure we have other "hard failure" issues
in the USB stack that people will want exposed over time.

thanks,

greg k-h
