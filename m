From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 3/4] drm, ipu-v3: use https://linuxtv.org for LinuxTV URL
Date: Fri, 04 Dec 2015 17:35:20 +0100
Message-ID: <1449246920.3451.18.camel@pengutronix.de>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
	 <4a3d0cb06b3e4248ba4a659d7f2a7a8fa1a877fc.1449232861.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <4a3d0cb06b3e4248ba4a659d7f2a7a8fa1a877fc.1449232861.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Freitag, den 04.12.2015, 10:46 -0200 schrieb Mauro Carvalho Chehab:
> While https was always supported on linuxtv.org, only in
> Dec 3 2015 the website is using valid certificates.
> 
> As we're planning to drop pure http support on some
> future, change the references at DRM include and at
> the ipu-v3 driver to point to the https://linuxtv.org
> URL instead.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
