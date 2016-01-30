From: Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: [PATCH] fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
Date: Fri, 29 Jan 2016 23:49:29 -0500
Message-ID: <CAJhHMCBaP2b6pmw8ocKc_3degNZ1jd+aypzM2b7DLZve8PB_mw@mail.gmail.com>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <1442146833-13652-4-git-send-email-lixi@ddn.com> <20160103230534.GE6682@dastard>
 <CAJhHMCAvTJj=bX=uE1oK+DzG8aGNGvM-BkY83+H4BgzQiNBa+A@mail.gmail.com> <20160130044151.GA5925@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20160130044151.GA5925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Li Xi <pkuelelixi@gmail.com>, "open list:OVERLAYFS FILESYSTEM" <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>, adilger@dilger.ca, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 29, 2016 at 11:41 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> So on my Debain system, I don't update linux-libc-dev when I install a
> new upstream kernel built using "make deb-pkg".  I'll still a new
> version of the linux-image-*.deb file, and maybe a newer version of
> linux-firmware-*.dev, but I don't bother installing the
> linux-headers-*.deb file (since I don't compile external kernel
> modules), and I don't bother installing linux-libc-dev-*.deb (because
> of situations like this, where the userspace include files need ot be
> updated in sync, and this should be the distribution's problem to
> handle).

I am using a debian system and built the kernel using
"make bindeb-pkg". This generated the following debs:

linux-firmware-image-4.5.0-rc1+_4.5.0-rc1+-2_powerpc.deb
linux-image-4.5.0-rc1+_4.5.0-rc1+-2_powerpc.deb
linux-headers-4.5.0-rc1+_4.5.0-rc1+-2_powerpc.deb
linux-libc-dev_4.5.0-rc1+-2_powerpc.deb

which I installed as I usually do to test new system calls or run other tests.

I'll try to update the uapi header files manually and see how it goes...

Thanks!
-- 
Pranith
