From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/6] pkey.7: New page with overview of Memory Protection
 Keys
Date: Wed, 12 Oct 2016 10:41:17 +0200
Message-ID: <ece20e5b-981d-e5c4-7b71-b1bd538c6937@redhat.com>
References: <20160608173351.5CF7B2D3@ray> <20160608173423.A35B7734@ray>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608173423.A35B7734@ray>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/08/2016 07:34 PM, Dave Hansen wrote:
> +To use this feature, the processor must support it, and Linux
> +must contain support for the feature on a given processor.
> +As of early 2016 only future Intel x86 processors are supported,
> +and this hardware supports 16 protection keys in each process.
> +However, pkey 0 is used as the default key, so a maximum of 15
> +are available for actual application use.

How can we reserve pkeys for use in system libraries?

Thanks,
Florian
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
