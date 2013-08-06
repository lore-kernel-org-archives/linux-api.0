From: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Tue, 6 Aug 2013 12:30:13 -0400
Message-ID: <20130806163013.GY221@brightrain.aerifal.cx>
References: <20130805222544.GA19168@brightrain.aerifal.cx>
 <20130806055425.GA9280@lst.de>
 <20130806134254.GT221@brightrain.aerifal.cx>
 <20130806140321.GA4421@lst.de>
 <20130806143609.GV221@brightrain.aerifal.cx>
 <20130806145159.GA8192@lst.de>
 <20130806152316.GW221@brightrain.aerifal.cx>
 <20130806155415.GA12926@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130806155415.GA12926-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2013 at 05:54:15PM +0200, Christoph Hellwig wrote:
> On Tue, Aug 06, 2013 at 11:23:16AM -0400, Rich Felker wrote:
> > > For that we'd also want to move fexec(ve) into the kernel space.
> > 
> > I agree this would be useful, but it's a separate issue.
> 
> I don't think it is.  The whole point of O_EXEC is to support fexecve.
> 
> Without moving it to kernel I can't see how you can make it strictly
> conforming to this requirement in Posix that the file descriptor 
> must be valid for executing.

POSIX is contradictory on this issue. I should probably file a request
for an interpretation. On the one hand, fexecve "shall fail" if:

  "The fd argument is not a valid file descriptor open for executing."

On the other hand, the application usage text (non-normative, if I'm
not mistaken) reads:

  "Since execute permission is checked by fexecve(), the file
  description fd need not have been opened with the O_EXEC flag.
  However, if the file to be executed denies read and write permission
  for the process preparing to do the exec, the only way to provide
  the fd to fexecve() will be to use the O_EXEC flag when opening fd.
  In this case, the application will not be able to perform a checksum
  test since it will not be able to read the contents of the file."

This suggests that file descriptors opened in other modes could be
used, and that O_EXEC only exists so that you can open a file you
would otherwise not have permissions to. Moreover, early in the
normative ("description") text, it reads:

  "The fexecve() function shall be equivalent to the execve() function
  except that the file to be executed is determined by the file
  descriptor fd instead of a pathname. The file offset of fd is
  ignored."

Anyway, if failure when O_ACCMODE is not O_EXEC is required, it's
trivial to do in userspace: just call fcntl(F_GETFL) on the file
descriptor and generate an artificial EBADF if O_PATH is not set.
(Naturally this check would be omitted on pre-O_PATH kernels where
full conformance is not possible.)

Rich
