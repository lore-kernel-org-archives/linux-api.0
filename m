From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v8 08/14] power: bq24257: Add SW-based approach for Power
 Good determination
Date: Tue, 29 Sep 2015 15:10:31 +0900
Message-ID: <560A2B57.5030008@samsung.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
 <1443479642-23712-9-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443479642-23712-9-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

W dniu 29.09.2015 o 07:33, Andreas Dannenberg pisze:
> A software-based approach for determining the charger's input voltage
> "Power Good" state is introduced for devices like the bq24250 which
> don't have a dedicated hardware pin for that purpose. This SW-based
> approach is also used for other devices (with dedicated PG pin) as a
> fall back solution if that pin is not configured to be used through
> "pg-gpios".
> 
> Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> ---
>  drivers/power/bq24257_charger.c | 56 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 45 insertions(+), 11 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Best regards,
Krzysztof
