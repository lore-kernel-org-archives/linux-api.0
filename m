From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: rt-tester - move under selftests
Date: Mon, 3 Nov 2014 20:54:09 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1411032052560.5308@nanos>
References: <5446BDC6.4040502@osg.samsung.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5446BDC6.4040502-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 21 Oct 2014, Shuah Khan wrote:
> Andrew/Ingo/Thomas,
> 
> You are all on the signed-off list for rt-tester. I have been poking
> around the source tree looking for existing test and came across rt-tester.
> 
> What are your thoughts on rt-tester suitability to reside under
> tools/testing/selftest and becoming part of kselftest target?
> Would you like see it moved under the kselftest umbrella?

Sure you can move it, but it is broken and needs a complete
rewrite. So the proper solution is to remove it. I kept it there as a
reminder to fix it, but obviously I never managed to do so.

Thanks,

	tglx
