From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Date: Thu, 23 Oct 2014 10:04:07 +0400
Message-ID: <20141023060407.GB16267@moon>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414040834-30209-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 23, 2014 at 04:07:12PM +1100, Michael Ellerman wrote:
> kcmp.h appears to be part of the API, it's documented in kcmp(2), and
> the selftests/kcmp code uses it. So move it to uapi so it's actually
> exported.
> 
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Acked-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
