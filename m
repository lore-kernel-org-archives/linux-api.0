From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2] selftest: size: Add size test for Linux kernel
Date: Thu, 20 Nov 2014 14:58:39 -0700
Message-ID: <546E640F.1090006@osg.samsung.com>
References: <546D084D.20002@sonymobile.com> <546D321F.2080405@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546D321F.2080405-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/19/2014 05:13 PM, Tim Bird wrote:
> 
> This test shows the amount of memory used by the system.
> Note that this is dependent on the user-space that is loaded
> when this program runs.  Optimally, this program would be
> run as the init program itself.
> 
> The program is optimized for size itself, to avoid conflating
> its own execution with that of the system software.
> The code is compiled statically, with no stdlibs. On my x86_64 system,
> this results in a statically linked binary of less than 5K.
> 
> Changes from v1:
>   - use more correct Copyright string in get_size.c
> 
> Signed-off-by: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
> ---
>  tools/testing/selftests/Makefile        |   1 +
>  tools/testing/selftests/size/Makefile   |  21 +++++++
>  tools/testing/selftests/size/get_size.c | 105 ++++++++++++++++++++++++++++++++
>  3 files changed, 127 insertions(+)
>  create mode 100644 tools/testing/selftests/size/Makefile
>  create mode 100644 tools/testing/selftests/size/get_size.c

Tim,

The test looks good, but you are missing .gitignore file.
Please add a .gitignore for the binary that gets generated to
avoid git status including the binary it in its output.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
