From: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] vfs: introduce FS_IOC_SYNCFS to sync a single super
Date: Sat, 27 Nov 2010 23:04:07 -0600
Message-ID: <20101128050407.GA16903@burratino>
References: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
 <20100826170142.e029cff5.akpm@linux-foundation.org>
 <20101127223217.GA26820@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101127223217.GA26820@burratino>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Jonathan Nieder wrote:

> Since
> ancient times, that has been done with the "rename trick":
[...]
> Great.  Problem is, filesystems with delayed allocation like XFS,
> ubifs, ext4, hfs+ don't cope so well with that[1].
[...]
> [1] Yes, even after v2.6.30-rc1~416^2~15 (ext4: Automatically allocate
> delay allocated blocks on rename, 2009-02-23).
> See https://bugzilla.kernel.org/show_bug.cgi?id=18632

Sorry, wrong link.  The example meant was

	https://bugzilla.kernel.org/show_bug.cgi?id=15910

"zero-length files and performance degradation", reported against 2.6.32:

| To reproduce it:
| * install a fresh Ubuntu Lucid system on an ext4 filesystem, or Debian with
| dpkg < 1.15.6 or Ubuntu Karmic
| * install a package, wait a few seconds and simulate a crash 
| $ sudo apt-get install some-package; sleep 5; sudo echo b > /proc/sysrq-trigger
| * reboot
| $ ls -l /var/lib/dpkg/info/some-package.* will list empty maintainer's scripts.
| $ ls -l /var/cache/apt/archive/some-package.* will show the empty archive
| you've just downloaded
| At this stage, the package manager is unusable and the common user cannot
| update anything anymore.
|
| This behavior is observed with data=ordered and with or without the mount
| option auto_da_alloc.

Sorry for the confusion.
Jonathan
