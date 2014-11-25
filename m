From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v4 40/42] virtio_scsi: export to userspace
Date: Tue, 25 Nov 2014 18:44:16 +0200
Message-ID: <1416933600-21398-41-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com, Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexei Starovoitov <ast@plumgrid.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, =?us-ascii?B?PT9VVEYtOD9xP1Bpb3RyPTIwS3I9QzM9QjNsPz0=?= <piotr.krol@3mdeb.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Andy Grover <agrover@redhat.com>, stephen hemminger <stephen@networkplumber.org>, Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Replace uXX by __uXX and _packed by __attribute((packed))
as seems to be the norm for userspace headers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_scsi.h | 74 ++++++++++++++++++++--------------------
 include/uapi/linux/Kbuild        |  1 +
 2 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/include/uapi/linux/virtio_scsi.h b/include/uapi/linux/virtio_scsi.h
index af44864..42b9370 100644
--- a/include/uapi/linux/virtio_scsi.h
+++ b/include/uapi/linux/virtio_scsi.h
@@ -34,78 +34,78 @@
 
 /* SCSI command request, followed by data-out */
 struct virtio_scsi_cmd_req {
-	u8 lun[8];		/* Logical Unit Number */
+	__u8 lun[8];		/* Logical Unit Number */
 	__virtio64 tag;		/* Command identifier */
-	u8 task_attr;		/* Task attribute */
-	u8 prio;		/* SAM command priority field */
-	u8 crn;
-	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
-} __packed;
+	__u8 task_attr;		/* Task attribute */
+	__u8 prio;		/* SAM command priority field */
+	__u8 crn;
+	__u8 cdb[VIRTIO_SCSI_CDB_SIZE];
+} __attribute__((packed));
 
 /* SCSI command request, followed by protection information */
 struct virtio_scsi_cmd_req_pi {
-	u8 lun[8];		/* Logical Unit Number */
+	__u8 lun[8];		/* Logical Unit Number */
 	__virtio64 tag;		/* Command identifier */
-	u8 task_attr;		/* Task attribute */
-	u8 prio;		/* SAM command priority field */
-	u8 crn;
+	__u8 task_attr;		/* Task attribute */
+	__u8 prio;		/* SAM command priority field */
+	__u8 crn;
 	__virtio32 pi_bytesout;	/* DataOUT PI Number of bytes */
 	__virtio32 pi_bytesin;		/* DataIN PI Number of bytes */
-	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
-} __packed;
+	__u8 cdb[VIRTIO_SCSI_CDB_SIZE];
+} __attribute__((packed));
 
 /* Response, followed by sense data and data-in */
 struct virtio_scsi_cmd_resp {
 	__virtio32 sense_len;		/* Sense data length */
 	__virtio32 resid;		/* Residual bytes in data buffer */
 	__virtio16 status_qualifier;	/* Status qualifier */
-	u8 status;		/* Command completion status */
-	u8 response;		/* Response values */
-	u8 sense[VIRTIO_SCSI_SENSE_SIZE];
-} __packed;
+	__u8 status;		/* Command completion status */
+	__u8 response;		/* Response values */
+	__u8 sense[VIRTIO_SCSI_SENSE_SIZE];
+} __attribute__((packed));
 
 /* Task Management Request */
 struct virtio_scsi_ctrl_tmf_req {
 	__virtio32 type;
 	__virtio32 subtype;
-	u8 lun[8];
+	__u8 lun[8];
 	__virtio64 tag;
-} __packed;
+} __attribute__((packed));
 
 struct virtio_scsi_ctrl_tmf_resp {
-	u8 response;
-} __packed;
+	__u8 response;
+} __attribute__((packed));
 
 /* Asynchronous notification query/subscription */
 struct virtio_scsi_ctrl_an_req {
 	__virtio32 type;
-	u8 lun[8];
+	__u8 lun[8];
 	__virtio32 event_requested;
-} __packed;
+} __attribute__((packed));
 
 struct virtio_scsi_ctrl_an_resp {
 	__virtio32 event_actual;
-	u8 response;
-} __packed;
+	__u8 response;
+} __attribute__((packed));
 
 struct virtio_scsi_event {
 	__virtio32 event;
-	u8 lun[8];
+	__u8 lun[8];
 	__virtio32 reason;
-} __packed;
+} __attribute__((packed));
 
 struct virtio_scsi_config {
-	u32 num_queues;
-	u32 seg_max;
-	u32 max_sectors;
-	u32 cmd_per_lun;
-	u32 event_info_size;
-	u32 sense_size;
-	u32 cdb_size;
-	u16 max_channel;
-	u16 max_target;
-	u32 max_lun;
-} __packed;
+	__u32 num_queues;
+	__u32 seg_max;
+	__u32 max_sectors;
+	__u32 cmd_per_lun;
+	__u32 event_info_size;
+	__u32 sense_size;
+	__u32 cdb_size;
+	__u16 max_channel;
+	__u16 max_target;
+	__u32 max_lun;
+} __attribute__((packed));
 
 /* Feature Bits */
 #define VIRTIO_SCSI_F_INOUT                    0
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 44a5581..e61947c 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -428,6 +428,7 @@ header-y += virtio_net.h
 header-y += virtio_pci.h
 header-y += virtio_ring.h
 header-y += virtio_rng.h
+header-y += virtio_scsi.h
 header=y += vm_sockets.h
 header-y += vt.h
 header-y += wait.h
-- 
MST
