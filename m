From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 0/4] Improved seccomp logging
Date: Wed, 15 Feb 2017 17:17:21 -0800
Message-ID: <CAGXu5jLRadtyYbJO+GAamK5tz9YVegF7yZtY03dxfcevicwK3Q@mail.gmail.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487044559-6351-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 13, 2017 at 7:55 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> This patch set is the fourth revision of the following two previously
> submitted patch sets:
>
> v1: http://lkml.kernel.org/r/1483375990-14948-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
> v1: http://lkml.kernel.org/r/1483377999-15019-2-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>
> v2: http://lkml.kernel.org/r/1486100262-32391-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>
> v3: Same patches as v4 but I copied and pasted an invalid address for the
>     linux-api list when submitting the set.
>
> The patch set aims to address some known deficiencies in seccomp's current
> logging capabilities:
>
>   1. Inability to log all filter actions.
>   2. Inability to selectively enable filtering; e.g. devs want noisy logging,
>      users want relative quiet.
>   3. Consistent behavior with audit enabled and disabled.
>   4. Inability to easily develop a filter due to the lack of a
>      permissive/complain mode.

I'm pretty happy with the series! If you can address the minor nits I
pointed out and send a v4, I'll get it queued for -next. It won't make
v4.11; we're almost at the merge window and I want to make sure this
gets as much testing time as possible. It should be good for v4.12,
though.

Thanks for the series; I know a lot of people have wanted the functionality. :)

-Kees

-- 
Kees Cook
Pixel Security
