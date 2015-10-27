From: Lyude <cpaul@redhat.com>
Subject: Re: [PATCH v6.2 1/1] Input: Add userio module
Date: Tue, 27 Oct 2015 14:10:42 -0400
Message-ID: <1445969442.3281.15.camel@redhat.com>
References: <1444053984.8404.1.camel@redhat.com>
	 <1445633266-14691-1-git-send-email-cpaul@redhat.com>
	 <20151024224012.GA13584@dtor-pixel> <1445867517.3535.6.camel@redhat.com>
	 <20151026232645.GA26171@dtor-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151026232645.GA26171@dtor-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Gotcha, tested it and took a look at the changes, looks good to me.

On Mon, 2015-10-26 at 16:26 -0700, Dmitry Torokhov wrote:
> Hi,
> 
> On Mon, Oct 26, 2015 at 09:51:57AM -0400, Lyude wrote:
> > Hi! So, I'm guessing you want me to merge this with the patch I've got
> > right now and post the new version? (Just making sure since I'm a bit
> > new to this :)
> > 
> 
> If you apply my patch on top of yours and it still works you do not need
> to resend anything. If I messed up and you need to fix something ideally
> just send me an incremental patch so that I can see where exactly I
> screwed up and I'll fold it all together.
> 
> Thanks.
> 
-- 
Cheers,
	Lyude
