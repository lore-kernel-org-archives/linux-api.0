From: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Fri, 31 Oct 2014 11:58:35 +0100
Message-ID: <54536B5B.1050604@samsung.com>
References: <54520A21.20404@samsung.com> <54521697.1030900@samsung.com>
 <20141030144709.GA19721@kroah.com> <545297CC.6020306@samsung.com>
 <20141030231310.0b65b762@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20141030231310.0b65b762-mUKnrFFms3BCCTY1wZZT65JpZx93mCW/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2014-10-31 00:13, One Thousand Gnomes wrote:
>>> The core calls are already mediated by LSM today, right?  We don't want
>>> anyone to be parsing the data stream through an LSM, that idea got
>>> rejected a long time ago as something that is really not a good idea.
>>
>> Parsing data is out of question, of course, but this is not what we were
>> proposing.
> 
> Why is it out of the question. If it's a socket you can just a BPF filter
> on it, so why can't kdbus support similar basic functionality ?

Fair point.  I think that none of us simply considered this till now.

Thanks
-- 
Karol Lewandowski, Samsung R&D Institute Poland
