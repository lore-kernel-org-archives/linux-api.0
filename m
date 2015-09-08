From: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/2] selftests/pstore: add pstore test script for pre-reboot
Date: Tue, 08 Sep 2015 16:22:45 -0700
Message-ID: <55EF6DC5.2080207@android.com>
References: <20150908110615.9783.69477.stgit@arietta> <20150908110617.9783.4635.stgit@arietta>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150908110617.9783.4635.stgit@arietta>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/08/2015 04:06 AM, Hiraku Toyooka wrote:
> The pstore_tests script includes test cases which check pstore's
> behavior before crash (and reboot).
>
> The test cases are currently following.
>
> - Check pstore backend is registered
> - Check pstore console is registered
> - Check /dev/pmsg0 exists
> - Write string to /dev/pmsg0
>
> . . .
> +TEST_STRING="Testing pstore"
. . .
> +prlog -n "Checking pmsg file contains TEST_STRING ... "
> +grep -q "${TEST_STRING}" pmsg-${backend}-0
Mark this as 'wish to have'

Can TEST_STRING be given an unique value each run, so that on the the 
reboot-comparison run it can be found to be an unique match? Also 
confirm that any previous content (which may be binary) is not present 
after reboot, and that totally new content is present.

Sincerely -- Mark Salyzyn
