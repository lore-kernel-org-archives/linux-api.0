From: Andy Lutomirski <luto@kernel.org>
Subject: linux-api scope (Re: [PATCH v2 11/22] media: dvb-frontend invoke
 enable/disable_source handlers)
Date: Wed, 3 Feb 2016 20:51:16 -0800
Message-ID: <CALCETrUNxPhcKiT+aswO5rr+ZpPPCkT30+Exd0iWwQnMN921Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-media-owner@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, ALSA development <alsa-devel@alsa-project.org>
List-Id: linux-api@vger.kernel.org

[cc list heavily trimmed]

On Wed, Feb 3, 2016 at 8:03 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> Change dvb frontend to check if tuner is free when
> device opened in RW mode. Call to enable_source
> handler either returns with an active pipeline to
> tuner or error if tuner is busy. Tuner is released
> when frontend is released calling the disable_source
> handler.

As an actual subscriber to linux-api, I prefer for the linux-api list
to be lowish-volume and mostly limited to API-related things.  Is this
API related?  Do people think that these series should be sent to
linux-api?

Thanks,
Andy
