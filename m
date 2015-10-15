From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v3] selftests/seccomp: build and pass on arm64
Date: Thu, 15 Oct 2015 08:07:59 -0600
Message-ID: <561FB33F.5030906@osg.samsung.com>
References: <20151006193025.GA11826@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151006193025.GA11826@www.outflux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 10/06/2015 01:30 PM, Kees Cook wrote:
> Changing arm64 syscalls is done via a specific register set, more like s390
> than like arm (specific ptrace call) and x86 (part of general registers).
> Since (restarting) poll doesn't exist on arm64, switch to using nanosleep
> for testing restart_syscall. And since it looks like the syscall ABI is
> inconsistent on arm-compat, so we must work around it (and document it) in
> the test.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v3:
>  - correctly set syscall number on native arm64.
> v2:
>  - switch to nanosleep from a bad mix of poll and ppoll for testing restart.
> ---

Is this good to go? Failed to apply to linux-kselftest next.
If you can rebase and resend. I can get this into 4.4-rc1

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
