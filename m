From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2 02/22] media: Add ALSA Media Controller function entities
Date: Wed,  3 Feb 2016 21:03:34 -0700
Message-ID: <7e6aa938056da01e75f1e9d844f621baf47ffa74.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs-mcfjX3dozePR7s880joybQ@public.gmane.org, johan-v8HUHnYb0Yo@public.gmane.org, klock.android-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nenggun.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, j.anaszewski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, geliangtang
List-Id: linux-api@vger.kernel.org

Add ALSA Media Controller capture, playback, and mixer
function entity defines.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 include/uapi/linux/media.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index ee020e8..7d50480 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -98,6 +98,17 @@ struct media_device_info {
 #define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 42)
 
 /*
+ * DOC: Media Controller Next Generation ALSA Function Entities
+ *
+ * MEDIA_ENT_F_AUDIO_CAPTURE - Audio Capture Function
+ * MEDIA_ENT_F_AUDIO_PLAYBACK - Audio Play Back Function
+ * MEDIA_ENT_F_AUDIO_MIXER - Audio Mixer Function
+*/
+#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 200)
+#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 201)
+#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 202)
+
+/*
  * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
  * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
  * with the legacy v1 API.The number range is out of range by purpose:
-- 
2.5.0
