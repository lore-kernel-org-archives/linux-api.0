From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Tue, 12 May 2015 10:47:14 -0600
Message-ID: <55522E92.8090609@osg.samsung.com>
References: <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com> <5550EF8D.8080403@osg.samsung.com> <D1763F31.CC237%dvhart@linux.intel.com> <5550FB2C.1000403@osg.samsung.com> <D17653E0.CC29F%dvhart@linux.intel.com> <5551164E.5080409@osg.samsung.com> <D17670E1.CC354%dvhart@linux.intel.com> <55512B54.50304@osg.samsung.com> <55512B86.2040900@osg.samsung.com> <D1767EA1.CC3DA%dvhart@linux.intel.com> <20150512100256.GA5122@rei.suse.de> <D1777231.CC5D0%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D1777231.CC5D0%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/12/2015 10:10 AM, Darren Hart wrote:
> On 5/12/15, 3:02 AM, "Cyril Hrubis" <chrubis-AlSwsSmVLrQ@public.gmane.org> wrote:
> 
>> Hi!
>>> I'm happy to do that, but I would like to make sure I'm doing the right
>>> thing.
>>
>> The right thing here is to add -pthread to CFLAGS which sets both flags
>> for preprocessor and linker (see man gcc).
> 
> Hi Cyril,
> 
> Thanks. I read that, and mentioned it, but my concern with -pthread in the
> CFLAGS and LDFLAGS is that it is a non-standard compiler flag. I
> understand we have a number of gcc-isms in our build - but do we want to
> add more?
> 
> I'm also struggling to find any kind of prescribed documentation on this
> beyond the short blurb in the gcc man page which describes what this
> option does, but not when to use it. I'll need something concrete to
> justify changes to testcase Makefiles to Shuah.
> 
> Unfortunately, all these options are functional for me, while some are not
> for Shuah, so I'm currently having to rely on documentation which seems
> pretty sparse.
> 

Hi Daren,

My goals are really simple. make kselftest doesn't break. All tests
compile and run and install or fail gracefully when dependencies aren't
met. As long as the above are met, I don't really worry about what
individual test Makefiles do.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
