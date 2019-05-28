From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC][PATCH 0/7] Mount, FS, Block and Keyrings notifications
Date: Tue, 28 May 2019 16:58:10 -0700
Message-ID: <20190528235810.GA5776@kroah.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 05:01:47PM +0100, David Howells wrote:
> Things I want to avoid:
> 
>  (1) Introducing features that make the core VFS dependent on the network
>      stack or networking namespaces (ie. usage of netlink).
> 
>  (2) Dumping all this stuff into dmesg and having a daemon that sits there
>      parsing the output and distributing it as this then puts the
>      responsibility for security into userspace and makes handling
>      namespaces tricky.  Further, dmesg might not exist or might be
>      inaccessible inside a container.
> 
>  (3) Letting users see events they shouldn't be able to see.

How are you handling namespaces then?  Are they determined by the
namespace of the process that opened the original device handle, or the
namespace that made the new syscall for the events to "start flowing"?

Am I missing the logic that determines this in the patches, or is that
not implemented yet?

thanks,

greg k-h
