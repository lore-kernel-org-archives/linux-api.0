From: "Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> (greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org)" <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] hpsa: Convert DEVICE_ATTR macro usage to
 DEVICE_ATTR_RO|WR|WO
Date: Tue, 30 Jun 2015 22:45:11 -0700
Message-ID: <20150701054511.GB23370@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB4442E19F@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB4442E19F-4I1V4pQFGigSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James Bottomley (JBottomley-O3H1v1f1dlM@public.gmane.org)" <JBottomley-O3H1v1f1dlM@public.gmane.org>, ISS StorageDev <iss_storagedev-VXdhtT5mjnY@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 01, 2015 at 03:47:10AM +0000, Seymour, Shane M wrote:
> 
> Convert DEVICE_ATTR macro usage to DEVICE_ATTR_RO|WR|WO
> Changes forced some function names to change.
> 
> Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
