From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 4/5] firmware: actually return NULL on failed
 request_firmware_nowait()
Date: Thu, 7 Jan 2016 13:56:57 -0700
Message-ID: <568ED119.8040905@osg.samsung.com>
References: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
 <1449701429-121423-4-git-send-email-computersforpeace@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449701429-121423-4-git-send-email-computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/09/2015 03:50 PM, Brian Norris wrote:
> The kerneldoc for request_firmware_nowait() says that it may call the
> provided cont() callback with @fw == NULL, if the firmware request
> fails. However, this is not the case when called with an empty string
> (""). This case is short-circuited by the 'name[0] == '\0'' check
> introduced in commit 471b095dfe0d ("firmware_class: make sure fw requests
> contain a name"), so _request_firmware() never gets to set the fw to
> NULL.
> 

Thanks for the patch. Applied to linux-kselftest next for 4.5-rc1.

thanks,
-- Shuah
-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
