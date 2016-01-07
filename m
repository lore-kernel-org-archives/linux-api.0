From: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 5/5] selftests: firmware: add empty string and async
 tests
Date: Thu, 7 Jan 2016 13:39:53 -0800
Message-ID: <20160107213953.GA49009@google.com>
References: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
 <1449701429-121423-5-git-send-email-computersforpeace@gmail.com>
 <568ED136.40308@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568ED136.40308-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Shuah,

On Thu, Jan 07, 2016 at 01:57:26PM -0700, Shuah Khan wrote:
> On 12/09/2015 03:50 PM, Brian Norris wrote:
> > Now that we've added a 'trigger_async_request' knob to test the
> > request_firmware_nowait() API, let's use it. Also add tests for the
> > empty ("") string, since there have been a couple errors in that
> > handling already.
> > 
> > Since we now have real ways that the sysfs write might fail, let's add
> > the appropriate check on the 'echo' lines too.
> > 
> > Signed-off-by: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> Thanks for the patch. Applied to linux-kselftest next for 4.5-rc1.

Great! Perhaps I'm missing something: I see patches 1-4, but not this
patch (patch 5) in:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git +next

Regards,
Brian
