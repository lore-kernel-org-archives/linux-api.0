From: Shuah Khan <shuahkhan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: selftests: question about git repos containing selftest.
Date: Tue, 9 Dec 2014 13:34:06 -0700
Message-ID: <CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	<20141209194602.GB20166@kroah.com>
	<CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
	<7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21-/aPJBeqlRkAyyULh10xnlCahX2Nl78RV0E9HWUfgJXw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Young, David" <dayoung-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 9, 2014 at 1:25 PM, Young, David <dayoung-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
> Thanks, I was definitely looking at the master branch of linux-kselftest.
>
> There are still more changes in linux-next repo, should those be considered as "in progress"?
>

Patches in linux-kselftest fixes branch are the ones I included in my
pull request
I just sent out. linux-next might have some selftest patches that are part of a
series that depend on a sub-system API. Maybe that is what you are seeing
in linux-next.

For example there are ftrace selftest patches in linux-next that
depend on ftrace
sub-system, hence they funnel through ftrace. Same thing happens with mm
related things.

Do you have specific patches in linux-next that you have questions about?

-- Shuah
