From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 17/36] uapi linux/sctp.h: use __u8, __u16 and __u32 from linux/types.h
Date: Sun,  6 Aug 2017 18:44:08 +0200
Message-ID: <20170806164428.2273-18-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Phil Sutter <phil@nwl.cc>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation errors like:

linux/sctp.h:652:2: error: unknown type name ‘uint32_t’

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/sctp.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6217ff8500a1..d8b83fd56572 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -805,13 +805,13 @@ struct sctp_authkeyid {
  */
 struct sctp_sack_info {
 	sctp_assoc_t	sack_assoc_id;
-	uint32_t	sack_delay;
-	uint32_t	sack_freq;
+	__u32	sack_delay;
+	__u32	sack_freq;
 };
 
 struct sctp_assoc_value {
-    sctp_assoc_t            assoc_id;
-    uint32_t                assoc_value;
+	sctp_assoc_t	assoc_id;
+	__u32		assoc_value;
 };
 
 /*
@@ -881,7 +881,7 @@ struct sctp_status {
 struct sctp_authchunks {
 	sctp_assoc_t	gauth_assoc_id;
 	__u32		gauth_number_of_chunks;
-	uint8_t		gauth_chunks[];
+	__u8		gauth_chunks[];
 };
 
 /* The broken spelling has been released already in lksctp-tools header,
@@ -1077,15 +1077,15 @@ struct sctp_info {
 
 struct sctp_reset_streams {
 	sctp_assoc_t srs_assoc_id;
-	uint16_t srs_flags;
-	uint16_t srs_number_streams;	/* 0 == ALL */
-	uint16_t srs_stream_list[];	/* list if srs_num_streams is not 0 */
+	__u16 srs_flags;
+	__u16 srs_number_streams;	/* 0 == ALL */
+	__u16 srs_stream_list[];	/* list if srs_num_streams is not 0 */
 };
 
 struct sctp_add_streams {
 	sctp_assoc_t sas_assoc_id;
-	uint16_t sas_instrms;
-	uint16_t sas_outstrms;
+	__u16 sas_instrms;
+	__u16 sas_outstrms;
 };
 
 #endif /* _UAPI_SCTP_H */
-- 
2.13.3
