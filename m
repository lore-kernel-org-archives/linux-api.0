From: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH] selftests: use INSTALL_HDR_PATH instead of relative paths
Date: Tue, 26 Jan 2016 11:57:25 +0000
Message-ID: <CAPKp9uahQtYKWEiS8LN0wY-CG8P5WA=+oWXQc4ASDrXsUe-Qxg@mail.gmail.com>
References: <1452522172-16650-1-git-send-email-sudeep.holla@arm.com>
	<1452742640.25808.1.camel@ellerman.id.au>
	<569783D7.5000303@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569783D7.5000303-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 14, 2016 at 11:17 AM, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org> wrote:
>
>
> On 14/01/16 03:37, Michael Ellerman wrote:
>>

[...]

>>
>> Does the patch below work for you? It uses INSTALL_HDR_PATH if it is
>> defined,
>> or otherwise KERNEL_HEADERS if it is defined, or finally it guesses at
>> ../../../usr/include (ie. the base of the source tree).
>>
>
> Yes it does work fine. So feel free to add my tested-by when you post
> the patch. Thanks for the quick and clean fix.
>

Any update on this patch ?

Regards,
Sudeep
