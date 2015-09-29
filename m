From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v8 11/14] power: bq24257: Allow input current limit sysfs
 access
Date: Tue, 29 Sep 2015 15:14:17 +0900
Message-ID: <560A2C39.6060405@samsung.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
 <1443479642-23712-12-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443479642-23712-12-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

W dniu 29.09.2015 o 07:33, Andreas Dannenberg pisze:
> This patch allows reading and writing of the input current limit through
> the power supply's input_current_limit sysfs property. This allows
> userspace to see what charger was detected (if the D+/D- USB signal-
> based charger type detection is enabled) and to re-configure the maximum
> current drawn from the external supply at runtime based on system-level
> knowledge or user input. Note that upon charger disconnection and
> re-connection the limit configured through firmware becomes active again
> (or the D+/D- USB signal-based charger detection will be run again).
> 
> Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> ---
>  drivers/power/bq24257_charger.c | 85 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 79 insertions(+), 6 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Best regards,
Krzysztof
