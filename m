From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: ioctl manpages?
Date: Tue, 15 Dec 2015 00:33:58 -0800
Message-ID: <20151215083358.GE10584@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Just out of curiosity, how does one submit manpages for specific
ioctls?  There's a manpage for ioctl() itself, but I can't find
anything for things like, say, FIEMAP or FICLONE or FICLONERANGE.
I guess they'd be section 2, right?

Something like /usr/share/man/man2/ficlone.2.gz?  Or a separate
ioctl-ficlone.2.gz, just in case there's ever a ficlone syscall?

--Darrick
