From: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/2] selftests/pstore: add pstore test script for pre-reboot
Date: Tue, 15 Sep 2015 11:30:40 +0900
Message-ID: <55F782D0.6000501@hitachi.com>
References: <20150908110615.9783.69477.stgit@arietta> <20150908110617.9783.4635.stgit@arietta> <55EF6DC5.2080207@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55EF6DC5.2080207-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, seiji.aguchi.tr-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello Mark,

Thank you for your advise.

 >> +prlog -n "Checking pmsg file contains TEST_STRING ... "
 > Mark this as 'wish to have'

OK. I'll change it to "Checking pmsg file wishes to have TEST_STRING
... ". Should I change other messages in the same way?

 > Can TEST_STRING be given an unique value each run, so that on the the
 > reboot-comparison run it can be found to be an unique match?

Yes. I'll append /proc/sys/kernel/random/uuid content to TEST_STRING.
I'll also change log directory name from date to the uuid.

 > Also confirm that any previous content (which may be binary) is not
 > present after reboot, and that totally new content is present.

OK.
As for pmsg, they are possible by checking if the /sys/fs/pstore/pmsg
content perfectly matches the TEST_STRING which was written to /dev/pmsg
before reboot. (The TEST_STRING can be left to a regular file before
reboot as well as reboot_flag.) Is it OK?

Best regards,
Hiraku Toyooka


-- 
Hiraku Toyooka
Systems Productivity Research Dept. / Linux Technology Center
Center for Technology Innovation - Systems Engineering, Hitachi Ltd.
