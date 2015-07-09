From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC 5/8] kdbus: use LSM hooks in kdbus code
Date: Thu, 09 Jul 2015 13:28:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1507091328230.12730@AMDC1262.digital.local>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-6-git-send-email-p.osmialowsk@samsung.com>
 <1436353775.2331.2.camel@samsung.com>
 <alpine.DEB.2.10.1507081411410.12441@AMDC1262.digital.local>
 <20150709105510.GI25971@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20150709105510.GI25971-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
Cc: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Lukasz Skalski <l.skalski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On Thu, 9 Jul 2015, Sergei Zviagintsev wrote:

> Hi,
>
> On Wed, Jul 08, 2015 at 02:12:03PM +0200, Paul Osmialowski wrote:
> [...]
>>
>> +	ret = security_kdbus_bus_alloc(b);
>> +	if (ret) {
>> +		goto exit_unref;
>> +	}
>
> checkpatch.pl will complain about this
>
>

It should but it didn't:

$ scripts/checkpatch.pl 0005-kdbus-use-LSM-hooks-in-kdbus-code.patch
total: 0 errors, 0 warnings, 365 lines checked

0005-kdbus-use-LSM-hooks-in-kdbus-code.patch has no obvious style problems 
and is ready for submission.
