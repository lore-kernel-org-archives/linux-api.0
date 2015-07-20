From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re:
 [linux-4.2-rc3/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c:194:
 bad if condition ?
Date: Mon, 20 Jul 2015 17:09:39 +0200
Message-ID: <20150720150938.GB15916@rei.suse.de>
References: <DUB128-W55FA5DB7B71A53D5E73E289C850@phx.gbl>
 <55AD08C8.4030705@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AD08C8.4030705-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!
> > [linux-4.2-rc3/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c:194]: (style) Expression is always false because 'else if' condition matches previous condition at line 191.
> > 
> > Source code is
> > 
> >         if (res> 0) {
> >             atomic_set(&requeued, 1);
> >             break;
> >         } else if (res> 0) {
> > 
> 
> Hi Daren,
> 
> Is this something that could be fixed?

Looks like a typo to me. My guess is that it should have been:

...
} else if (res < 0) {
...

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
