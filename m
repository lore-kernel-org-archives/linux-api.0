From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 08/11] usb: Add USB subsystem notifications [ver #7]
Date: Tue, 3 Sep 2019 09:12:02 -0700
Message-ID: <20190903161202.GB22754@roeck-us.net>
References: <20190903125129.GA18838@roeck-us.net>
 <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
 <156717350329.2204.7056537095039252263.stgit@warthog.procyon.org.uk>
 <7481.1567526867@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7481.1567526867@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 03, 2019 at 05:07:47PM +0100, David Howells wrote:
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > This added call to usbdev_remove() results in a crash when running
> > the qemu "tosa" emulation. Removing the call fixes the problem.
> 
> Yeah - I'm going to drop the bus notification messages for now.
> 
It is not the bus notification itself causing problems. It is the
call to usbdev_remove().

Guenter
