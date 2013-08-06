From: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Tue, 6 Aug 2013 15:53:29 +0000
Message-ID: <Pine.LNX.4.64.1308061551260.10423@digraph.polyomino.org.uk>
References: <20130805222544.GA19168@brightrain.aerifal.cx> <20130806055425.GA9280@lst.de>
 <20130806134254.GT221@brightrain.aerifal.cx> <20130806140321.GA4421@lst.de>
 <20130806143609.GV221@brightrain.aerifal.cx> <20130806145159.GA8192@lst.de>
 <20130806152316.GW221@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130806152316.GW221-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 6 Aug 2013, Rich Felker wrote:

> Of course, the userspace fallback code could detect such failures and
> retry with O_RDONLY, so maybe it's not such a big issue. With a
> working O_PATH, open should never fail with EISDIR or EACCES, so these
> errors could be used as a condition to retry.

Surely you'll still get EACCES when some component in the specified path, 
not the last one, lacks search permission?

-- 
Joseph S. Myers
joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org
