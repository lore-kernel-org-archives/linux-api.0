From: Pavel Machek <pavel@ucw.cz>
Subject: Right interface for cellphone modem audio (was Re: [PATCHv2 0/2]
 N900 Modem Speech Support)
Date: Fri, 6 Mar 2015 10:43:54 +0100
Message-ID: <20150306094354.GA32369@amd>
References: <1425343454-6551-1-git-send-email-sre@kernel.org>
 <20150305113013.GA3867@amd>
 <alpine.DEB.2.00.1503051844420.2610@ecabase.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1503051844420.2610@ecabase.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Kai Vehmanen <kvehmanen@nosignal.fi>, perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Cc: Sebastian Reichel <sre@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi!

> >>Userland access goes via /dev/cmt_speech. The API is implemented in
> >>libcmtspeechdata, which is used by ofono and the freesmartphone.org project.
> >Yes, the ABI is "tested" for some years, but it is not documented, and
> >it is very wrong ABI.
> >
> >I'm not sure what they do with the "read()". I was assuming it is
> >meant for passing voice data, but it can return at most 4 bytes,
> >AFAICT.
> >
> >We already have perfectly good ABI for passing voice data around. It
> >is called "ALSA". libcmtspeech will then become unneccessary, and the
> >daemon routing voice data will be as simple as "read sample from
> 
> I'm no longer involved with cmt_speech (with this driver nor modems in
> general), but let me clarify some bits about the design.

Thanks a lot for your insights; high level design decisions are quite
hard to understand from C code.

> First, the team that designed the driver and the stack above had a lot of
> folks working also with ALSA (and the ALSA drivers have been merged to
> mainline long ago) and we considered ALSA on multiple occasions as the
> interface for this as well.
> 
> Our take was that ALSA is not the right interface for cmt_speech. The
> cmt_speech interface in the modem is _not_ a PCM interface as modelled by
> ALSA. Specifically:
> 
> - the interface is lossy in both directions
> - data is sent in packets, not a stream of samples (could be other things
>   than PCM samples), with timing and meta-data
> - timing of uplink is of utmost importance

I see that you may not have data available in "downlink" scenario, but
how is it lossy in "uplink" scenario? Phone should always try to fill
the uplink, no? (Or do you detect silence and not transmit in this
case?) (Actually, I guess applications should be ready for "data not
ready" case even on "normal" hardware due to differing clocks.)

Packets vs. stream of samples... does userland need to know about the
packets? Could we simply hide it from the userland? As userland daemon
is (supposed to be) realtime, do we really need extra set of
timestamps? What other metadata are there?

Uplink timing... As the daemon is realtime, can it just send the data
at the right time? Also normally uplink would be filled, no?

> Some definite similarities:
>  - the mmap interface to manage the PCM buffers (that is on purpose
>    similar to that of ALSA)
> 
> The interface was designed so that the audio mixer (e.g. Pulseaudio) is run
> with a soft real-time SCHED_FIFO/RR user-space thread that has full control
> over _when_ voice _packets_ are sent, and can receive packets with meta-data
> (see libcmtspeechdata interface, cmtspeech.h), and can detect and handle
> gaps in the received packets.

Well, packets are of fixed size, right? So the userland can simply
supply the right size in the common case. As for sending at the right
time... well... if the userspace is already real-time, that should be
easy. 

Now, there's a difference in the downlink. Maybe ALSA people have an
idea what to do in this case? Perhaps we can just provide artificial
"zero" data?

> This is very different from modems that offer an actual PCM voice link for
> example over I2S to the application processor (there are lots of these on
> the market). When you walk out of coverage during a call with these modems,
> you'll still get samples over I2S, but not so with cmt_speech, so ALSA is
> not the right interface.

Yes, understood.

> Now, I'm not saying the interface is perfect, but just to give a bit of
> background, why a custom char-device interface was chosen.

Thanks and best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
