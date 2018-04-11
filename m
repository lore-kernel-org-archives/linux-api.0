From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 24/24] debugfs: Restrict debugfs when the kernel is
 locked down
Date: Wed, 11 Apr 2018 21:54:36 +0200
Message-ID: <20180411195436.GA7126@kroah.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 11, 2018 at 05:27:16PM +0100, David Howells wrote:
> Disallow opening of debugfs files that might be used to muck around when
> the kernel is locked down as various drivers give raw access to hardware
> through debugfs.  Given the effort of auditing all 2000 or so files and
> manually fixing each one as necessary, I've chosen to apply a heuristic
> instead.  The following changes are made:
> 
>  (1) chmod and chown are disallowed on debugfs objects (though the root dir
>      can be modified by mount and remount, but I'm not worried about that).
> 
>  (2) When the kernel is locked down, only files with the following criteria
>      are permitted to be opened:
> 
> 	- The file must have mode 00444
> 	- The file must not have ioctl methods
> 	- The file must not have mmap
> 
>  (3) When the kernel is locked down, files may only be opened for reading.
> 
> Normal device interaction should be done through configfs, sysfs or a
> miscdev, not debugfs.
> 
> Note that this makes it unnecessary to specifically lock down show_dsts(),
> show_devs() and show_call() in the asus-wmi driver.
> 
> I would actually prefer to lock down all files by default and have the
> the files unlocked by the creator.  This is tricky to manage correctly,
> though, as there are 19 creation functions and ~1600 call sites (some of
> them in loops scanning tables).

Why not just disable debugfs entirely?  This half-hearted way to sorta
lock it down is odd, it is meant to not be there at all, nothing in your
normal system should ever depend on it.

So again just don't allow it to be mounted at all, much simpler and more
obvious as to what is going on.

thanks,

greg k-h
