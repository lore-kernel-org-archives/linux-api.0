From: Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 15:05:52 -0700 (PDT)
Message-ID: <20120426220552.D98D62C0D3@topped-with-meat.com>
References: <1335460011.9701.30.camel@lade.trondhjem.org>
	<20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<CAH2r5ms4WQV3DnTvqNN=2N71Cj8UHwj8Z6+RHXgrAOv6mSoyQg@mail.gmail.com>
	<20656.1335450358@redhat.com>
	<CAH2r5mv1Lijdwk5zsQwYJr4Etb6fhrRyNXm-iFCQX+HecboGrQ@mail.gmail.com>
	<1335453958.9701.10.camel@lade.trondhjem.org>
	<CAH2r5mt5af-_hxBRKK72iD5Gr99bo91ec78Rov8EGVEx8=21mA@mail.gmail.com>
	<1335459642.9701.27.camel@lade.trondhjem.org>
	<CAH2r5mvmCfLrxRHje6Wx5X84zxPEHwRMUJGsjvWBujMu7w841w@mail.gmail.com>
	<10104.1335477476@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: David Howells's message of  Thursday, 26 April 2012 22:57:56 +0100 <10104.1335477476-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org" <wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org>, "kfm-devel-RoXCvvDuEio@public.gmane.org" <kfm-devel-RoXCvvDuEio@public.gmane.org>, "nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org" <nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> What if the xstat() and struct xstat eventually becomes what userspace
> uses as stat() (as a wrapper) and struct stat (if such a thing is
> possible with glibc versioning)?  

It's certainly possible with symbol versioning, though it seems much more
likely that we'd stick with the existing struct stat and stat* interfaces
and only have the implementation using statx underneath (e.g. for new
machines or kernel ABIs where the kernel stops providing any calls except
for statxat), at least for the foreseeable future.

> Do older programs that think they're using stat() and don't know about
> the extra fields available expect to see a useful value in st_ino?

POSIX requires that st_ino have a useful value for the standard *stat calls.


Thanks,
Roland
