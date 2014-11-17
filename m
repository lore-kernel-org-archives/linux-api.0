From: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2] [media] Add RGB444_1X12 and RGB565_1X16 media bus
 formats
Date: Mon, 17 Nov 2014 17:24:42 +0200
Message-ID: <20141117152442.GR8907@valkosipuli.retiisi.org.uk>
References: <1416126278-17708-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416126278-17708-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Boris,

On Sun, Nov 16, 2014 at 09:24:38AM +0100, Boris Brezillon wrote:
> Add RGB444_1X12 and RGB565_1X16 format definitions and update the
> documentation.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> Changes since v1:
> - keep BPP and bits per sample ordering
> 
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 40 ++++++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |  4 ++-
>  2 files changed, 43 insertions(+), 1 deletion(-)

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
