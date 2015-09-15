From: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/pstore: add pstore test scripts going with
 reboot
Date: Tue, 15 Sep 2015 11:41:39 +0900
Message-ID: <55F78563.50006@hitachi.com>
References: <20150908110615.9783.69477.stgit@arietta>	<20150908110620.9783.33823.stgit@arietta> <CAGXu5j+Ha0t-acFc+morgUiDRCHGdx8QHySX29PYpnj4QFiJhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+Ha0t-acFc+morgUiDRCHGdx8QHySX29PYpnj4QFiJhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, seiji.aguchi.tr-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello Kees,

 >> +run_crash:
 >> +       @sh pstore_crash_test || echo "pstore_crash_test: [FAIL]"
 >
 > This is probably better written to exit 1 on failure, otherwise it
 > just _says_ it fails. (Though lots of selftests in the tree already
 > have this problem, it's best to avoid the pattern for new stuff.)
 > Maybe something like:
 >
 >      @sh pstore_crash_test || { echo "pstore_crash_test: [FAIL]"; 
exit 1; }

OK. I'll add the "exit 1".

 >> +prlog -n "Checking dmesg files exist in pstore filesystem ... "
 >> +if [ -e dmesg-${backend}-0 ]; then
 >> +    prlog "ok"
 >> +    for f in `ls dmesg-${backend}-*`; do
 >> +       prlog -e "\t${f}"
 >> +    done
 >> +else
 >> +    prlog "FAIL"
 >> +    rc=1
 >> +fi
 >
 > This test pattern is repeated a lot. Maybe better to create a helper
 > function instead? It could make the tests much more readable.

Yes, I should make a helper function in v2.

Best regards,
Hiraku Toyooka
