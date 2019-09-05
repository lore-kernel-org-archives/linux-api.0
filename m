From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Why add the general notification queue and its sources
Date: Thu, 5 Sep 2019 20:33:05 +0200
Message-ID: <20190905183305.GA22877@kroah.com>
References: <CAHk-=wh5ZNE9pBwrnr5MX3iqkUP4nspz17rtozrSxs5-OGygNw@mail.gmail.com>
 <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk>
 <17703.1567702907@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17703.1567702907@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rstrode@redhat.com, swhiteho@redhat.com, nicolas.dichtel@6wind.com, raven@themaw.net, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, Christian Brauner <christian@brauner.io>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 06:01:47PM +0100, David Howells wrote:
>  (2) USB notifications.
> 
>      GregKH was looking for a way to do USB notifications as I was looking to
>      find additional sources to implement.  I'm not sure how he wants to use
>      them, but I'll let him speak to that himself.

We are getting people asking for all sorts of "error reporting" events
that can happen in the USB subsystem that we have started to abuse the
KOBJ_CHANGE uevent notification for.  At the same time your patches were
submitted, someone else submitted yet-another-USB-error patchset.  This
type of user/kernel interface is much easier to use than abusing uevents
for USB errors and general notifications about what happened with USB
devices (more than just add/remove that uevents have).

So yes, I would like this, and I am sure the ChromeOS people would like
it too given that I rejected their patcheset with the assumption that
this could be done with the notification queue api "soon" :)

thanks,

greg k-h
