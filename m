From: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/2] selftests/pstore: add pstore test script for pre-reboot
Date: Tue, 29 Sep 2015 16:18:48 +0900
Message-ID: <560A3B58.9060403@hitachi.com>
References: <20150908110615.9783.69477.stgit@arietta> <20150908110617.9783.4635.stgit@arietta> <55EF6DC5.2080207@android.com> <55F782D0.6000501@hitachi.com> <560070D0.90709@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560070D0.90709-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, seiji.aguchi.tr-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

I'm sorry for my late reply.

Mark Salyzyn wrote:
> Perfectly match is an issue, since something else might be using pmsg.
> For instance, one of the applications that uses this interface
> packetizes the messages so they can be picked out from other sources
> that do not comply with the header (count, magic number etc). In this
> case, should that daemon be active, your content would be ignores, but
> your content would also be buried, but can be needled out with grep.
>
> What you should do is grep for your string pattern within some
> acceptable regex, and one should be found and no other, and it should
> match perfectly. This would prevent another daemon's content from
> disrupting your test and causing a false negative.

OK. I think that the following method suit your intention.
By splitting unique test string into TEST_STRING_PATTERN part and UUID
part, we can check both the non-existence of previous content and the
unique match on reboot-comparison run.
I'll include this in v2.

# before crash
TEST_STRING_PATTERN="Testing pstore: uuid="
UUID=`cat /proc/sys/kernel/random/uuid`
echo "$TEST_STRING_PATTERN""$UUID" > /dev/pmsg0
echo "$UUID" > uuid

# after crash
prlog -n "Checking pmsg file properly keeps the content written before 
crash ... "
nr_matched=`grep -c "$TEST_STRING_PATTERN" pmsg-${backend}-0`
if [ $nr_matched -eq 1 ]; then
     grep -q "$TEST_STRING_PATTERN"`cat uuid` pmsg-${backend}-0
     if [ $? -eq 0 ]; then
         prlog "ok"
     else
         prlog "FAIL"
else
     prlog "FAIL"
fi


Best regards,
Hiraku Toyooka
