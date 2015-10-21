From: Emil Velikov <emil.l.velikov@gmail.com>
Subject: Re: [PATCH v4 12/79] include/uapi/drm/sis_drm.h: move
 sis_file_private to drivers/gpu/drm/sis/sis_drv.h
Date: Wed, 21 Oct 2015 15:39:07 +0100
Message-ID: <CACvgo51C=qc7WAPWr9oNczO9v7fCj04oH-k80vGXNNYLcAt+nQ@mail.gmail.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
	<1444888618-4506-13-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-13-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 15 October 2015 at 06:55, Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
> Fixes userspace compile error:
>
> drm/sis_drm.h:68:19: error: field =E2=80=98obj_list=E2=80=99 has inco=
mplete type
>   struct list_head obj_list;
>
> Suggested by Emil Velikov <emil.l.velikov@gmail.com> at
> https://lkml.org/lkml/2015/6/3/792
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> ---
Analogous to the via patch. Daniel can you please pick this one as well=
 ?

Hunk was added with commit fdc0b8a63c1124bb025a2846d41531a123845740

Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>

Thanks
Emil
