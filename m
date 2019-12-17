From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 4/4] samples: Add example of using pidfd getfd in
 conjunction with user trap
Date: Tue, 17 Dec 2019 03:07:24 +0100
Message-ID: <20191217020723.cluy5x2kg5q3ithf@wittgenstein>
References: <20191217010025.GA14479@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191217010025.GA14479@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

On Tue, Dec 17, 2019 at 01:00:27AM +0000, Sargun Dhillon wrote:
> This sample adds the usage of SECCOMP_RET_USER_NOTIF together with pidfd
> GETFD ioctl. It shows trapping a syscall, and handling it by extracting
> the FD into the parent process without stopping the child process.
> Although, in this example, there's no explicit policy separation in
> the two processes, it can be generalized into the example of a transparent
> proxy.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
>  samples/seccomp/.gitignore        |   1 +
>  samples/seccomp/Makefile          |   9 +-
>  samples/seccomp/user-trap-pidfd.c | 190 ++++++++++++++++++++++++++++++

This is a great sample.
Could you please also add tests without seccomp to the pidfd-testsuite
itself under tools/testing/selftests/pidfd. I want to have all pidfd
features tested in one place so that people don't need to run
seccomp-bpf, or compile the optional samples but can just run the pidfd
test-suite and it'll bang on all features.

Christian
