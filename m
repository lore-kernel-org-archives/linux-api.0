From: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v4 10/10] [media] v4l: Forbid usage of
 V4L2_MBUS_FMT definitions inside the kernel
Date: Sat, 08 Nov 2014 00:47:25 +0200
Message-ID: <545D4BFD.6000206@iki.fi>
References: <545CDB8D.4080406@xs4all.nl> <1415377630-16564-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1415377630-16564-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-doc-owner@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
List-Id: linux-api@vger.kernel.org

Hi Boris,

Boris Brezillon wrote:
> @@ -102,6 +113,7 @@ enum v4l2_mbus_pixelcode {
>  
>  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
>  };
> +#endif /* __KERNEL__ */
>  
>  /**
>   * struct v4l2_mbus_framefmt - frame format on the media bus

Was it intended to be this way, or did I miss something? I'd put this to
beginning of the file, as Hans suggested.

With this matter sorted out, for the set:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
