From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 1/3] samples, selftests/seccomp: Zero out seccomp_notif
Date: Mon, 30 Dec 2019 10:29:44 -0800
Message-ID: <201912301029.46A91074BC@keescook>
References: <20191229062451.9467-1-sargun@sargun.me>
 <20191229161126.xcrnzdqu5frrov6q@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191229161126.xcrnzdqu5frrov6q@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 29, 2019 at 05:11:28PM +0100, Christian Brauner wrote:
> On Sat, Dec 28, 2019 at 10:24:49PM -0800, Sargun Dhillon wrote:
> > The seccomp_notif structure should be zeroed out prior to calling the
> > SECCOMP_IOCTL_NOTIF_RECV ioctl. Previously, the kernel did not check
> > whether these structures were zeroed out or not, so these worked.
> > 
> > This patch zeroes out the seccomp_notif data structure prior to calling
> > the ioctl.
> > 
> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > Reviewed-by: Tycho Andersen <tycho@tycho.ws>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Christian Brauner <christian.brauner@ubuntu.com>
> 
> Thanks!
> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

Thanks for this series and the discussion! :) I've applied this to my
tree for Linus.

-- 
Kees Cook
