From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH REBASE 4.5 22/31] media: dvb-core create tuner to demod pad link in disabled state
Date: Thu, 21 Jan 2016 11:09:49 -0700
Message-ID: <03996e963902df1a9c488a99e6c477638e2fc182.1453336831.git.shuahkh@osg.samsung.com>
References: <cover.1453336830.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1453336830.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1453336830.git.shuahkh@osg.samsung.com>
References: <cover.1453336830.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Create tuner to demod pad link in disabled state to help avoid
disable step when tuner resource is requested by video or audio.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-core/dvbdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 560450a..189f85e 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -659,12 +659,12 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	}
 
 	if (ntuner && ndemod) {
+		/* create tuner to demod link deactivated */
 		ret = media_create_pad_links(mdev,
 					     MEDIA_ENT_F_TUNER,
 					     tuner, TUNER_PAD_IF_OUTPUT,
 					     MEDIA_ENT_F_DTV_DEMOD,
-					     demod, 0, MEDIA_LNK_FL_ENABLED,
-					     false);
+					     demod, 0, 0, false);
 		if (ret)
 			return ret;
 	}
-- 
2.5.0
