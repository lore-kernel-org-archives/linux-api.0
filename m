From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Tue, 6 Aug 2013 17:54:15 +0200
Message-ID: <20130806155415.GA12926@lst.de>
References: <20130805222544.GA19168@brightrain.aerifal.cx> <20130806055425.GA9280@lst.de> <20130806134254.GT221@brightrain.aerifal.cx> <20130806140321.GA4421@lst.de> <20130806143609.GV221@brightrain.aerifal.cx> <20130806145159.GA8192@lst.de> <20130806152316.GW221@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130806152316.GW221-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2013 at 11:23:16AM -0400, Rich Felker wrote:
> > For that we'd also want to move fexec(ve) into the kernel space.
> 
> I agree this would be useful, but it's a separate issue.

I don't think it is.  The whole point of O_EXEC is to support fexecve.

Without moving it to kernel I can't see how you can make it strictly
conforming to this requirement in Posix that the file descriptor 
must be valid for executing.

Fortunately enough the kernel implementation is trivial.
