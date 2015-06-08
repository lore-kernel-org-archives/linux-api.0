From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 19/26] [media] frontend: Move legacy API enums/structs to the end
Date: Mon,  8 Jun 2015 16:54:03 -0300
Message-ID: <d72865fabce0ebd6fcce1a122a78b54be29df977.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

In order to better organize the header file, move the legacy
API (DVBv3) support to the end, just before the ioctl definitions.

This way, we can use just one #if for all of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 7f829c92dd64..75605a7670a9 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -216,19 +216,6 @@ enum fe_transmit_mode {
 
 typedef enum fe_transmit_mode fe_transmit_mode_t;
 
-#if defined(__DVB_CORE__) || !defined (__KERNEL__)
-enum fe_bandwidth {
-	BANDWIDTH_8_MHZ,
-	BANDWIDTH_7_MHZ,
-	BANDWIDTH_6_MHZ,
-	BANDWIDTH_AUTO,
-	BANDWIDTH_5_MHZ,
-	BANDWIDTH_10_MHZ,
-	BANDWIDTH_1_712_MHZ,
-};
-
-typedef enum fe_bandwidth fe_bandwidth_t;
-#endif
 
 enum fe_guard_interval {
 	GUARD_INTERVAL_1_32,
@@ -263,51 +250,6 @@ enum fe_interleaving {
 	INTERLEAVING_720,
 };
 
-#if defined(__DVB_CORE__) || !defined (__KERNEL__)
-struct dvb_qpsk_parameters {
-	__u32		symbol_rate;  /* symbol rate in Symbols per second */
-	fe_code_rate_t	fec_inner;    /* forward error correction (see above) */
-};
-
-struct dvb_qam_parameters {
-	__u32		symbol_rate; /* symbol rate in Symbols per second */
-	fe_code_rate_t	fec_inner;   /* forward error correction (see above) */
-	fe_modulation_t	modulation;  /* modulation type (see above) */
-};
-
-struct dvb_vsb_parameters {
-	fe_modulation_t	modulation;  /* modulation type (see above) */
-};
-
-struct dvb_ofdm_parameters {
-	fe_bandwidth_t      bandwidth;
-	fe_code_rate_t      code_rate_HP;  /* high priority stream code rate */
-	fe_code_rate_t      code_rate_LP;  /* low priority stream code rate */
-	fe_modulation_t     constellation; /* modulation type (see above) */
-	fe_transmit_mode_t  transmission_mode;
-	fe_guard_interval_t guard_interval;
-	fe_hierarchy_t      hierarchy_information;
-};
-
-
-struct dvb_frontend_parameters {
-	__u32 frequency;     /* (absolute) frequency in Hz for QAM/OFDM/ATSC */
-			     /* intermediate frequency in kHz for QPSK */
-	fe_spectral_inversion_t inversion;
-	union {
-		struct dvb_qpsk_parameters qpsk;
-		struct dvb_qam_parameters  qam;
-		struct dvb_ofdm_parameters ofdm;
-		struct dvb_vsb_parameters vsb;
-	} u;
-};
-
-struct dvb_frontend_event {
-	fe_status_t status;
-	struct dvb_frontend_parameters parameters;
-};
-#endif
-
 /* S2API Commands */
 #define DTV_UNDEFINED		0
 #define DTV_TUNE		1
@@ -582,6 +524,64 @@ struct dtv_properties {
 	struct dtv_property *props;
 };
 
+#if defined(__DVB_CORE__) || !defined (__KERNEL__)
+
+enum fe_bandwidth {
+	BANDWIDTH_8_MHZ,
+	BANDWIDTH_7_MHZ,
+	BANDWIDTH_6_MHZ,
+	BANDWIDTH_AUTO,
+	BANDWIDTH_5_MHZ,
+	BANDWIDTH_10_MHZ,
+	BANDWIDTH_1_712_MHZ,
+};
+
+typedef enum fe_bandwidth fe_bandwidth_t;
+
+struct dvb_qpsk_parameters {
+	__u32		symbol_rate;  /* symbol rate in Symbols per second */
+	fe_code_rate_t	fec_inner;    /* forward error correction (see above) */
+};
+
+struct dvb_qam_parameters {
+	__u32		symbol_rate; /* symbol rate in Symbols per second */
+	fe_code_rate_t	fec_inner;   /* forward error correction (see above) */
+	fe_modulation_t	modulation;  /* modulation type (see above) */
+};
+
+struct dvb_vsb_parameters {
+	fe_modulation_t	modulation;  /* modulation type (see above) */
+};
+
+struct dvb_ofdm_parameters {
+	fe_bandwidth_t      bandwidth;
+	fe_code_rate_t      code_rate_HP;  /* high priority stream code rate */
+	fe_code_rate_t      code_rate_LP;  /* low priority stream code rate */
+	fe_modulation_t     constellation; /* modulation type (see above) */
+	fe_transmit_mode_t  transmission_mode;
+	fe_guard_interval_t guard_interval;
+	fe_hierarchy_t      hierarchy_information;
+};
+
+
+struct dvb_frontend_parameters {
+	__u32 frequency;     /* (absolute) frequency in Hz for QAM/OFDM/ATSC */
+			     /* intermediate frequency in kHz for QPSK */
+	fe_spectral_inversion_t inversion;
+	union {
+		struct dvb_qpsk_parameters qpsk;
+		struct dvb_qam_parameters  qam;
+		struct dvb_ofdm_parameters ofdm;
+		struct dvb_vsb_parameters vsb;
+	} u;
+};
+
+struct dvb_frontend_event {
+	fe_status_t status;
+	struct dvb_frontend_parameters parameters;
+};
+#endif
+
 #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
 #define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
 
-- 
2.4.2
