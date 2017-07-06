From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve regression tracking
Date: Thu, 06 Jul 2017 14:34:38 +0300
Message-ID: <7042009.5tkGy6PEBL@avalon>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info> <8c6843e8-73d9-a898-0366-0b72dfeb79a2@redhat.com> <20170705121000.5430d7d0@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705121000.5430d7d0-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 05 Jul 2017 12:10:00 Steven Rostedt wrote:
> On Wed, 5 Jul 2017 11:08:48 -0400 Carlos O'Donell wrote:
> > On 07/05/2017 10:33 AM, Steven Rostedt wrote:
> > > No test should be written for a single specific hardware. It should be a
> > > general functionality that different hardware can execute.
> > 
> > Why? We test all sorts of hardware in userspace and we see value in that
> > testing.
> 
> One reason is for bit rot. I'm not totally against it. But I envision
> that if we have hundreds of tests for very specific pieces of hardware,
> it's value will diminish over time. Unless we can get a good
> infrastructure written where the hardware info is more of a data sheet
> then a single test itself.

That's all nice, but when the hardware is complex and not fully abstracted 
behind a kernel API, tests are bound to be hardware-specific. Of course, a bug 
or regression observed only with a specific device, but triggered through the 
usage of abstract APIs only, can lead to a test case written for that device 
but runnable with any device in the same category. In that case the test case 
should certainly be added to a test suite for the corresponding API/subsystem, 
not to an hidden test suite for a particular device.

-- 
Regards,

Laurent Pinchart
