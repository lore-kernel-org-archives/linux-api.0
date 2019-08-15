From: shuah <shuah@kernel.org>
Subject: Re: [PATCHv6 30/36] selftest/timens: Add Time Namespace test for
 supported clocks
Date: Thu, 15 Aug 2019 17:18:21 -0600
Message-ID: <02add700-b626-a1b4-09e1-1e4d5cd242f2@kernel.org>
References: <20190815163836.2927-1-dima@arista.com>
 <20190815163836.2927-31-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190815163836.2927-31-dima@arista.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, shuah <shuah@kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Dmitry,

Thanks for the patch.

On 8/15/19 10:38 AM, Dmitry Safonov wrote:
> A test to check that all supported clocks work on host and inside
> a new time namespace. Use both ways to get time: through VDSO and
> by entering the kernel with implicit syscall.
> 
> Introduce a new timens directory in selftests framework for
> the next timens tests.
> 
> Co-developed-by: Andrei Vagin <avagin@openvz.org>
> Signed-off-by: Andrei Vagin <avagin@openvz.org>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>   tools/testing/selftests/Makefile          |   1 +
>   tools/testing/selftests/timens/.gitignore |   1 +
>   tools/testing/selftests/timens/Makefile   |   5 +
>   tools/testing/selftests/timens/config     |   1 +
>   tools/testing/selftests/timens/log.h      |  26 +++
>   tools/testing/selftests/timens/timens.c   | 185 ++++++++++++++++++++++
>   tools/testing/selftests/timens/timens.h   |  63 ++++++++
>   7 files changed, 282 insertions(+)
>   create mode 100644 tools/testing/selftests/timens/.gitignore
>   create mode 100644 tools/testing/selftests/timens/Makefile
>   create mode 100644 tools/testing/selftests/timens/config
>   create mode 100644 tools/testing/selftests/timens/log.h
>   create mode 100644 tools/testing/selftests/timens/timens.c
>   create mode 100644 tools/testing/selftests/timens/timens.h
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 25b43a8c2b15..6fc63b84a857 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -47,6 +47,7 @@ TARGETS += splice
>   TARGETS += static_keys
>   TARGETS += sync
>   TARGETS += sysctl
> +TARGETS += timens

How long does this test run for? Does this test need to be run
as root? If yes, please add a root check and skip the test.

What does the test output looks like for skip and pass/fail cases?

thanks,
-- Shuah
