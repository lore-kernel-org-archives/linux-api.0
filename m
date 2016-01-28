From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] tools: Add a selftests_run target
Date: Thu, 28 Jan 2016 22:30:27 +0100
Message-ID: <20160128213027.GL14274@pd.tnic>
References: <1453969215-26532-1-git-send-email-bp@alien8.de>
 <1454016130.25145.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454016130.25145.1.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <michael-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 29, 2016 at 08:22:10AM +1100, Michael Ellerman wrote:
> OK. You can already do:
> 
>   $ make kselftest
> 
> 
> Is this better for some reason?

No, I missed that there is even one in the top-level Makefile. And doing

make tools/help

shows only the "selftests" one. I should add kselftest to
tools/Makefile's help instead.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
