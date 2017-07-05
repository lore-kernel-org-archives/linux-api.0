From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 12:47:25 -0700
Message-ID: <CAPcyv4in4xtyL0qk86QQJpofwn-+HZSsRqTAHLQ6fTmJNkOjWw@mail.gmail.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home> <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home> <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home> <20170705140607.GA30187@kroah.com>
 <CAPcyv4iOV2-hndx1rQmpPQF+myp=P8rmpf5JhXQXZxPhR6qoQw@mail.gmail.com> <20170705184544.GB22044@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705184544.GB22044-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit <ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 5, 2017 at 11:45 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Jul 05, 2017 at 09:54:29AM -0700, Dan Williams wrote:
>>
>> I wrote some test infrastructure to go after xhci TRB boundary
>> conditions [1]. So, yes, some of these are possible to unit test, but
>> of course not all.
>>
>> [1]: http://marc.info/?l=linux-usb&m=140872785411304&w=2
>
> I forgot about that, what ever happened to it, any reason it never got
> merged?

Ran out of time before being consumed by NVDIMM stuff, but I did take
some of the lessons learned over into tools/testing/nvdimm/. I haven't
done the work to integrate that into kselftest, so far it's only
exercised by the tests in the 'ndctl' [1] utility.

[1]: https://github.com/pmem/ndctl
