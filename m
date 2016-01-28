From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [RFC PATCH] selftests: use INSTALL_HDR_PATH instead of relative
 paths
Date: Fri, 29 Jan 2016 08:19:50 +1100
Message-ID: <1454015990.25145.0.camel@ellerman.id.au>
References: <1452522172-16650-1-git-send-email-sudeep.holla@arm.com>
	 <1452742640.25808.1.camel@ellerman.id.au> <569783D7.5000303@arm.com>
	 <CAPKp9uahQtYKWEiS8LN0wY-CG8P5WA=+oWXQc4ASDrXsUe-Qxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPKp9uahQtYKWEiS8LN0wY-CG8P5WA=+oWXQc4ASDrXsUe-Qxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2016-01-26 at 11:57 +0000, Sudeep Holla wrote:
> On Thu, Jan 14, 2016 at 11:17 AM, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org> wrote:
> > On 14/01/16 03:37, Michael Ellerman wrote:
> > >
> > > Does the patch below work for you? It uses INSTALL_HDR_PATH if it is
> > > defined,
> > > or otherwise KERNEL_HEADERS if it is defined, or finally it guesses at
> > > ../../../usr/include (ie. the base of the source tree).
> > >
> >
> > Yes it does work fine. So feel free to add my tested-by when you post
> > the patch. Thanks for the quick and clean fix.
> >
>
> Any update on this patch ?

Sorry, got stuck behind other stuff.

Will try and get it sent out next week.

cheers
