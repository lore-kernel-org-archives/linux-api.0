From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] Allow restricting permissions in /proc/sys
Date: Wed, 13 Nov 2019 17:40:33 +0100
Message-ID: <CAG48ez1qtVXSBCmLCWdRwfemw6u5d-Zargm-MNJV_N0WAAoVwg@mail.gmail.com>
References: <74a91362-247c-c749-5200-7bdce704ed9e@gmail.com>
 <20191112232239.yevpeemgxz4wy32b@wittgenstein> <CAG48ez0j_7NyCyvGn8U8NS2p=CQQb=me-5KTa7k5E6xpHJphaA@mail.gmail.com>
 <13bc7935-8341-bb49-74ea-2eb58f72fd1f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13bc7935-8341-bb49-74ea-2eb58f72fd1f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Topi Miettinen <toiwoton@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 13, 2019 at 5:19 PM Topi Miettinen <toiwoton@gmail.com> wrote:
> On 13.11.2019 18.00, Jann Horn wrote:
> > On Wed, Nov 13, 2019 at 12:22 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> >> On Sun, Nov 03, 2019 at 04:55:48PM +0200, Topi Miettinen wrote:
> >>> Several items in /proc/sys need not be accessible to unprivileged
> >>> tasks. Let the system administrator change the permissions, but only
> >>> to more restrictive modes than what the sysctl tables allow.
[...]
> > In kernel/ucount.c, the ->permissions handler set_permissions() grants
> > access based on whether the caller has CAP_SYS_RESOURCE. And in
> > net/sysctl_net.c, the handler net_ctl_permissions() grants access
> > based on whether the caller has CAP_NET_ADMIN. This added check is
> > going to break those, right?
> >
>
> Right. The comment above seems then a bit misleading:
>         /*
>          * sysctl entries that are not writeable,
>          * are _NOT_ writeable, capabilities or not.
>          */

I don't see the problem. Those handlers never make a file writable
that doesn't have one of the three write bits (0222) set.
