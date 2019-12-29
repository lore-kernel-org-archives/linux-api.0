From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 1/3] samples, selftests/seccomp: Zero out seccomp_notif
Date: Sun, 29 Dec 2019 17:11:28 +0100
Message-ID: <20191229161126.xcrnzdqu5frrov6q@wittgenstein>
References: <20191229062451.9467-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191229062451.9467-1-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 28, 2019 at 10:24:49PM -0800, Sargun Dhillon wrote:
> The seccomp_notif structure should be zeroed out prior to calling the
> SECCOMP_IOCTL_NOTIF_RECV ioctl. Previously, the kernel did not check
> whether these structures were zeroed out or not, so these worked.
> 
> This patch zeroes out the seccomp_notif data structure prior to calling
> the ioctl.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Reviewed-by: Tycho Andersen <tycho@tycho.ws>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>

Thanks!
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
