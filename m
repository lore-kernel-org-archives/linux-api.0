From: Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Subject: Re: [PATCH RFC v3 1/6] exterr: Introduce extended syscall error
 reporting
Date: Tue, 15 Sep 2015 19:02:19 +0200
Message-ID: <1442336539.1914.34.camel@sipsolutions.net>
References: <1441987205-4021-1-git-send-email-alexander.shishkin@linux.intel.com>
	 <1441987205-4021-2-git-send-email-alexander.shishkin@linux.intel.com>
	 <20150914141931.39f6be92@lwn.net>
	 <87a8snn4zz.fsf@ashishki-desk.ger.corp.intel.com>
	 <1442327514.1914.31.camel@sipsolutions.net>
	 <877fnrn1sj.fsf@ashishki-desk.ger.corp.intel.com>
	 <20150915103556.36b06f09@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150915103556.36b06f09-T1hC0tSOHrs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org, eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Arnaldo Carvalho de Melo <acme-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


> I think that anything other than the errno "grab it now or lose it"
> behavior will prove confusing.  I don't think there is any other way to
> know that a given error report corresponds to a specific system call.
> Library calls can mess it up.  Kernel changes adding extended reporting to
> new system calls can mess it up.  Applications cannot possibly be expected
> to know which system calls might change the error-reporting status, they
> *have* to assume all of them will.
> 

Yeah I was about to say something similar - an application that expects
a certain syscall to have extended errors will get confused if running
on an older kernel where that syscall in fact does *not* have extended
errors (and thus also doesn't clear extended errors) and therefore the
extended error from a previous syscall could still be lingering on (for
example because the application didn't care to fetch it for that previo
us syscall.)

johannes
