From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v8 bpf-next 3/9] net/mac802154: disambiguate mac80215 vs mac802154 trace events
Date: Wed, 28 Mar 2018 12:05:34 -0700
Message-ID: <20180328190540.370956-4-ast@kernel.org>
References: <20180328190540.370956-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328190540.370956-1-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

two trace events defined with the same name and both unused.
They conflict in allyesconfig build. Rename one of them.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 net/mac802154/trace.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac802154/trace.h b/net/mac802154/trace.h
index 2c8a43d3607f..df855c33daf2 100644
--- a/net/mac802154/trace.h
+++ b/net/mac802154/trace.h
@@ -33,7 +33,7 @@
 
 /* Tracing for driver callbacks */
 
-DECLARE_EVENT_CLASS(local_only_evt,
+DECLARE_EVENT_CLASS(local_only_evt4,
 	TP_PROTO(struct ieee802154_local *local),
 	TP_ARGS(local),
 	TP_STRUCT__entry(
@@ -45,7 +45,7 @@ DECLARE_EVENT_CLASS(local_only_evt,
 	TP_printk(LOCAL_PR_FMT, LOCAL_PR_ARG)
 );
 
-DEFINE_EVENT(local_only_evt, 802154_drv_return_void,
+DEFINE_EVENT(local_only_evt4, 802154_drv_return_void,
 	TP_PROTO(struct ieee802154_local *local),
 	TP_ARGS(local)
 );
@@ -65,12 +65,12 @@ TRACE_EVENT(802154_drv_return_int,
 		  __entry->ret)
 );
 
-DEFINE_EVENT(local_only_evt, 802154_drv_start,
+DEFINE_EVENT(local_only_evt4, 802154_drv_start,
 	TP_PROTO(struct ieee802154_local *local),
 	TP_ARGS(local)
 );
 
-DEFINE_EVENT(local_only_evt, 802154_drv_stop,
+DEFINE_EVENT(local_only_evt4, 802154_drv_stop,
 	TP_PROTO(struct ieee802154_local *local),
 	TP_ARGS(local)
 );
-- 
2.9.5
