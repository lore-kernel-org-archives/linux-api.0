From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v2 2/2] seccomp: Check that seccomp_notif is zeroed out
 by the user
Date: Fri, 27 Dec 2019 20:49:21 -0700
Message-ID: <20191228034921.GG15663@cisco>
References: <20191228014849.GA31783@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191228014849.GA31783@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, jannh@google.com, christian.brauner@ubuntu.com, keescook@chromium.org, cyphar@cyphar.com
List-Id: linux-api@vger.kernel.org

On Sat, Dec 28, 2019 at 01:48:51AM +0000, Sargun Dhillon wrote:
> This patch is a small change in enforcement of the uapi for
> SECCOMP_IOCTL_NOTIF_RECV ioctl. Specifically, the datastructure which
> is passed (seccomp_notif) must be zeroed out. Previously any of its
> members could be set to nonsense values, and we would ignore it.
> 
> This ensures all fields are set to their zero value.
> 
> This relies on the seccomp_notif datastructure to not have
> any unnamed padding, as it is valid to initialize the datastructure
> as:
> 
>   struct seccomp_notif notif = {};
> 
> This only initializes named members to their 0-value [1].
> 
> [1]: https://lore.kernel.org/lkml/20191227023131.klnobtlfgeqcmvbb@yavin.dot.cyphar.com/
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>

Acked-by: Tycho Andersen <tycho@tycho.ws>
