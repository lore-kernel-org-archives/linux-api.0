From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Tue, 6 Aug 2013 16:51:59 +0200
Message-ID: <20130806145159.GA8192@lst.de>
References: <20130805222544.GA19168@brightrain.aerifal.cx> <20130806055425.GA9280@lst.de> <20130806134254.GT221@brightrain.aerifal.cx> <20130806140321.GA4421@lst.de> <20130806143609.GV221@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130806143609.GV221-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2013 at 10:36:10AM -0400, Rich Felker wrote:
> This is frustrating because early on in the O_PATH discussions on LKML
> when it was first added, there were requests for O_SEARCH and O_EXEC
> semantics in the kernel, and these requests were rejected with the
> response being roughly "you can do it in userspace using the more
> general O_PATH approach". So we have two contradictory conditions:
> 
> - O_SEARCH/O_EXEC semantics won't be added in the kernel because you
>   can do it in userspace with O_PATH.
> 
> - O_SEARCH/O_EXEC can't be added in userspace because they can't be
>   assigned a value without having an implementation in kernelspace.
> 
> If there's a willingness to override/drop that previous decision
> (which I believe Linus was in on, but I'd have to search for the old
> threads again)

Yes, Linus has complained about it.  Probably rightly so because the
O_EXEC and O_SEARCH semantics don't seem overly useful.

> then I can propose a patch. As far as I can tell, the
> simplest implementation would be to follow the O_PATH code path but
> include a check for this new mode and fail at the point of opening a
> symlink where O_NOFOLLOW is processed. I am not sufficiently familiar
> with this code to write the patch yet, but I can try to learn it. My
> guess is that the patch would be less than 20 lines, half of it being
> a change for the top-level O_PATH logic in openat that strips other
> flags when O_PATH is present and half of it being

<text missing here>


Besides the symlink semantics I think we should really get a narrow
implementation of it, that is really forbid everything but executing
it (if S_IREG()) or performing openat on it (if S_ISDIR).

For that we'd also want to move fexec(ve) into the kernel space.

> If I do this, do you have a recommendation on the value to use? My
> guess for the best choice would be O_PATH|3, so that O_PATH, O_SEARCH,
> O_EXEC, O_RDONLY, O_WRONLY, and O_RDWR can all fall under O_ACCMODE
> without adding more than one bit to O_ACCMODE. If we do it this way,
> the patch should also make it so the extra bits (bits 0 and 1) set at
> open time should be preserved when fcntl(F_GETFL) is called so that
> the application correctly sees the access mode it requested.

Note that "3" aready has a magic meaning on Linux:

"Linux  reserves  the special, nonstandard access mode 3 (binary 11) in flags
 to mean: check for read and write permission on the file and return a
 descriptor that can't be used for reading or writing.  This nonstandard
 access mode is  used  by  some Linux drivers to return a descriptor that
 is to be used only for device-specific ioctl(2) operations."

Given that it's limited to device nodes and a somewhat similar limitation
to O_SEARCH and O_EXEC it doesn't sound too bad.
