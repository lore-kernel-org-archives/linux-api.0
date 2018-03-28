From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v8 bpf-next 1/9] treewide: remove large struct-pass-by-value from tracepoint arguments
Date: Wed, 28 Mar 2018 12:05:32 -0700
Message-ID: <20180328190540.370956-2-ast@kernel.org>
References: <20180328190540.370956-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328190540.370956-1-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

- fix trace_hfi1_ctxt_info() to pass large struct by reference instead of by value
- convert 'type array[]' tracepoint arguments into 'type *array',
  since compiler will warn that sizeof('type array[]') == sizeof('type *array')
  and later should be used instead

The CAST_TO_U64 macro in the later patch will enforce that tracepoint
arguments can only be integers, pointers, or less than 8 byte structures.
Larger structures should be passed by reference.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c    |  2 +-
 drivers/infiniband/hw/hfi1/trace_ctxts.h | 12 ++++++------
 include/trace/events/f2fs.h              |  2 +-
 net/wireless/trace.h                     |  2 +-
 sound/firewire/amdtp-stream-trace.h      |  2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 41fafebe3b0d..da4aa1a95b11 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1153,7 +1153,7 @@ static int get_ctxt_info(struct hfi1_filedata *fd, unsigned long arg, u32 len)
 	cinfo.sdma_ring_size = fd->cq->nentries;
 	cinfo.rcvegr_size = uctxt->egrbufs.rcvtid_size;
 
-	trace_hfi1_ctxt_info(uctxt->dd, uctxt->ctxt, fd->subctxt, cinfo);
+	trace_hfi1_ctxt_info(uctxt->dd, uctxt->ctxt, fd->subctxt, &cinfo);
 	if (copy_to_user((void __user *)arg, &cinfo, len))
 		return -EFAULT;
 
diff --git a/drivers/infiniband/hw/hfi1/trace_ctxts.h b/drivers/infiniband/hw/hfi1/trace_ctxts.h
index 4eb4cc798035..e00c8a7d559c 100644
--- a/drivers/infiniband/hw/hfi1/trace_ctxts.h
+++ b/drivers/infiniband/hw/hfi1/trace_ctxts.h
@@ -106,7 +106,7 @@ TRACE_EVENT(hfi1_uctxtdata,
 TRACE_EVENT(hfi1_ctxt_info,
 	    TP_PROTO(struct hfi1_devdata *dd, unsigned int ctxt,
 		     unsigned int subctxt,
-		     struct hfi1_ctxt_info cinfo),
+		     struct hfi1_ctxt_info *cinfo),
 	    TP_ARGS(dd, ctxt, subctxt, cinfo),
 	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
 			     __field(unsigned int, ctxt)
@@ -120,11 +120,11 @@ TRACE_EVENT(hfi1_ctxt_info,
 	    TP_fast_assign(DD_DEV_ASSIGN(dd);
 			    __entry->ctxt = ctxt;
 			    __entry->subctxt = subctxt;
-			    __entry->egrtids = cinfo.egrtids;
-			    __entry->rcvhdrq_cnt = cinfo.rcvhdrq_cnt;
-			    __entry->rcvhdrq_size = cinfo.rcvhdrq_entsize;
-			    __entry->sdma_ring_size = cinfo.sdma_ring_size;
-			    __entry->rcvegr_size = cinfo.rcvegr_size;
+			    __entry->egrtids = cinfo->egrtids;
+			    __entry->rcvhdrq_cnt = cinfo->rcvhdrq_cnt;
+			    __entry->rcvhdrq_size = cinfo->rcvhdrq_entsize;
+			    __entry->sdma_ring_size = cinfo->sdma_ring_size;
+			    __entry->rcvegr_size = cinfo->rcvegr_size;
 			    ),
 	    TP_printk("[%s] ctxt %u:%u " CINFO_FMT,
 		      __get_str(dev),
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 06c87f9f720c..795698925d20 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -491,7 +491,7 @@ DEFINE_EVENT(f2fs__truncate_node, f2fs_truncate_node,
 
 TRACE_EVENT(f2fs_truncate_partial_nodes,
 
-	TP_PROTO(struct inode *inode, nid_t nid[], int depth, int err),
+	TP_PROTO(struct inode *inode, nid_t *nid, int depth, int err),
 
 	TP_ARGS(inode, nid, depth, err),
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5152938b358d..018c81fa72fb 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3137,7 +3137,7 @@ TRACE_EVENT(rdev_start_radar_detection,
 
 TRACE_EVENT(rdev_set_mcast_rate,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 int mcast_rate[NUM_NL80211_BANDS]),
+		 int *mcast_rate),
 	TP_ARGS(wiphy, netdev, mcast_rate),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
diff --git a/sound/firewire/amdtp-stream-trace.h b/sound/firewire/amdtp-stream-trace.h
index ea0d486652c8..54cdd4ffa9ce 100644
--- a/sound/firewire/amdtp-stream-trace.h
+++ b/sound/firewire/amdtp-stream-trace.h
@@ -14,7 +14,7 @@
 #include <linux/tracepoint.h>
 
 TRACE_EVENT(in_packet,
-	TP_PROTO(const struct amdtp_stream *s, u32 cycles, u32 cip_header[2], unsigned int payload_length, unsigned int index),
+	TP_PROTO(const struct amdtp_stream *s, u32 cycles, u32 *cip_header, unsigned int payload_length, unsigned int index),
 	TP_ARGS(s, cycles, cip_header, payload_length, index),
 	TP_STRUCT__entry(
 		__field(unsigned int, second)
-- 
2.9.5
