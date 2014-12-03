From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
Date: Wed, 03 Dec 2014 14:43:11 +1100
Message-ID: <1417578191.16722.11.camel@concordia>
References: <547E854E.5060101@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <547E854E.5060101@sonymobile.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Bird <tim.bird@sonymobile.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2014-12-02 at 19:36 -0800, Tim Bird wrote:
> This test shows the amount of memory used by the system.
> Note that this is dependent on the user-space that is loaded
> when this program runs.  Optimally, this program would be
> run as the init program itself.

Sorry to only chime in at v5.

> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
> new file mode 100644
> index 0000000..47f8e9c
> --- /dev/null
> +++ b/tools/testing/selftests/size/Makefile
> @@ -0,0 +1,15 @@
> +#ifndef CC
> +	CC = $(CROSS_COMPILE)gcc
> +#endif

I think the following is preferable:

  CC := $(CROSS_COMPILE)$(CC)


It allows optionally setting a custom CC, as well as optionally CROSS_COMPILE.

The only thing it doesn't do is choose gcc explicitly, but you shouldn't really
do that anyway - unless you absolutely require gcc. Let the user choose their
compiler by choosing where cc points.

cheers
