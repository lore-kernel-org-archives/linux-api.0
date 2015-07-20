From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [linux-4.2-rc3/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c:194:
 bad if condition ?
Date: Mon, 20 Jul 2015 08:42:16 -0600
Message-ID: <55AD08C8.4030705@osg.samsung.com>
References: <DUB128-W55FA5DB7B71A53D5E73E289C850@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DUB128-W55FA5DB7B71A53D5E73E289C850-MsuGFMq8XAE@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/20/2015 03:26 AM, David Binderman wrote:
> Hello there,
> 
> [linux-4.2-rc3/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c:194]: (style) Expression is always false because 'else if' condition matches previous condition at line 191.
> 
> Source code is
> 
>         if (res> 0) {
>             atomic_set(&requeued, 1);
>             break;
>         } else if (res> 0) {
> 

Hi Daren,

Is this something that could be fixed?

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
