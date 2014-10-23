From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
Date: Thu, 23 Oct 2014 10:09:12 +0400
Message-ID: <20141023060912.GD16267@moon>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
 <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414040834-30209-3-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 23, 2014 at 04:07:14PM +1100, Michael Ellerman wrote:
> Don't prevent the test building on non-x86. Just try and build it and
> let the chips fall where they may.
> 
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

kcmp depends on checkpoint/restore config symbol which is known
to work on x86 and (iirc) on arm, that's why x86 was only allowed.
I don't mind to such change but not sure.
