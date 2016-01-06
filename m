From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 05/31] media: Media Controller fix to not let stream_count go negative
Date: Wed,  6 Jan 2016 13:26:54 -0700
Message-ID: <7496533e9a84110d4c5862cbcc7afdf72215f0ac.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Add a range check to not let the stream_count become negative.
Wthout this check, calls to stop pipeline when there is no active
pipeline will result in stream_count < 0 condition and lock and
preventing link state (activate/deactivate) changes. This will
happen from error leg in start pipeline interface.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 6e02d19..78486a9 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -464,9 +464,12 @@ error:
 	media_entity_graph_walk_start(graph, entity_err);
 
 	while ((entity_err = media_entity_graph_walk_next(graph))) {
-		entity_err->stream_count--;
-		if (entity_err->stream_count == 0)
-			entity_err->pipe = NULL;
+		/* don't let the stream_count go negative */
+		if (entity->stream_count > 0) {
+			entity_err->stream_count--;
+			if (entity_err->stream_count == 0)
+				entity_err->pipe = NULL;
+		}
 
 		/*
 		 * We haven't increased stream_count further than this
@@ -498,9 +501,12 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 	media_entity_graph_walk_start(graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(graph))) {
-		entity->stream_count--;
-		if (entity->stream_count == 0)
-			entity->pipe = NULL;
+		/* don't let the stream_count go negative */
+		if (entity->stream_count > 0) {
+			entity->stream_count--;
+			if (entity->stream_count == 0)
+				entity->pipe = NULL;
+		}
 	}
 
 	if (!--pipe->streaming_count)
-- 
2.5.0
