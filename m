From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6/9] Add a general, global device notification watch list
 [ver #5]
Date: Wed, 3 Jul 2019 19:16:23 +0200
Message-ID: <20190703171623.GD24672@kroah.com>
References: <156173690158.15137.3985163001079120218.stgit@warthog.procyon.org.uk>
 <156173697086.15137.9549379251509621554.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156173697086.15137.9549379251509621554.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 28, 2019 at 04:49:30PM +0100, David Howells wrote:
> Create a general, global watch list that can be used for the posting of
> device notification events, for such things as device attachment,
> detachment and errors on sources such as block devices and USB devices.
> This can be enabled with:
> 
> 	CONFIG_DEVICE_NOTIFICATIONS
> 
> To add a watch on this list, an event queue must be created and configured:
> 
>         fd = open("/dev/event_queue", O_RDWR);
>         ioctl(fd, IOC_WATCH_QUEUE_SET_SIZE, page_size << n);
> 
> and then a watch can be placed upon it using a system call:
> 
>         watch_devices(fd, 12, 0);
> 
> Unless the application wants to receive all events, it should employ
> appropriate filters.

What "filter"?  Who is going to use this and why a new system call for
this?  You can do this today with udev/netlink/hotplug/whatever so why
create yet-another-way?

I don't think this is a good idea unless we really nail down the api and
who is going to be using it.

thanks,

greg k-h
