From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 07/31] media: Media Controller non-locking __media_entity_pipeline_start/stop()
Date: Wed,  6 Jan 2016 13:26:56 -0700
Message-ID: <827307083c45909d1197a463a07dffc2f4fe3c83.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Add non-locking __media_entity_pipeline_start/stop() interfaces
to be called from code paths that hold the graph_mutex. For this
change, the media_entity_pipeline_start() routine is renamed to
__media_entity_pipeline_start() minus the graph_mutex lock and
unlock. media_entity_pipeline_start() now calls the non-locking
__media_entity_pipeline_start() holding the graph_lock. The stop
interface, media_entity_pipeline_stop() routine is renamed to
__media_entity_pipeline_stop() minus the graph_mutex lock and
unlock. media_entity_pipeline_stop() now calls the non-locking
__media_entity_pipeline_stop() holding the graph_lock.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 34 ++++++++++++++++++++++++----------
 include/media/media-entity.h | 12 ++++++++++++
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index b8769aa..270ade2 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -361,8 +361,8 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
  * Pipeline management
  */
 
-__must_check int media_entity_pipeline_start(struct media_entity *entity,
-					     struct media_pipeline *pipe)
+__must_check int __media_entity_pipeline_start(struct media_entity *entity,
+					       struct media_pipeline *pipe)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph *graph = &pipe->graph;
@@ -370,8 +370,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	struct media_link *link;
 	int ret;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	if (!pipe->streaming_count++) {
 		ret = media_entity_graph_walk_init(&pipe->graph, mdev);
 		if (ret)
@@ -452,8 +450,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		}
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
-
 	return 0;
 
 error:
@@ -483,19 +479,28 @@ error_graph_walk_start:
 	if (!--pipe->streaming_count)
 		media_entity_graph_walk_cleanup(graph);
 
-	mutex_unlock(&mdev->graph_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__media_entity_pipeline_start);
 
+__must_check int media_entity_pipeline_start(struct media_entity *entity,
+					     struct media_pipeline *pipe)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+	int ret;
+
+	mutex_lock(&mdev->graph_mutex);
+	ret = __media_entity_pipeline_start(entity, pipe);
+	mutex_unlock(&mdev->graph_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
 
-void media_entity_pipeline_stop(struct media_entity *entity)
+void __media_entity_pipeline_stop(struct media_entity *entity)
 {
-	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph *graph = &entity->pipe->graph;
 	struct media_pipeline *pipe = entity->pipe;
 
-	mutex_lock(&mdev->graph_mutex);
 
 	WARN_ON(!pipe->streaming_count);
 	media_entity_graph_walk_start(graph, entity);
@@ -512,6 +517,15 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 	if (!--pipe->streaming_count)
 		media_entity_graph_walk_cleanup(graph);
 
+}
+EXPORT_SYMBOL_GPL(__media_entity_pipeline_stop);
+
+void media_entity_pipeline_stop(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+
+	mutex_lock(&mdev->graph_mutex);
+	__media_entity_pipeline_stop(entity);
 	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 79dd81f..3f4f577 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -781,6 +781,12 @@ media_entity_graph_walk_next(struct media_entity_graph *graph);
  */
 __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe);
+/**
+ * non-locking __media_entity_pipeline_start() can be called from
+ * code paths that hold the graph_mutex
+ */
+__must_check int __media_entity_pipeline_start(struct media_entity *entity,
+					       struct media_pipeline *pipe);
 
 /**
  * media_entity_pipeline_stop - Mark a pipeline as not streaming
@@ -797,6 +803,12 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 void media_entity_pipeline_stop(struct media_entity *entity);
 
 /**
+ * non-locking __media_entity_pipeline_stop() can be called from
+ * code paths that hold the graph_mutex
+ */
+void __media_entity_pipeline_stop(struct media_entity *entity);
+
+/**
  * media_devnode_create() - creates and initializes a device node interface
  *
  * @mdev:	pointer to struct &media_device
-- 
2.5.0
