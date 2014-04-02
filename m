From: Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Date: Wed, 02 Apr 2014 12:45:19 +0100
Message-ID: <1396439119.2726.29.camel@menhir>
References: <533B04A9.6090405@bbn.com>
	 <20140402111032.GA27551@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140402111032.GA27551-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Hansen <rhansen-A08e6c8yq/Q@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Troxel <gdt-2FjktZCtrC/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Wed, 2014-04-02 at 04:10 -0700, Christoph Hellwig wrote:
> On Tue, Apr 01, 2014 at 02:25:45PM -0400, Richard Hansen wrote:
> > For the flags parameter, POSIX says "Either MS_ASYNC or MS_SYNC shall
> > be specified, but not both." [1]  There was already a test for the
> > "both" condition.  Add a test to ensure that the caller specified one
> > of the flags; fail with EINVAL if neither are specified.
> 
> This breaks various (sloppy) existing userspace for no gain.
> 
> NAK.
> 
Agreed. It might be better to have something like:

if (flags == 0)
	flags = MS_SYNC;

That way applications which don't set the flags (and possibly also don't
check the return value, so will not notice an error return) will get the
sync they desire. Not that either of those things is desirable, but at
least we can make the best of the situation. Probably better to be slow
than to potentially lose someone's data in this case,

Steve.
