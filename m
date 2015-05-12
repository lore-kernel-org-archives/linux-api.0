From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Tue, 12 May 2015 12:02:56 +0200
Message-ID: <20150512100256.GA5122@rei.suse.de>
References: <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
 <5550EF8D.8080403@osg.samsung.com>
 <D1763F31.CC237%dvhart@linux.intel.com>
 <5550FB2C.1000403@osg.samsung.com>
 <D17653E0.CC29F%dvhart@linux.intel.com>
 <5551164E.5080409@osg.samsung.com>
 <D17670E1.CC354%dvhart@linux.intel.com>
 <55512B54.50304@osg.samsung.com>
 <55512B86.2040900@osg.samsung.com>
 <D1767EA1.CC3DA%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D1767EA1.CC3DA%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!
> I'm happy to do that, but I would like to make sure I'm doing the right
> thing.

The right thing here is to add -pthread to CFLAGS which sets both flags
for preprocessor and linker (see man gcc).

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
