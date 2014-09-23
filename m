From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 1/5] video: move mediabus format definition to a more
 standard place
Date: Tue, 23 Sep 2014 18:09:23 +0200
Message-ID: <20140923180923.287758a7@bbrezillon>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
 <1406031827-12432-2-git-send-email-boris.brezillon@free-electrons.com>
 <Pine.LNX.4.64.1409231426220.17074@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <Pine.LNX.4.64.1409231426220.17074@axis700.grange>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Guennadi,

On Tue, 23 Sep 2014 14:33:20 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi Boris,
> 
> On Tue, 22 Jul 2014, Boris BREZILLON wrote:
> 
> > Rename mediabus formats and move the enum into a separate header file so
> > that it can be used by DRM/KMS subsystem without any reference to the V4L2
> > subsystem.
> > 
> > Old V4L2_MBUS_FMT_ definitions are now macros that points to VIDEO_BUS_FMT_
> > definitions.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> In principle I find this a good idea, certainly it's good to reuse code. 
> Just wondering, wouldn't it be better instead of adding those defines to 
> define a macro like
> 
> #define VIDEO_BUS_TO_MBUS(x)	V4L2_MBUS_ ## x = VIDEO_BUS_ ## x
> 
> and then do
> 
> enum v4l2_mbus_pixelcode {
> 	VIDEO_BUS_TO_MBUS(FIXED),
> 	VIDEO_BUS_TO_MBUS(RGB444_2X8_PADHI_BE),
> 	...
> };
> 
> ? I'm not very strong on this, I just think an enum is nicer than a bunch 
> of defines and this way copy-paste errors are less likely, but if you or 
> others strongly disagree - I won't insist :)

I'd say it might be a good solution if we enforce new users (including
user space users) to use video_bus_format enum values instead of
v4l2_mbus_pixelcode ones. But if we keep adding new values to this enum
I'd say this approach is less readable than having the full names
(V4L2_MBUS_XXX) expressed, because users will still have to use those
full names.

Anyway, I can still replace this macro list by an enum:

enum v4l2_mbus_pixelcode {
	V4L2_MBUS_FIXED = VIDEO_BUS_FIXED,
	V4L2_MBUS_RGB444_2X8_PADHI_BE = VIDEO_BUS_RGB444_2X8_PADHI_BE,
	...
};

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
