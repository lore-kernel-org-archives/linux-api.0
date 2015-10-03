From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] kselftest: replace $(RM) with rm -f command
Date: Sat, 3 Oct 2015 14:11:57 +0000 (UTC)
Message-ID: <1486799898.16862.1443881517178.JavaMail.zimbra@efficios.com>
References: <20150925154415.GC38748@vmdeb7> <1443406217-137773-1-git-send-email-long.wanglong@huawei.com> <1201012824.5792.1443410213729.JavaMail.zimbra@efficios.com> <20151003043808.GA90454@vmdeb7>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151003043808.GA90454@vmdeb7>
Sender: linux-kernel-owner@vger.kernel.org
To: dvhart <dvhart@infradead.org>
Cc: Wang Long <long.wanglong@huawei.com>, shuahkh@osg.samsung.com, Michael Ellerman <mpe@ellerman.id.au>, keescook@chromium.org, davem@davemloft.net, luto@amacapital.net, wad@chromium.org, Andrew Morton <akpm@linux-foundation.org>, gorcunov <gorcunov@openvz.org>, cov@codeaurora.org, bobby prani <bobby.prani@gmail.com>, tyler baker <tyler.baker@linaro.org>, Tim Bird <tim.bird@sonymobile.com>, josh@joshtriplett.org, Andrea Arcangeli <aarcange@redhat.com>, andrej skvortzov <andrej.skvortzov@gmail.com>, sjayaram <sjayaram@akamai.com>, treding@nvidia.com, Ingo Molnar <mingo@kernel.org>, naresh kamboju <naresh.kamboju@linaro.org>, alexey kodanev <alexey.kodanev@oracle.com>, linux-api <linux-api@vger.kernel.org>, linux-kernel@vger.kernel.org, wanglong <wanglong@laoqinren.net>
List-Id: linux-api@vger.kernel.org

----- On Oct 3, 2015, at 12:38 AM, dvhart dvhart@infradead.org wrote:

> On Mon, Sep 28, 2015 at 03:16:53AM +0000, Mathieu Desnoyers wrote:
>> ----- On Sep 27, 2015, at 10:10 PM, Wang Long long.wanglong@huawei.com wrote:
>> 
>> > Some test's Makefile using "$(RM)" while the other's
>> > using "rm -f". It is better to use one of them in all
>> > tests.
>> 
>> I agree that this disparity appears to be unwanted. We
>> should settle on one or the other.
>> 
>> > 
>> > "rm -f" is better, because it is less magic, and everyone
>> > konws what is does.
>> 
>> "$(RM)" is clearly defined as a Makefile implicit variable
>> which defaults to "rm -f".
>> Ref. https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
>> 
>> Leaving it as a variable is more flexible because then the
>> default behavior can be overridden if need be, which is
>> not the case of a hardcoded "rm -f".
>> 
>> Following your line of argumentation, we should then
>> invoke "gcc" directly in every Makefile because it is
>> less magic than "$(CC)". This makes no sense.
> 
> I don't think they can be compared so simply. Specifying a compiler is a common
> use case. Customizing the rm command is not, in my experience anyway, and like
> Michael, I would definately have to look up what RM means.
> 
> That said, I care more about consistency than which is used. Both are valid, but
> $(RM), while more flexible, will cost more people time to look up what it does
> as it isn't commonly used than any benefit we're likely to see from its use.
> 
> Meh. :-)

An example is "grm" when you install the opencsw repository
packages on Solaris. In the unlikely example where someone
would have a Solaris machine to build Linux, overriding
various command names, including "rm", can be useful. This
is just one example, there are probably others.

Thanks,

Mathieu

> 
> --
> Darren Hart
> Intel Open Source Technology Center

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
