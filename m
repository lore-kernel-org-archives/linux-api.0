From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 2/3] seccomp: Check that seccomp_notif is zeroed out
 by the user
Date: Mon, 30 Dec 2019 10:29:56 -0800
Message-ID: <201912301029.E9739655@keescook>
References: <20191229062451.9467-1-sargun@sargun.me>
 <20191229062451.9467-2-sargun@sargun.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191229062451.9467-2-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, Christian Brauner <christian.brauner@ubuntu.com>, Aleksa Sarai <cyphar@cyphar.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 28, 2019 at 10:24:50PM -0800, Sargun Dhillon wrote:
> This patch is a small change in enforcement of the uapi for
> SECCOMP_IOCTL_NOTIF_RECV ioctl. Specifically, the datastructure which
> is passed (seccomp_notif) must be zeroed out. Previously any of its
> members could be set to nonsense values, and we would ignore it.
> 
> This ensures all fields are set to their zero value.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Cc: Kees Cook <keescook@chromium.org>
> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
> Acked-by: Tycho Andersen <tycho@tycho.ws>

Applied!

-- 
Kees Cook
