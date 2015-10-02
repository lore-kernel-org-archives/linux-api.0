From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v2 2/2] selftests/pstore: add pstore test scripts going
 with reboot
Date: Fri, 2 Oct 2015 12:39:39 -0700
Message-ID: <560EDD7B.1000406@android.com>
References: <20151002114637.20957.61769.stgit@arietta>
 <20151002114641.20957.60082.stgit@arietta>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151002114641.20957.60082.stgit@arietta>
Sender: linux-kernel-owner@vger.kernel.org
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>, linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Shuah Khan <shuahkh@osg.samsung.com>, Colin Cross <ccross@android.com>, Seiji Aguchi <seiji.aguchi.tr@hitachi.com>
List-Id: linux-api@vger.kernel.org

On 10/02/2015 04:46 AM, Hiraku Toyooka wrote:
> To test pstore in earnest, we have to cause kernel crash and check
> pstore filesystem after reboot.
>
> We add two scripts:
>   - pstore_crash_test
>       This script causes kernel crash and reboot. It is executed by
>       'make run_pstore_crash' in selftests. It can also be used with kdump.
>   - pstore_post_reboot_tests
>       This script includes test cases which check pstore's behavior after
>       crash and reboot. It is executed together with pstore_tests by
>       'make run_tests [-C pstore]' in selftests.
>
+1
