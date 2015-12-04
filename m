From: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/20] drm: use __u{32,64} instead of uint{32,64}_t in virtgpu_drm.h
Date: Fri, 4 Dec 2015 14:22:37 +0000
Message-ID: <CACvgo52bSiTJmze45WUSs+sW0RfcW7Uwaworb68YA54b3PvR9Q@mail.gmail.com>
References: <1448892658-14256-1-git-send-email-gabriel@lse.epita.fr>
	<1448892658-14256-2-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448892658-14256-2-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 30 November 2015 at 14:10, Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org> wrote:
> Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
> CC: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
>
> ---
>  include/uapi/drm/virtgpu_drm.h | 98 +++++++++++++++++++++---------------------
>  1 file changed, 49 insertions(+), 49 deletions(-)
>
For the series
Reviewed-by: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Dave would you have any comments wrt this and the remainder of Mikko's
series ? Alternatively what can we do to get those merged (would you
like a branch/pull request) ?

Thanks
Emil
