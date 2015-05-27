From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [char-misc-next 04/11 V2] uuid: extract macros for assigning raw
 arrays
Date: Wed, 27 May 2015 09:50:54 -0700
Message-ID: <20150527165054.GB3533@kroah.com>
References: <1432741333-11889-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432741333-11889-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2015 at 06:42:13PM +0300, Tomas Winkler wrote:
> In order for mei client devices to use device id based on uuid we
> have to use common types between user space (file2alias.c).
> Similarly to vmbus,  mei  uses raw 16 byte array for that. 
> To leverage on existing infrastructure around uuid_le type 
> defined in uuid.h we add helper macros to handle conversions between
> raw 16 byte array and uuid_{le,be} types.

You aren't adding a helper macro, you are just redefining the existing
macros using a different one.  But I can't see why this is needed, what
does this solve that vmbus and other uses of the existing macros don't
need?  In other words, what makes mei so special that it needs a "lower"
level macro than every other subsystem?

thanks,

greg k-h
