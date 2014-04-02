From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Date: Wed, 2 Apr 2014 04:10:32 -0700
Message-ID: <20140402111032.GA27551@infradead.org>
References: <533B04A9.6090405@bbn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <533B04A9.6090405-A08e6c8yq/Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Hansen <rhansen-A08e6c8yq/Q@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Troxel <gdt-2FjktZCtrC/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 01, 2014 at 02:25:45PM -0400, Richard Hansen wrote:
> For the flags parameter, POSIX says "Either MS_ASYNC or MS_SYNC shall
> be specified, but not both." [1]  There was already a test for the
> "both" condition.  Add a test to ensure that the caller specified one
> of the flags; fail with EINVAL if neither are specified.

This breaks various (sloppy) existing userspace for no gain.

NAK.
