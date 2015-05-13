From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Tue, 12 May 2015 20:34:57 -0700
Message-ID: <20150513033457.GC33724@fury.dvhart.com>
References: <55512B86.2040900@osg.samsung.com>
 <D1767EA1.CC3DA%dvhart@linux.intel.com>
 <20150512100256.GA5122@rei.suse.de>
 <D1777231.CC5D0%dvhart@linux.intel.com>
 <20150512200528.GA1336@rei>
 <D177AD46.CC848%dvhart@linux.intel.com>
 <55526544.90909@osg.samsung.com>
 <D177B3F7.CC8C3%dvhart@linux.intel.com>
 <55526DF1.1020103@osg.samsung.com>
 <55526EC8.30707@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55526EC8.30707-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 03:21:12PM -0600, Shuah Khan wrote:
> On 05/12/2015 03:17 PM, Shuah Khan wrote:
> > On 05/12/2015 02:54 PM, Darren Hart wrote:
> >> On 5/12/15, 1:40 PM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
> >>
> >>> On 05/12/2015 02:15 PM, Darren Hart wrote:
> >>>> On 5/12/15, 1:05 PM, "Cyril Hrubis" <chrubis-AlSwsSmVLrQ@public.gmane.org> wrote:
> >>>>
> >>>>> Hi!
> >>>>>>>> I'm happy to do that, but I would like to make sure I'm doing the
> >>>>>> right
> >>>>>>>> thing.
> >>>>>>>
> >>>>>>> The right thing here is to add -pthread to CFLAGS which sets both
> >>>>>>> flags
> >>>>>>> for preprocessor and linker (see man gcc).
> >>>>>>
> >>>>>> Hi Cyril,
> >>>>>>
> >>>>>> Thanks. I read that, and mentioned it, but my concern with -pthread in
> >>>>>> the
> >>>>>> CFLAGS and LDFLAGS is that it is a non-standard compiler flag. I
> >>>>>> understand we have a number of gcc-isms in our build - but do we want
> >>>>>> to
> >>>>>> add more?
> >>>>>>
> >>>>>> I'm also struggling to find any kind of prescribed documentation on
> >>>>>> this
> >>>>>> beyond the short blurb in the gcc man page which describes what this
> >>>>>> option does, but not when to use it. I'll need something concrete to
> >>>>>> justify changes to testcase Makefiles to Shuah.
> >>>>>
> >>>>> Sorry to mislead you with the pointing at gcc man page.
> >>>>>
> >>>>> It is a Linux standard. Have a look at pthreads manual page:
> >>>>> http://man7.org/linux/man-pages/man7/pthreads.7.html
> >>>>>
> >>>>> "On Linux, programs that use the Pthreads API should be compiled using
> >>>>> cc -pthread."
> >>>>>
> >>>>> Or any pthread_foo() manual page that starts with:
> >>>>>
> >>>>> "Compile and link with -pthread."
> >>>>>
> >>>>> The portable way i.e. POSIX would be getting compiler flags with
> >>>>> getconf
> >>>>> but as this is a Linux kernel testsuite I would not bother with that.
> >>>>> Hmm, and it looks like this is not implemented on Linux anyway.
> >>>>
> >>>> Thanks Cyril, that's perfect.
> >>>>
> >>>> I'll roll my latest example patch adding -pthread to LDFLAGS and CFLAGS
> >>>> into the initial patch and resubmit the patch series as v4.
> >>>>
> >>>
> >>> Daren,
> >>>
> >>> While you are generating new version, could you also please add
> >>> .gitignore for the futex binaries, so they get ignored by git.
> >>
> >> Will do.
> >>
> > 
> > Daren,
> > 
> > Do you plan to add futex test install support in a later patch
> > series? When you sent this patch series, install support was
> > work in progress. 4.1 has the kselftest install feature.
> > 
> > Feel free to defer it for a later patch series if you like. Would
> > be good to get the futex install support into 4.2 if it is possible.
> > 
> 
> I am blind. Never mind. futex tests are installed.

Oh good - I just reviewed my patches and could swear it was all there!

I'll add the .gitignore now and roll out v4 with all the cleanups and pthread
linker fixes.

-- 
Darren Hart
Intel Open Source Technology Center
