From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v2 1/2] samples, selftests/seccomp: Zero out seccomp_notif
Date: Sat, 28 Dec 2019 10:25:34 +0100
Message-ID: <20191228092533.wm6w3r7eyhif5pfi@wittgenstein>
References: <20191228014837.GA31774@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191228014837.GA31774@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tycho@tycho.ws, jannh@google.com, keescook@chromium.org, cyphar@cyphar.com
List-Id: linux-api@vger.kernel.org

On Sat, Dec 28, 2019 at 01:48:39AM +0000, Sargun Dhillon wrote:
> The seccomp_notif structure should be zeroed out prior to calling the
> SECCOMP_IOCTL_NOTIF_RECV ioctl. Previously, the kernel did not check
> whether these structures were zeroed out or not, so these worked.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Cc: Kees Cook <keescook@chromium.org>

Can you please also add a test, that verifies that we catch garbage
values, please?
