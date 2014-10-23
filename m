From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] selftests/kcmp: Don't include kernel headers
Date: Thu, 23 Oct 2014 10:05:24 +0400
Message-ID: <20141023060524.GC16267@moon>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
 <1414040834-30209-2-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414040834-30209-2-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 23, 2014 at 04:07:13PM +1100, Michael Ellerman wrote:
> The kcmp test mucks with the include path to bring in the kernel
> headers, and x86 headers too for reasons that are not clear.
> 
> Now that kcmp.h is exported none of that should be necessary.
> 
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

The reason was to be able to run test without userspace headers generated.
Still this one is better I think.

Acked-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
