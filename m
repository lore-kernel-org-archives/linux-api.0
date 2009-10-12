From: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Mon, 12 Oct 2009 15:33:11 -0400
Message-ID: <3e8340490910121233j17ebeb85m69e18566978b5ba2@mail.gmail.com>
References: <2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com>
	<3e8340490910100011u17497293o613334c64f1543c8@mail.gmail.com>
	<20091013031853.C744.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091013031853.C744.A69D9226-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Timo Sirainen <tss-X3B1VOXEql0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 12, 2009 at 3:03 PM, KOSAKI Motohiro
<kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> Hi
>
> Sorry for the delaying.
>
>> On Sat, Oct 10, 2009 at 2:32 AM, KOSAKI Motohiro
>> <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>>
>> >> It does seem like a maximum spin count should be put in there - and
>> >> maybe a timeout as well (since with FUSE etc it's possible to engineer
>> >> page faults that take arbitrarily long).
>> >> Also, it occurs to me that:
>> >
>> > makes sense.
>> > I like maximum spin rather than timeout.
>>
>> I'm worried about the scenario where process A sets its cmdline buffer
>> to point to a page which will take a _VERY_ long time to pagein (maybe
>> forever), and then process B goes to try to read its cmdline. What
>> happens now?
>
> Honestly, I don't worry about so much. if attacker want DoS attack, fork bomb is
> efficient than this way. then, attacker never use this.

Fork bombs and etc can be mitigated by resource limits; but if the
command line is placed on a page that will take a very long time to
fault, then that cannot be mitigated... But again, this DoS already
exists and isn't any easier with this patch, so I think it's a
separate issue.

>> Process A can arrange for this to happen by using a FUSE filesystem
>> that sits on a read forever. And since the first thing the admin's
>> likely to do to track down the problem is 'ps awux', this is liable to
>> be a rather nasty DoS...
>
> Probably, I haven't understand this paragraph. Why is this FUSE related issue?

Just an example of how one can create a page that will take a very
long time to fault in.
