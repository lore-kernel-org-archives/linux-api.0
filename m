From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v06 19/36] uapi linux/omapfb.h: use __kernel_size_t
 instead of size_t
Date: Mon, 7 Aug 2017 17:00:36 +0200
Message-ID: <CAK8P3a3XygT2gYxS_ywptfErDu2Sjw4FYV99rh6RqjT=2DfZuA@mail.gmail.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi> <20170806164428.2273-20-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-20-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 6, 2017 at 6:44 PM, Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
> Fixes userspace compilation error:
>
> error: unknown type name =E2=80=98size_t=E2=80=99
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Cc: linux-omap@vger.kernel.org
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>

Acked-by: Arnd Bergmann <arnd@arndb.de>
