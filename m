From: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] selftests/pstore: add pstore test script for
 pre-reboot
Date: Fri, 2 Oct 2015 12:39:07 -0700
Message-ID: <560EDD5B.5090901@android.com>
References: <20151002114637.20957.61769.stgit@arietta>
 <20151002114639.20957.61229.stgit@arietta>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151002114639.20957.61229.stgit@arietta>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Seiji Aguchi <seiji.aguchi.tr-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/02/2015 04:46 AM, Hiraku Toyooka wrote:
> The pstore_tests script includes test cases which check pstore's
> behavior before crash (and reboot).
>
> The test cases are currently following.
>
> - Check pstore backend is registered
> - Check pstore console is registered
> - Check /dev/pmsg0 exists
> - Write unique string to /dev/pmsg0
>
+1
