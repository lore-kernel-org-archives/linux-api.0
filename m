From: Kai Vehmanen <kvehmanen@nosignal.fi>
Subject: Re: [PATCHv2 0/2] N900 Modem Speech Support
Date: Thu, 5 Mar 2015 19:32:35 +0200 (EET)
Message-ID: <alpine.DEB.2.00.1503051844420.2610@ecabase.localdomain>
References: <1425343454-6551-1-git-send-email-sre@kernel.org> <20150305113013.GA3867@amd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150305113013.GA3867@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On Thu, 5 Mar 2015, Pavel Machek wrote:

>> Userland access goes via /dev/cmt_speech. The API is implemented in
>> libcmtspeechdata, which is used by ofono and the freesmartphone.org project.
> Yes, the ABI is "tested" for some years, but it is not documented, and
> it is very wrong ABI.
>
> I'm not sure what they do with the "read()". I was assuming it is
> meant for passing voice data, but it can return at most 4 bytes,
> AFAICT.
>
> We already have perfectly good ABI for passing voice data around. It
> is called "ALSA". libcmtspeech will then become unneccessary, and the
> daemon routing voice data will be as simple as "read sample from

I'm no longer involved with cmt_speech (with this driver nor modems in 
general), but let me clarify some bits about the design.

First, the team that designed the driver and the stack above had a lot of 
folks working also with ALSA (and the ALSA drivers have been merged to 
mainline long ago) and we considered ALSA on multiple occasions as the 
interface for this as well.

Our take was that ALSA is not the right interface for cmt_speech. The 
cmt_speech interface in the modem is _not_ a PCM interface as modelled by 
ALSA. Specifically:

- the interface is lossy in both directions
- data is sent in packets, not a stream of samples (could be other things
   than PCM samples), with timing and meta-data
- timing of uplink is of utmost importance

Some definite similarities:
  - the mmap interface to manage the PCM buffers (that is on purpose
    similar to that of ALSA)

The interface was designed so that the audio mixer (e.g. Pulseaudio) is 
run with a soft real-time SCHED_FIFO/RR user-space thread that has full 
control over _when_ voice _packets_ are sent, and can receive packets with 
meta-data (see libcmtspeechdata interface, cmtspeech.h), and can 
detect and handle gaps in the received packets.

This is very different from modems that offer an actual PCM voice link for 
example over I2S to the application processor (there are lots of these on 
the market). When you walk out of coverage during a call with these 
modems, you'll still get samples over I2S, but not so with cmt_speech, so 
ALSA is not the right interface.

Now, I'm not saying the interface is perfect, but just to give a bit of 
background, why a custom char-device interface was chosen.

PS Not saying it's enough for mainline inclusion, but libcmtspeechdata [1]
    was released and documented to enable the driver to be used by
    other software than the closed pulseaudio modules. You Pavel of course
    know this as you've been maintaining the library, but FYI for others.

[1] https://www.gitorious.org/libcmtspeechdata

Br, Kai
