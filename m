From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 01/15] [media] Move mediabus format definition to a more
 standard place
Date: Wed, 5 Nov 2014 16:32:20 +0100
Message-ID: <20141105163220.6cd9ea21@bbrezillon>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415094910-15899-2-git-send-email-boris.brezillon@free-electrons.com>
 <5458A878.3010809@cisco.com> <20141104114503.309cb54f@bbrezillon>
 <5458B407.6050701@cisco.com>
 <20141105150025.GS3136@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20141105150025.GS3136@valkosipuli.retiisi.org.uk>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: devel@driverdev.osuosl.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 5 Nov 2014 17:00:25 +0200
Sakari Ailus <sakari.ailus@iki.fi> wrote:

> Hi,
> 
> On Tue, Nov 04, 2014 at 12:09:59PM +0100, Hans Verkuil wrote:
> > Well, I gave two alternatives :-)
> > 
> > Both are fine as far as I am concerned, but it would be nice to hear
> > what others think.
> 
> In fact I think both are good options. :-)
> 
> I'd perhaps lean towards the latter, for it has the benefit of pushing to
> use the new definitions and the old ones can be deprecated (and eventually
> removed in year 2030 or so ;)).
> 
> Either way, preprocessor macros should be used instead of an enum since that
> way it's possible to figure out at that phase whether something is defined
> or not. There is for enums, too, but it results in a compilation error...
> 

I don't get that last part :-).

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
