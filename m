From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH RFC v3 1/6] exterr: Introduce extended syscall error
 reporting
Date: Tue, 15 Sep 2015 10:35:56 -0600
Message-ID: <20150915103556.36b06f09@lwn.net>
References: <1441987205-4021-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1441987205-4021-2-git-send-email-alexander.shishkin@linux.intel.com>
	<20150914141931.39f6be92@lwn.net>
	<87a8snn4zz.fsf@ashishki-desk.ger.corp.intel.com>
	<1442327514.1914.31.camel@sipsolutions.net>
	<877fnrn1sj.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <877fnrn1sj.fsf-qxRn5AmX6ZD9BXuAQUXR0fooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org, eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Arnaldo Carvalho de Melo <acme-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[Rather belatedly looping in linux-api]

On Tue, 15 Sep 2015 18:24:28 +0300
Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org> writes:
> 
> > On Tue, 2015-09-15 at 17:15 +0300, Alexander Shishkin wrote:  
> >>   
> >> > It seems to me that current->ext_err_code needs to be cleared on 
> >> > each system call entry (except for your special prctl() of 
> >> > course!).  
> >> 
> >> I'd say, it should be up to the program to decide for how long they 
> >> want to keep the extended error code around.
> >>   
> >
> > I'm not convinced that works - imagine a library wanting to use the
> > prctl(), but the main application isn't doing that. Should the library
> > clear it before every call, to be sure it's not getting stale data?
> > etc.  
> 
> In other words, a syscall that's capable of throwing an extended error
> does clear the current::ext_err_code every time, but not other
> syscalls. Otherwise it will indeed get very confusing.

I think that anything other than the errno "grab it now or lose it"
behavior will prove confusing.  I don't think there is any other way to
know that a given error report corresponds to a specific system call.
Library calls can mess it up.  Kernel changes adding extended reporting to
new system calls can mess it up.  Applications cannot possibly be expected
to know which system calls might change the error-reporting status, they
*have* to assume all of them will.

Or so it seems to me, anyway...

jon
