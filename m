From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 1/9] HSI: cmt_speech: Add cmt-speech driver
Date: Mon, 02 Mar 2015 11:29:07 +0100
Message-ID: <1425292147.2014.6.camel@neukum.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
	 <1425271139-24715-2-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-2-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kai Vehmanen <kai.vehmanen@nokia.com>, Carlos Chinea <carlos.chinea@nokia.com>, Joni Lapilainen <joni.lapilainen@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2015-03-02 at 05:38 +0100, Sebastian Reichel wrote:
> +static int cs_alloc_cmds(struct cs_hsi_iface *hi)
> +{
> +       struct hsi_msg *msg;
> +       u32 *buf;
> +       unsigned int i;
> +
> +       INIT_LIST_HEAD(&hi->cmdqueue);
> +
> +       for (i = 0; i < CS_MAX_CMDS; i++) {
> +               msg = hsi_alloc_msg(1, GFP_ATOMIC);

Why does this need to be ATOMIC?
> +               if (!msg)
> +                       goto out;
> +               buf = kmalloc(sizeof(*buf), GFP_ATOMIC);
> +               if (!buf) {
> +                       hsi_free_msg(msg);
> +                       goto out;
> +               }
> +               sg_init_one(msg->sgt.sgl, buf, sizeof(*buf));
> +               msg->channel = CONTROL_HSI_CH;
> +               msg->context = hi;
> +               list_add_tail(&msg->link, &hi->cmdqueue);
> +       }
> +
> +       return 0;
> +
> +out:
> +       cs_free_cmds(hi);
> +       return -ENOMEM;
> +}
> +
