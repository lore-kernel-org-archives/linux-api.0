From: Michael Ellerman <michael-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] tools: Add a selftests_run target
Date: Fri, 29 Jan 2016 08:22:10 +1100
Message-ID: <1454016130.25145.1.camel@ellerman.id.au>
References: <1453969215-26532-1-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453969215-26532-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2016-01-28 at 09:20 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> With it, you can do
> 
> $ make tools/selftests_run
> 
> from the toplevel kernel repo and it'll run all selftests. Don't forget
> the -j.

OK. You can already do:

  $ make kselftest


Is this better for some reason?

cheers
