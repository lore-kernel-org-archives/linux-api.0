From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 12:10:00 -0400
Message-ID: <20170705121000.5430d7d0@gandalf.local.home>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
        <20170703123025.7479702e@gandalf.local.home>
        <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
        <20170705084528.67499f8c@gandalf.local.home>
        <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
        <20170705092757.63dc2328@gandalf.local.home>
        <20170705140607.GA30187@kroah.com>
        <20170705103335.0cbd9984@gandalf.local.home>
        <8c6843e8-73d9-a898-0366-0b72dfeb79a2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8c6843e8-73d9-a898-0366-0b72dfeb79a2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 5 Jul 2017 11:08:48 -0400
Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On 07/05/2017 10:33 AM, Steven Rostedt wrote:
> > No test should be written for a single specific hardware. It should be a
> > general functionality that different hardware can execute.  
> 
> Why? We test all sorts of hardware in userspace and we see value in that
> testing.
> 

One reason is for bit rot. I'm not totally against it. But I envision
that if we have hundreds of tests for very specific pieces of hardware,
it's value will diminish over time. Unless we can get a good
infrastructure written where the hardware info is more of a data sheet
then a single test itself.

-- Steve
