From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v6 00/10]  [media] Make mediabus format subsystem neutral
Date: Mon, 10 Nov 2014 18:25:50 +0100
Message-ID: <20141110182550.18d95bce@bbrezillon>
References: <1415640114-14930-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1415640114-14930-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: devel@driverdev.osuosl.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 10 Nov 2014 18:21:44 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This patch series prepares the use of media bus formats outside of
> the V4L2 subsytem (my final goal is to use it in the Atmel HLCDC DRM
> driver where I have to configure my DPI/RGB bus according to the
> connected display).
> 
> The series first defines MEDIA_BUS_FMT_ macros, and then replace all
> references to the v4l2_mbus_pixelcode enum and its values within the
> kernel.
> 
> Best Regards,
> 
> Boris
> 
> Changes since v5:
> - fix V4L2_MBUS_FROM_MEDIA_BUS_FMT macro definition

Sorry for the noise, I sent the wrong patch set :-(.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
