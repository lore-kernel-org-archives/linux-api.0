From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH] uapi: remove i2o header in uapi
Date: Thu, 01 Oct 2015 17:40:15 +0200
Message-ID: <1443714015.3188.16.camel@opteya.com>
References: <1443712510-6714-1-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443712510-6714-1-git-send-email-gabriel@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Gabriel Laskar <gabriel@lse.epita.fr>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 01 octobre 2015 =C3=A0 17:15 +0200, Gabriel Laskar a =C3=A9cri=
t :
> Remove uapi header for i2o subsystem that has been removed by
> commit 4a72a7af462d ("staging: remove i2o subsystem")
>=20
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
> ---

Don't miss to update the Kbuild file.

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index e77707802dcc..470b2f6e2193 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -151,7 +151,6 @@ header-y +=3D hyperv.h
 header-y +=3D hysdn_if.h
 header-y +=3D i2c-dev.h
 header-y +=3D i2c.h
-header-y +=3D i2o-dev.h
 header-y +=3D i8k.h
 header-y +=3D icmp.h
 header-y +=3D icmpv6.h


Note, you may also use git format-patch -D to reduce the size of your
patch.

Regards.

--=20
Yann Droneaud
OPTEYA
