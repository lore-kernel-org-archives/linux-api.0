From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v7 06/15] power: bq24257: Add basic support for
 bq24250/bq24251
Date: Mon, 28 Sep 2015 22:14:56 +0900
Message-ID: <56093D50.5010604@samsung.com>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-7-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443196460-26156-7-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

W dniu 26.09.2015 o 00:54, Andreas Dannenberg pisze:
> This patch adds basic support for bq24250 and bq24251 which are very
> similar to the bq24257 the driver was originally written for. Basic
> support means the ability to select a device through Kconfig, DT and
> ACPI, an instance variable allowing to check which chip is active, and
> the reporting back of the selected device through the model_name power
> supply sysfs property.
> 
> This patch by itself is not sufficient to actually use those two added
> devices in a real-world setting due to some feature differences which
> are addressed by other patches in this series.
> 
> Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>

For the second time (after 1st patch changing DT documentation) I am
confused - my reviewed-by was not added.

I assume it got lost due to misunderstanding or something else but
anyway I won't insist. If you want it, just let me know.

Best regards,
Krzysztof
