From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH 1/2] selftests/pstore: add pstore test script for
 pre-reboot
Date: Mon, 21 Sep 2015 14:04:16 -0700
Message-ID: <560070D0.90709@android.com>
References: <20150908110615.9783.69477.stgit@arietta>
 <20150908110617.9783.4635.stgit@arietta> <55EF6DC5.2080207@android.com>
 <55F782D0.6000501@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55F782D0.6000501@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>, linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Shuah Khan <shuahkh@osg.samsung.com>, Colin Cross <ccross@android.com>, seiji.aguchi.tr@hitachi.com
List-Id: linux-api@vger.kernel.org

On 09/14/2015 07:30 PM, Hiraku Toyooka wrote:
> Hello Mark,
>
> Thank you for your advise.
>
> >> +prlog -n "Checking pmsg file contains TEST_STRING ... "
> > Mark this as 'wish to have'
>
> OK. I'll change it to "Checking pmsg file wishes to have TEST_STRING
> ... ". Should I change other messages in the same way?

I was referring to the list of enhancements to the testing (below), not 
the message in the logs ;-}

Sorry for taking so long to respond, got preoccupied ...
>
> > Can TEST_STRING be given an unique value each run, so that on the the
> > reboot-comparison run it can be found to be an unique match?
>
> Yes. I'll append /proc/sys/kernel/random/uuid content to TEST_STRING.
> I'll also change log directory name from date to the uuid.

Cool

>
> > Also confirm that any previous content (which may be binary) is not
> > present after reboot, and that totally new content is present.
>
> OK.
> As for pmsg, they are possible by checking if the /sys/fs/pstore/pmsg
> content perfectly matches the TEST_STRING which was written to /dev/pmsg
> before reboot. (The TEST_STRING can be left to a regular file before
> reboot as well as reboot_flag.) Is it OK?

Perfectly match is an issue, since something else might be using pmsg. 
For instance, one of the applications that uses this interface 
packetizes the messages so they can be picked out from other sources 
that do not comply with the header (count, magic number etc). In this 
case, should that daemon be active, your content would be ignores, but 
your content would also be buried, but can be needled out with grep.

What you should do is grep for your string pattern within some 
acceptable regex, and one should be found and no other, and it should 
match perfectly. This would prevent another daemon's content from 
disrupting your test and causing a false negative.
>
> Best regards,
> Hiraku Toyooka
>
Sincerely -- Mark Salyzyn
