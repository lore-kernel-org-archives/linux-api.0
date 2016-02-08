From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: RE: [PATCH V2 3/6] stm class: provision for statically assigned masterIDs
Date: Mon, 08 Feb 2016 12:52:57 +0200
Message-ID: <87si13cw3a.fsf@ashishki-desk.ger.corp.intel.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org> <1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org> <87mvrf5ngl.fsf@ashishki-desk.ger.corp.intel.com> <DB3PR08MB0041B8843C61FCEB049B2BB58CD20@DB3PR08MB0041.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB3PR08MB0041B8843C61FCEB049B2BB58CD20-aD6Q2MAZY6WInpB6pqslIikoKrxaZxrJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Leach <Mike.Leach-5wv7dgnIgG8@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mathieu.poirier@linaro.org" <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "robh@kernel.org" <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "broonie@kernel.org" <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "pratikp@codeaurora.org" <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "nicolas.guion@st.com" <nicolas.guion-qxv4g6HH51o@public.gmane.org>, "corbet@lwn.net" <corbet-T1hC0tSOHrs@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "tor@ti.com" <tor-l0cyMroinI0@public.gmane.org>, Al Grant <Al.Grant-5wv7dgnIgG8@public.gmane.org>, "zhang.lyra@gmail.com" <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-api@vger.kernel.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc@vger.kernel.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Mike Leach <Mike.Leach-5wv7dgnIgG8@public.gmane.org> writes:

> Hi,
>
> I think a quick clarification of the ARM hardware STM architecture may be of value here.
>
> The ARM hardware STM, when implemented as recommend in a hardware design, the master IDs are not under driver control, but have a hardwire association with source devices in the system. The master IDs are hardwired to individual cores and core security states, and there could be other IDs associated with hardware trace sources requiring output via the hardware STM. (an example of this is the ARM Juno development board).
>
> Therefore in multi-core systems many masters may be associated with a single software STM stream. A user-space application running on Core 1, may have a master ID of 0x11 in the STPv2 trace stream, but if this application is context switched and later continues running on Core 2, then master ID could change to 0x21.  Masters identify a hardware source in this scheme, the precise values used will be implementation dependent.
>
> So the number of masters "available to the software" depends on your interpretation of the phrase.
> If you mean "master IDs on which software trace will appear" then that will be many - it depends on which core is running the application. However as described above, this is not predictable by any decoder, and the master set used may not be contiguous.
> If you mean "master IDs selectable/allocated by the driver" then that will be 0 - the driver has no control, and possibly no knowledge of which master is associated with the current execution context. (this is of course system dependent - it may well be possible to have some configuration database associating cores with hardware IDs, but this will be implementation and board support dependant).
>
> Therefore, there is a requirement to tell both the user-space STM client and decoder that not only is master ID management not needed - it is in fact not possible and the key to identify the software source for a given STM packet is the channel alone. In addition we have a nominal single Master ID "available to the software", to satisfy the requirements of the generic ST module API.
>
> So on Juno for example, while we do have 128 masters, each with 65536 channels, the master allocation is not visible to system software - each core sees a single master with 65536 channels. Therefore differentiation between software sources in the STM trace is by channel number allocations only.

Ok, thanks a lot for the detailed explanation. I was confused by the
"static" bit in the patch description. It looks like something along the
lines of this patch might indeed be in order.

Regards,
--
Alex
