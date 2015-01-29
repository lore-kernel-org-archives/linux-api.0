From: Julijonas Kikutis <julijonas.kikutis@gmail.com>
Subject: Re: [PATCH v2] samsung-laptop: enable better lid handling
Date: Thu, 29 Jan 2015 13:12:52 +0000
Message-ID: <1422537172.1835.4.camel@gmail.com>
References: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
	 <1422365168-2428-1-git-send-email-julijonas.kikutis@gmail.com>
	 <20150129052021.GA115032@vmdeb7>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150129052021.GA115032@vmdeb7>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:SAMSUNG LAPTOP DR..." <platform-driver-x86@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> Patch is generally fine, thanks for addressing my comments. Prior to merging I
> always run checkpatch.pl just in case I missed anything obvious:
> 
> $ scripts/checkpatch.pl ~/samsung/01-lid-handling.patch 
> WARNING: Prefer kstrto<type> to single variable sscanf
> #219: FILE: drivers/platform/x86/samsung-laptop.c:900:
> +       if (!count || sscanf(buf, "%i", &value) != 1)
> +               return -EINVAL;
> 
> total: 0 errors, 1 warnings, 219 lines checked
> 
> Please always run checkpatch.pl. It isn't sufficient and doesn't catch
> everything, but it is a minimum bar kind of thing.

I did run checkpatch.pl but left sscanf to be consistent with
set_battery_life_extender and set_usb_charge functions. Nevertheless, I
have just sent the third version of the patch with sscanf changed to
kstrtoint.

Thank you.

Julijonas
