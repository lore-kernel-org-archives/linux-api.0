From: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 01/15] [media] Move mediabus format definition to a more
 standard place
Date: Wed, 5 Nov 2014 17:00:25 +0200
Message-ID: <20141105150025.GS3136@valkosipuli.retiisi.org.uk>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415094910-15899-2-git-send-email-boris.brezillon@free-electrons.com>
 <5458A878.3010809@cisco.com> <20141104114503.309cb54f@bbrezillon>
 <5458B407.6050701@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <5458B407.6050701@cisco.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Hans Verkuil <hansverk@cisco.com>
Cc: devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On Tue, Nov 04, 2014 at 12:09:59PM +0100, Hans Verkuil wrote:
> Well, I gave two alternatives :-)
> 
> Both are fine as far as I am concerned, but it would be nice to hear
> what others think.

In fact I think both are good options. :-)

I'd perhaps lean towards the latter, for it has the benefit of pushing to
use the new definitions and the old ones can be deprecated (and eventually
removed in year 2030 or so ;)).

Either way, preprocessor macros should be used instead of an enum since that
way it's possible to figure out at that phase whether something is defined
or not. There is for enums, too, but it results in a compilation error...

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
