From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [GIT PULL] Kselftest updates for 3.20-rc1
Date: Tue, 10 Feb 2015 11:30:39 +1100
Message-ID: <1423528239.19657.3.camel@ellerman.id.au>
References: <54D8FE1C.5040303@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D8FE1C.5040303-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-02-09 at 11:36 -0700, Shuah Khan wrote:
> Hi Linus,
> 
> Please pull the following Kselftest updates for 3.20-rc1
> 
> thanks,
> -- Shuah
> 
> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
> 
>   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
> tags/linux-kselftest-3.20-rc1
> 
> for you to fetch changes up to 6ddf898c23d62c974e148efd9e509731324a167a:
> 
>   selftests/exec: Check if the syscall exists and bail if not
> (2015-02-04 10:17:35 -0700)
> 
> ----------------------------------------------------------------
> Kselftest updates for 3.20-rc1
> 
> This update adds:
> - Kselftest install target feature
> - Fix for selftests/exec test
> 
> ----------------------------------------------------------------
> Michael Ellerman (1):
>       selftests/exec: Check if the syscall exists and bail if not
> 
> Shuah Khan (20):
>       selftests/breakpoints: add install target to enable test install
>       selftests/cpu-hotplug: add install target to enable test install
>       selftests/efivarfs: add install target to enable test install
>       selftests/firmware: add install target to enable test install
>       selftests/ftrace: add install target to enable test install
>       selftests/ipc: add install target to enable test install
>       selftests/kcmp: add install target to enable test install
>       selftests/memfd: add install target to enable test install
>       selftests/memory-hotplug: add install target to enable test install
>       selftests/mount: add install target to enable test install
>       selftests/mqueue: add install target to enable test install
>       selftests/net: add install target to enable test install
>       selftests/ptrace: add install target to enable test install
>       selftests/size: add install target to enable test install
>       selftests/sysctl: add install target to enable test install
>       selftests/timers: add install target to enable test install
>       selftests/user: add install target to enable test install
>       selftests/vm: add install target to enable test install
>       selftests: add install target to enable test install
>       kbuild: add a new kselftest_install make target to install selftests


I don't understand why you insist on merging this series with the logic copied
18 times.

I'm happy to tweak my series that uses an include file, but I don't see the
point of merging this series first when almost every line will be removed when
my series goes in.

  https://lkml.org/lkml/2015/1/9/45

cheers
