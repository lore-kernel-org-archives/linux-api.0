From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC] ps2emu - PS/2 emulation module
Date: Tue, 21 Jul 2015 13:48:02 -0700
Message-ID: <20150721204802.GE39076@dtor-ws>
References: <1437505634-8633-1-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437505634-8633-1-git-send-email-cpaul@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stephen Chandler Paul <cpaul@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 03:07:13PM -0400, Stephen Chandler Paul wrote:
> 
> Right now we make use of this module with the ps2emu userland tools[2] that I've
> wrote recently. Recording of PS/2 devices is done by enabling the debugging
> output from i8042, triggering a rescan of the PS/2 ports, and doing some clever
> trimming of data to remove anything that goes across the i8042 chip that isn't
> relevant to the PS/2 protocol. The replay application is pretty simple, and just

There is also serio_raw module that might be easier to use for recording
raw AUX data.

Thanks.

-- 
Dmitry
