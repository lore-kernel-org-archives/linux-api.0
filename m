From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Date: Tue, 02 Dec 2014 16:36:42 +1100
Message-ID: <1417498602.31336.7.camel@concordia>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
	 <1417141122.6694.5.camel@concordia> <547C9E92.8010606@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <547C9E92.8010606-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2014-12-01 at 10:00 -0700, Shuah Khan wrote:
> On 11/27/2014 07:18 PM, Michael Ellerman wrote:
> > On Thu, 2014-10-23 at 16:07 +1100, Michael Ellerman wrote:
> >> kcmp.h appears to be part of the API, it's documented in kcmp(2), and
> >> the selftests/kcmp code uses it. So move it to uapi so it's actually
> >> exported.
> > 
> > Looks like this series fell through the cracks?
> > 
> > It still applies on rc6. Should I resend?
> > 
> > cheers
> > 
> >> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> 
> I am expecting a patch v2 for the series based on the comments
> on the series. Please see my responses to the individual patch
> threads.

Sure, will repost.

cheers
