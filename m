From: Kai Vehmanen <kvehmanen-nQfqiRJ1PMYxHbG02/KK1g@public.gmane.org>
Subject: Re: Right interface for cellphone modem audio (was Re: [PATCHv2 0/2]
 N900 Modem Speech Support)
Date: Fri, 6 Mar 2015 22:49:50 +0200 (EET)
Message-ID: <alpine.DEB.2.00.1503062139320.2610@ecabase.localdomain>
References: <1425343454-6551-1-git-send-email-sre@kernel.org> <20150305113013.GA3867@amd> <alpine.DEB.2.00.1503051844420.2610@ecabase.localdomain> <20150306094354.GA32369@amd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150306094354.GA32369@amd>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: perex-/Fr2/VpizcU@public.gmane.org, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>, Kai Vehmanen <kvcontact-nQfqiRJ1PMYxHbG02/KK1g@public.gmane.org>, Pali Rohar <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>, Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On Fri, 6 Mar 2015, Pavel Machek wrote:

>> Our take was that ALSA is not the right interface for cmt_speech. The
>> cmt_speech interface in the modem is _not_ a PCM interface as modelled by
>> ALSA. Specifically:
>>
>> - the interface is lossy in both directions
>> - data is sent in packets, not a stream of samples (could be other things
>>   than PCM samples), with timing and meta-data
>> - timing of uplink is of utmost importance
>
> I see that you may not have data available in "downlink" scenario, but
> how is it lossy in "uplink" scenario? Phone should always try to fill
> the uplink, no? (Or do you detect silence and not transmit in this

Lossy was perhaps not the best choice of words, non-continuous would be 
a better choice in the uplink case. To adjust timing, some samples from 
the continuous locally recorded PCM stream need to be skipped and/or 
duplicated. This would normally be done between speech bursts to avoid 
artifacts.

> Packets vs. stream of samples... does userland need to know about the
> packets? Could we simply hide it from the userland? As userland daemon
> is (supposed to be) realtime, do we really need extra set of
> timestamps? What other metadata are there?

Yes, we need flags that tell about the frame. Please see docs for 
'frame_flags' and 'spc_flags' in libcmtspeechdata cmtspeech.h:
https://www.gitorious.org/libcmtspeechdata/libcmtspeechdata/source/9206835ea3c96815840a80ccba9eaeb16ff7e294:cmtspeech.h

Kernel space does not have enough info to handle these flags as the audio 
mixer is not implemented in kernel, so they have to be passed to/from 
user-space.

And some further info in libcmtspeechdata/docs/ 
https://www.gitorious.org/libcmtspeechdata/libcmtspeechdata/source/9206835ea3c96815840a80ccba9eaeb16ff7e294:doc/libcmtspeechdata_api_docs_main.txt

> Uplink timing... As the daemon is realtime, can it just send the data
> at the right time? Also normally uplink would be filled, no?

But how would you implement that via the ALSA API? With cmt_speech, a 
speech packet is prepared in a mmap'ed buffer, flags are set to describe 
the buffer, and at the correct time, write() is called to trigger 
transmission in HW (see cmtspeech_ul_buffer_release() in 
libcmtspeechdata() -> compare this to snd_pcm_mmap_commit() in ALSA). In 
ALSA, the mmap commit and PCM write variants just add data to the 
ringbuffer and update the appl pointer. Only initial start (and stop) on 
stream have the "do something now" semantics in ALSA.

The ALSA compressed offload API did not exist back when we were working on 
cmt_speech, but that's still not a good fit, although adds some of the 
concepts (notably frames).

> Well, packets are of fixed size, right? So the userland can simply
> supply the right size in the common case. As for sending at the right
> time... well... if the userspace is already real-time, that should be 
> easy

See above, ALSA just doesn't work like that, there's no syscall for "send 
these samples now", the model is different.

Br, Kai
