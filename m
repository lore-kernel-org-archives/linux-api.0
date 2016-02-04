From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2 11/22] media: dvb-frontend invoke enable/disable_source handlers
Date: Wed,  3 Feb 2016 21:03:43 -0700
Message-ID: <a404ddaef8fbfbc291d5afa013888fbc239cde8e.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs-mcfjX3dozePR7s880joybQ@public.gmane.org, johan-v8HUHnYb0Yo@public.gmane.org, klock.android-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nenggun.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, j.anaszewski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, geliangtang
List-Id: linux-api@vger.kernel.org

Change dvb frontend to check if tuner is free when
device opened in RW mode. Call to enable_source
handler either returns with an active pipeline to
tuner or error if tuner is busy. Tuner is released
when frontend is released calling the disable_source
handler.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 139 +++++-----------------------------
 drivers/media/dvb-core/dvb_frontend.h |   3 +
 2 files changed, 24 insertions(+), 118 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 03cc508..2b17e8b 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -131,11 +131,6 @@ struct dvb_frontend_private {
 	int quality;
 	unsigned int check_wrapped;
 	enum dvbfe_search algo_status;
-
-#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
-	struct media_pipeline pipe;
-	struct media_entity *pipe_start_entity;
-#endif
 };
 
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
@@ -596,104 +591,12 @@ static void dvb_frontend_wakeup(struct dvb_frontend *fe)
 	wake_up_interruptible(&fepriv->wait_queue);
 }
 
-/**
- * dvb_enable_media_tuner() - tries to enable the DVB tuner
- *
- * @fe:		struct dvb_frontend pointer
- *
- * This function ensures that just one media tuner is enabled for a given
- * frontend. It has two different behaviors:
- * - For trivial devices with just one tuner:
- *   it just enables the existing tuner->fe link
- * - For devices with more than one tuner:
- *   It is up to the driver to implement the logic that will enable one tuner
- *   and disable the other ones. However, if more than one tuner is enabled for
- *   the same frontend, it will print an error message and return -EINVAL.
- *
- * At return, it will return the error code returned by media_entity_setup_link,
- * or 0 if everything is OK, if no tuner is linked to the frontend or if the
- * mdev is NULL.
- */
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-static int dvb_enable_media_tuner(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_adapter *adapter = fe->dvb;
-	struct media_device *mdev = adapter->mdev;
-	struct media_entity  *entity, *source;
-	struct media_link *link, *found_link = NULL;
-	int ret, n_links = 0, active_links = 0;
-
-	fepriv->pipe_start_entity = NULL;
-
-	if (!mdev)
-		return 0;
-
-	entity = fepriv->dvbdev->entity;
-	fepriv->pipe_start_entity = entity;
-
-	list_for_each_entry(link, &entity->links, list) {
-		if (link->sink->entity == entity) {
-			found_link = link;
-			n_links++;
-			if (link->flags & MEDIA_LNK_FL_ENABLED)
-				active_links++;
-		}
-	}
-
-	if (!n_links || active_links == 1 || !found_link)
-		return 0;
-
-	/*
-	 * If a frontend has more than one tuner linked, it is up to the driver
-	 * to select with one will be the active one, as the frontend core can't
-	 * guess. If the driver doesn't do that, it is a bug.
-	 */
-	if (n_links > 1 && active_links != 1) {
-		dev_err(fe->dvb->device,
-			"WARNING: there are %d active links among %d tuners. This is a driver's bug!\n",
-			active_links, n_links);
-		return -EINVAL;
-	}
-
-	source = found_link->source->entity;
-	fepriv->pipe_start_entity = source;
-	list_for_each_entry(link, &source->links, list) {
-		struct media_entity *sink;
-		int flags = 0;
-
-		sink = link->sink->entity;
-		if (sink == entity)
-			flags = MEDIA_LNK_FL_ENABLED;
-
-		ret = media_entity_setup_link(link, flags);
-		if (ret) {
-			dev_err(fe->dvb->device,
-				"Couldn't change link %s->%s to %s. Error %d\n",
-				source->name, sink->name,
-				flags ? "enabled" : "disabled",
-				ret);
-			return ret;
-		} else
-			dev_dbg(fe->dvb->device,
-				"link %s->%s was %s\n",
-				source->name, sink->name,
-				flags ? "ENABLED" : "disabled");
-	}
-	return 0;
-}
-#endif
-
 static int dvb_frontend_thread(void *data)
 {
 	struct dvb_frontend *fe = data;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	enum fe_status s;
 	enum dvbfe_algo algo;
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	int ret;
-#endif
-
 	bool re_tune = false;
 	bool semheld = false;
 
@@ -706,20 +609,6 @@ static int dvb_frontend_thread(void *data)
 	fepriv->wakeup = 0;
 	fepriv->reinitialise = 0;
 
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	ret = dvb_enable_media_tuner(fe);
-	if (ret) {
-		/* FIXME: return an error if it fails */
-		dev_info(fe->dvb->device,
-			"proceeding with FE task\n");
-	} else if (fepriv->pipe_start_entity) {
-		ret = media_entity_pipeline_start(fepriv->pipe_start_entity,
-						  &fepriv->pipe);
-		if (ret)
-			return ret;
-	}
-#endif
-
 	dvb_frontend_init(fe);
 
 	set_freezable();
@@ -829,12 +718,6 @@ restart:
 		}
 	}
 
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	if (fepriv->pipe_start_entity)
-		media_entity_pipeline_stop(fepriv->pipe_start_entity);
-	fepriv->pipe_start_entity = NULL;
-#endif
-
 	if (dvb_powerdown_on_sleep) {
 		if (fe->ops.set_voltage)
 			fe->ops.set_voltage(fe, SEC_VOLTAGE_OFF);
@@ -2612,9 +2495,20 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->tone = -1;
 		fepriv->voltage = -1;
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		if (fe->dvb->mdev && fe->dvb->mdev->enable_source) {
+			ret = fe->dvb->mdev->enable_source(dvbdev->entity,
+							   &fe->pipe);
+			if (ret) {
+				dev_err(fe->dvb->device,
+					"Tuner is busy. Error %d\n", ret);
+				goto err2;
+			}
+		}
+#endif
 		ret = dvb_frontend_start (fe);
 		if (ret)
-			goto err2;
+			goto err3;
 
 		/*  empty event queue */
 		fepriv->events.eventr = fepriv->events.eventw = 0;
@@ -2624,7 +2518,12 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		mutex_unlock (&adapter->mfe_lock);
 	return ret;
 
+err3:
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
+		fe->dvb->mdev->disable_source(dvbdev->entity);
 err2:
+#endif
 	dvb_generic_release(inode, file);
 err1:
 	if (dvbdev->users == -1 && fe->ops.ts_bus_ctrl)
@@ -2653,6 +2552,10 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 
 	if (dvbdev->users == -1) {
 		wake_up(&fepriv->wait_queue);
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
+			fe->dvb->mdev->disable_source(dvbdev->entity);
+#endif
 		if (fe->exit != DVB_FE_NO_EXIT)
 			wake_up(&dvbdev->wait_queue);
 		if (fe->ops.ts_bus_ctrl)
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 458bcce..9466906 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -686,6 +686,9 @@ struct dvb_frontend {
 	int (*callback)(void *adapter_priv, int component, int cmd, int arg);
 	int id;
 	unsigned int exit;
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	struct media_pipeline pipe;
+#endif
 };
 
 /**
-- 
2.5.0
