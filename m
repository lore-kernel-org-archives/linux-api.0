From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
Date: Tue, 02 Dec 2014 16:53:54 +1100
Message-ID: <1417499634.31336.9.camel@concordia>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
	 <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
	 <20141023060912.GD16267@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141023060912.GD16267@moon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2014-10-23 at 10:09 +0400, Cyrill Gorcunov wrote:
> On Thu, Oct 23, 2014 at 04:07:14PM +1100, Michael Ellerman wrote:
> > Don't prevent the test building on non-x86. Just try and build it and
> > let the chips fall where they may.
> > 
> > Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> 
> kcmp depends on checkpoint/restore config symbol which is known
> to work on x86 and (iirc) on arm, that's why x86 was only allowed.
> I don't mind to such change but not sure.
 
Yeah I understand. It's helpful for the other architectures to be able to build
the test, that way we at least know that it's something we should think about
implementing/fixing. If the test doesn't build at all then we just ignore it :)

cheers
