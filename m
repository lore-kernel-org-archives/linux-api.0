From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v2 01/10] [media] Move mediabus format definition to a
 more standard place
Date: Fri, 7 Nov 2014 09:50:25 -0200
Message-ID: <20141107095025.4dbf6774@concha.lan>
References: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415267829-4177-2-git-send-email-boris.brezillon@free-electrons.com>
	<20141107114358.GB3136@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20141107114358.GB3136@valkosipuli.retiisi.org.uk>
Sender: linux-doc-owner@vger.kernel.org
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
List-Id: linux-api@vger.kernel.org

Em Fri, 07 Nov 2014 13:43:59 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

>>  +enum media_bus_format {  
> 
> There's no really a need to keep the definitions inside the enum. It looks a
> little bit confusing to me. That made me realise something I missed
> yesterday.
> 
> There's a difference: the enum in C++ is a different thing than in C, and
> the enum type isn't able to contain any other values than those defined in
> the enumeration.
> 
> So what I propose is the following. Keep enum v4l2_mbus_pixelcode around,
> including the enum values. Define new values for MEDIA_BUS_* equivalents
> using preprocessor macros, as you've done below. Drop the definition of enum
> media_bus_format, and use u32 (or uint32_t) type for the variables.
> 
> This way the enum stays intact for existing C++ applications, and new
> applications will have to use a 32-bit type.

Yeah, enums at the public API is bad, as any change there can potentially
cause C++ apps to break.

-- 

Cheers,
Mauro
