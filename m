From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 23/26] [media] dvb: frontend.h: improve dvb_frontent_parameters comment
Date: Mon,  8 Jun 2015 16:54:07 -0300
Message-ID: <a1904073e0652eb6745454df7b5a2087355980e8.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The comment for struct dvb_frontend_parameters is weird, as it
mixes delivery system name (ATSC) with modulation names
(QPSK, QAM, OFDM).

Use delivery system names there on the frequency comment, as this
is clearer, specially after 2GEN delivery systems.

While here, add comments at the union, to make live easier for ones
that may try to understand the convention used by the legacy API.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 0380e62fc8b2..e764fd8b7e35 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -540,14 +540,14 @@ struct dvb_ofdm_parameters {
 };
 
 struct dvb_frontend_parameters {
-	__u32 frequency;     /* (absolute) frequency in Hz for QAM/OFDM/ATSC */
-			     /* intermediate frequency in kHz for QPSK */
+	__u32 frequency;     /* (absolute) frequency in Hz for DVB-C/DVB-T/ATSC */
+			     /* intermediate frequency in kHz for DVB-S */
 	fe_spectral_inversion_t inversion;
 	union {
-		struct dvb_qpsk_parameters qpsk;
-		struct dvb_qam_parameters  qam;
-		struct dvb_ofdm_parameters ofdm;
-		struct dvb_vsb_parameters vsb;
+		struct dvb_qpsk_parameters qpsk;	/* DVB-S */
+		struct dvb_qam_parameters  qam;		/* DVB-C */
+		struct dvb_ofdm_parameters ofdm;	/* DVB-T */
+		struct dvb_vsb_parameters vsb;		/* ATSC */
 	} u;
 };
 
-- 
2.4.2
