From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cleanup paccept
Date: Tue, 28 Oct 2008 15:15:31 -0400
Message-ID: <20081028191531.GA1007@infradead.org>
References: <200810281909.m9SJ9pdj003624@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <200810281909.m9SJ9pdj003624-sQhldQRnEDHy+ZiRM8QlFPXAX3CI6PSWQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 28, 2008 at 03:09:51PM -0400, Ulrich Drepper wrote:
> This patch doesn't change *any* functionality from what is currently
> in the upstream kernel.  There is no reason to start arguing again and
> for me to explain everything the way I did it months ago.  This is just
> a *cleanup patch*, nothing else.  If you want to know why this cleanup
> is needed read the discussions of

Umm, it does enabled functionality that wasn't enabled before.  And that
functionality includes a syscall.  So any chance you could write a
proper changelog that describes what you actually do instead of lots of
ranting and references to old posts?

And no "[PATCH] cleanup paccept" isn't really a good subject for adding
a new syscalls either.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
