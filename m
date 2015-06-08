From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 20/26] [media] frontend: move legacy typedefs to the end
Date: Mon,  8 Jun 2015 16:54:04 -0300
Message-ID: <96789e868da2ee3a5c04e705f002f3932371167e.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Just userspace need those typedefs. So, put it in the compat part
of the header.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 75605a7670a9..46c7fd1143a5 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -35,9 +35,6 @@ enum fe_type {
 	FE_ATSC
 };
 
-typedef enum fe_type fe_type_t;
-
-
 enum fe_caps {
 	FE_IS_STUPID			= 0,
 	FE_CAN_INVERSION_AUTO		= 0x1,
@@ -72,9 +69,6 @@ enum fe_caps {
 	FE_CAN_MUTE_TS			= 0x80000000  /* frontend can stop spurious TS data output */
 };
 
-typedef enum fe_caps fe_caps_t;
-
-
 struct dvb_frontend_info {
 	char       name[128];
 	enum fe_type type;	/* DEPRECATED. Use DTV_ENUM_DELSYS instead */
@@ -99,39 +93,28 @@ struct dvb_diseqc_master_cmd {
 	__u8 msg_len;	/*  valid values are 3...6  */
 };
 
-
 struct dvb_diseqc_slave_reply {
 	__u8 msg [4];	/*  { framing, data [3] } */
 	__u8 msg_len;	/*  valid values are 0...4, 0 means no msg  */
 	int  timeout;	/*  return from ioctl after timeout ms with */
 };			/*  errorcode when no message was received  */
 
-
 enum fe_sec_voltage {
 	SEC_VOLTAGE_13,
 	SEC_VOLTAGE_18,
 	SEC_VOLTAGE_OFF
 };
 
-typedef enum fe_sec_voltage fe_sec_voltage_t;
-
-
 enum fe_sec_tone_mode {
 	SEC_TONE_ON,
 	SEC_TONE_OFF
 };
 
-typedef enum fe_sec_tone_mode fe_sec_tone_mode_t;
-
-
 enum fe_sec_mini_cmd {
 	SEC_MINI_A,
 	SEC_MINI_B
 };
 
-typedef enum fe_sec_mini_cmd fe_sec_mini_cmd_t;
-
-
 /**
  * enum fe_status - enumerates the possible frontend status
  * @FE_HAS_SIGNAL:	found something above the noise level
@@ -143,7 +126,6 @@ typedef enum fe_sec_mini_cmd fe_sec_mini_cmd_t;
  * @FE_REINIT:		frontend was reinitialized, application is recommended
  *			to reset DiSEqC, tone and parameters
  */
-
 enum fe_status {
 	FE_HAS_SIGNAL		= 0x01,
 	FE_HAS_CARRIER		= 0x02,
@@ -154,16 +136,12 @@ enum fe_status {
 	FE_REINIT		= 0x40,
 };
 
-typedef enum fe_status fe_status_t;
-
 enum fe_spectral_inversion {
 	INVERSION_OFF,
 	INVERSION_ON,
 	INVERSION_AUTO
 };
 
-typedef enum fe_spectral_inversion fe_spectral_inversion_t;
-
 enum fe_code_rate {
 	FEC_NONE = 0,
 	FEC_1_2,
@@ -180,9 +158,6 @@ enum fe_code_rate {
 	FEC_2_5,
 };
 
-typedef enum fe_code_rate fe_code_rate_t;
-
-
 enum fe_modulation {
 	QPSK,
 	QAM_16,
@@ -200,8 +175,6 @@ enum fe_modulation {
 	QAM_4_NR,
 };
 
-typedef enum fe_modulation fe_modulation_t;
-
 enum fe_transmit_mode {
 	TRANSMISSION_MODE_2K,
 	TRANSMISSION_MODE_8K,
@@ -214,9 +187,6 @@ enum fe_transmit_mode {
 	TRANSMISSION_MODE_C3780,
 };
 
-typedef enum fe_transmit_mode fe_transmit_mode_t;
-
-
 enum fe_guard_interval {
 	GUARD_INTERVAL_1_32,
 	GUARD_INTERVAL_1_16,
@@ -231,8 +201,6 @@ enum fe_guard_interval {
 	GUARD_INTERVAL_PN945,
 };
 
-typedef enum fe_guard_interval fe_guard_interval_t;
-
 enum fe_hierarchy {
 	HIERARCHY_NONE,
 	HIERARCHY_1,
@@ -241,8 +209,6 @@ enum fe_hierarchy {
 	HIERARCHY_AUTO
 };
 
-typedef enum fe_hierarchy fe_hierarchy_t;
-
 enum fe_interleaving {
 	INTERLEAVING_NONE,
 	INTERLEAVING_AUTO,
@@ -349,8 +315,6 @@ enum fe_pilot {
 	PILOT_AUTO,
 };
 
-typedef enum fe_pilot fe_pilot_t;
-
 enum fe_rolloff {
 	ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
 	ROLLOFF_20,
@@ -358,8 +322,6 @@ enum fe_rolloff {
 	ROLLOFF_AUTO,
 };
 
-typedef enum fe_rolloff fe_rolloff_t;
-
 enum fe_delivery_system {
 	SYS_UNDEFINED,
 	SYS_DVBC_ANNEX_A,
@@ -382,8 +344,6 @@ enum fe_delivery_system {
 	SYS_DVBC_ANNEX_C,
 };
 
-typedef enum fe_delivery_system fe_delivery_system_t;
-
 /* backward compatibility */
 #define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
 #define SYS_DMBTH SYS_DTMB /* DMB-TH is legacy name, use DTMB instead */
@@ -536,7 +496,23 @@ enum fe_bandwidth {
 	BANDWIDTH_1_712_MHZ,
 };
 
+/* This is needed for legacy userspace support */
+typedef enum fe_sec_voltage fe_sec_voltage_t;
+typedef enum fe_caps fe_caps_t;
+typedef enum fe_type fe_type_t;
+typedef enum fe_sec_tone_mode fe_sec_tone_mode_t;
+typedef enum fe_sec_mini_cmd fe_sec_mini_cmd_t;
+typedef enum fe_status fe_status_t;
+typedef enum fe_spectral_inversion fe_spectral_inversion_t;
+typedef enum fe_code_rate fe_code_rate_t;
+typedef enum fe_modulation fe_modulation_t;
+typedef enum fe_transmit_mode fe_transmit_mode_t;
 typedef enum fe_bandwidth fe_bandwidth_t;
+typedef enum fe_guard_interval fe_guard_interval_t;
+typedef enum fe_hierarchy fe_hierarchy_t;
+typedef enum fe_pilot fe_pilot_t;
+typedef enum fe_rolloff fe_rolloff_t;
+typedef enum fe_delivery_system fe_delivery_system_t;
 
 struct dvb_qpsk_parameters {
 	__u32		symbol_rate;  /* symbol rate in Symbols per second */
@@ -563,7 +539,6 @@ struct dvb_ofdm_parameters {
 	fe_hierarchy_t      hierarchy_information;
 };
 
-
 struct dvb_frontend_parameters {
 	__u32 frequency;     /* (absolute) frequency in Hz for QAM/OFDM/ATSC */
 			     /* intermediate frequency in kHz for QPSK */
@@ -585,7 +560,6 @@ struct dvb_frontend_event {
 #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
 #define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
 
-
 /**
  * When set, this flag will disable any zigzagging or other "normal" tuning
  * behaviour. Additionally, there will be no automatic monitoring of the lock
@@ -595,7 +569,6 @@ struct dvb_frontend_event {
  */
 #define FE_TUNE_MODE_ONESHOT 0x01
 
-
 #define FE_GET_INFO		   _IOR('o', 61, struct dvb_frontend_info)
 
 #define FE_DISEQC_RESET_OVERLOAD   _IO('o', 62)
-- 
2.4.2
