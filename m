From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] Add supplementary UIDs, and getusers/setusers system
 calls
Date: Sat, 15 Nov 2014 23:41:57 -0800
Message-ID: <20141116074157.GA2714@thin>
References: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Nov 15, 2014 at 11:08:31PM -0800, Josh Triplett wrote:
>  asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist);
> +asmlinkage long sys_setusers(int uidsetsize, uid_t __user *grouplist);

Obvious typo here: s/grouplist/userlist/.  Will fix in a v2, but I'll
wait for other feedback on v1 first.

- Josh Triplett
