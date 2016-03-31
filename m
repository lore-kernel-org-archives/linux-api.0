From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] Implement leftpad syscall
Date: Thu, 31 Mar 2016 16:09:32 -0700
Message-ID: <20160331230932.GA8353@kroah.com>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
 <1459463613-32473-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459463613-32473-2-git-send-email-richard-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Gstir <david-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 01, 2016 at 12:33:32AM +0200, Richard Weinberger wrote:
> +	if (dst_len <= len || dst_len > 4096) {
> +		return -EINVAL;
> +	}

Please always use checkpatch.pl when submitting patches.

thanks,

greg k-h
