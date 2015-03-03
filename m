From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/9] N900 Modem Speech Support
Date: Tue, 3 Mar 2015 14:33:24 +0100
Message-ID: <20150303133324.GA12360@amd>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi!

> This patchset contains the missing speech data support for the
> Nokia N900 modem.
> 
> Userland access goes via /dev/cmt_speech. The API is implemented in
> libcmtspeechdata, which is used by ofono and the freesmartphone.org project.
> Apart from that the device is also used by the phone binaries distributed
> with Maemo. So while this is a new userland ABI for the mainline kernel it
> has been tested in the wild for some years.
> 
> Simple Testing of the API can be done by checking out libcmtspeechdata [0],
> building the test tool and executing it. The tool will loop back audio data
> received from the caller.

Tested-by: Pavel Machek <pavel@ucw.cz>

Audio is borken on 4.0-rc1 on n900 mainline, so I used pulseaudio remote for a
test.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
