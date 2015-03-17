From: Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] drm_modes: videomode: add pos/neg pixel clock
 polarity flag
Date: Tue, 17 Mar 2015 11:43:39 +0100
Message-ID: <1426589019.3709.11.camel@pengutronix.de>
References: <1426526944-16762-1-git-send-email-sebastien.szymanski@armadeus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426526944-16762-1-git-send-email-sebastien.szymanski-d2DlULPkwbNWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?S=E9bastien?= Szymanski <sebastien.szymanski-d2DlULPkwbNWk0Htik3J/w@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Longerbeam <steve_longerbeam-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi S=C3=A9bastien,

Am Montag, den 16.03.2015, 18:29 +0100 schrieb S=C3=A9bastien Szymanski=
:
> From: Steve Longerbeam <steve_longerbeam-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
>=20
> [S=C3=A9bastien - rebase, update drm_display_mode_to_videomode functi=
on]
>=20
> Signed-off-by: Steve Longerbeam <steve_longerbeam-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: S=C3=A9bastien Szymanski <sebastien.szymanski@armadeus=
=2Ecom>

Thanks for bringing this up again. This is a very crucial bit of
information that somehow needs to be communicated from the panel driver
to the crtc/encoder drivers. I vaguely remember that an earlier attempt
to add this flag to the userspace visible DRM_MODE_FLAGs was met with
resistance before, but I can't find it right now.

regards
Philipp
